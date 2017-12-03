//
//  AccountHelper.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

protocol AccountHelperDelegate: class {
    
    func updateTimeline(_ posts: [Post])
}

/// MARK: - Account Helper
/// Usage:
///  - シングルトンになっているのでAccountHelper.sharedで読んであげる
///  - ログインはlogInで行える。Delegateはシングルトン自身
///  - 最初はなんのデータも持っていない
///  - ログインをした後、データが50件フェッチされuserInfoにユーザーの情報が格納される
///  - タイムラインは自動更新、自分の投稿したものはfetchQueryで明示的に呼んであげる
///  - ソートする場合はsortedQueryを使う
///  - アイコンは登録後に設定してもらう感じで
class AccountHelper: NSObject {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!

    private var ref: DocumentReference?
    private var listener: ListenerRegistration?
    /// Timeline query
    internal var query: Query? {
        
        didSet {
            
            if let listener = listener {
                
                listener.remove()
                observeQuery()
            }
        }
    }
    
    /// Account Helper Delegate
    weak var delegate: AccountHelperDelegate?
    /// Timeline
    var posts: [Post] = []
    /// Current user name and icon
    var userInfo: UserInfo?
    
    private override init() {
        
        self.defaultStore = Firestore.firestore()
        super.init()
    }
    
    deinit {
        
        listener?.remove()
    }
    
    /// Judge log in
    internal var isLogIn: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    /// Login interface
    internal func logIn() {
        
        guard let auth = FUIAuth.defaultAuthUI() else {
            
            print("Auth Error")
            return
        }
        
        auth.delegate = self
        
        if auth.auth?.currentUser == nil {
            
            auth.providers = []
            UIApplication.shared.topPresentedViewController?.present(auth.authViewController(), animated: true, completion: nil)
            return
        }
    }
    
    /// Start query observing
    internal func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Post in
                if let model = Post(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                }
            }
            
            self.posts = models
            self.delegate?.updateTimeline(self.posts)
        }
    }
    
    /// Stop query observing
    internal func stopObserving() {
        
        listener?.remove()
    }
    
    /// Fetch Query for key and limit
    internal func fetchQuery(for key: String, limit: Int? = nil) -> Query {
        
        guard let limit = limit else {
            
            return defaultStore.collection(key)
        }
        
        return defaultStore.collection(key).limit(to: limit)
    }
    
    /// Post Data
    /// Arguments: location and photo, message, and completion
    internal func postData(location: CLLocation, photo: UIImage, message: String, completion: @escaping ()->()) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        var imageCount: Int
        if let count = cache.object(forKey: "imageCount") as? Int {
            
            imageCount = count + 1
        } else {
            
            imageCount = 0
        }
        cache.set(imageCount, forKey: "imageCount")
        let imageRef = Storage.storage().reference().child("images/\(user.uid)_\(imageCount).png")
        let _ = imageRef.putData(UIImagePNGRepresentation(photo)!, metadata: nil) { [weak self] metadata, error in
            
            guard let `self` = self else { return }
            guard let metadata = metadata else { return }
            
            let downloadURL = metadata.downloadURL()
            let batch = self.defaultStore.batch()
            let post = Post(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, photoURL: (downloadURL?.absoluteString)!, message: message, userId: user.uid, date: Date())
            let userRef = self.defaultStore.collection("users").document(user.uid).collection("posts").document()
            let ref = self.defaultStore.collection("posts").document()
            batch.setData(post.dictionary, forDocument: userRef)
            batch.setData(post.dictionary, forDocument: ref)
            
            batch.commit { error in
                
                guard let error = error else {
                    
                    completion()
                    return
                }
                print("commit error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Sort collection query by key
    internal func sortedQuery(by key: String, for collection: String) -> Query {
        
        return fetchQuery(for: collection).order(by: key)
    }
    
    /// Filter by distace [m]
    internal func filterDistance(by dist: Double, for collection: String) -> Query {
        
        // TODO: LocationManagerを入れる
        // TODO: そこから0, 90, 180, 270の方位角にdist離れたところの緯度経度を算出
        // TODO: 検算が面倒なのでそこからminとmaxを使って取り出す。
        
        let currentLocation = LocationManager.shared.coordinate
        let locations = [
            VincentyHelper.shared.calcurateNextPointLocation(from: currentLocation, s: dist, a1: 0.0),
            VincentyHelper.shared.calcurateNextPointLocation(from: currentLocation, s: dist, a1: 90.0),
            VincentyHelper.shared.calcurateNextPointLocation(from: currentLocation, s: dist, a1: 180.0),
            VincentyHelper.shared.calcurateNextPointLocation(from: currentLocation, s: dist, a1: 270.0)
        ]
        
        let minLatitude = locations.reduce(1000, { currentMin, next in
            
            return min(currentMin, next.location.latitude)
        })
        let maxLatitude = locations.reduce(-1000, { currentMax, next in
            
            return max(currentMax, next.location.latitude)
        })
        let minLongitude = locations.reduce(1000, { currentMin, next in
            
            return min(currentMin, next.location.longitude)
        })
        let maxLongitude = locations.reduce(-1000, { currentMax, next in
            
            return max(currentMax, next.location.longitude)
        })
        
        return fetchQuery(for: collection)
            .whereField("longitude", isLessThan: maxLongitude)
            .whereField("longitude", isGreaterThan: minLongitude)
            .whereField("latitude", isLessThan: maxLatitude)
            .whereField("latitude", isGreaterThan: minLatitude)
    }
    
    /// Loading User Information
    internal func loadUser() {
        
        guard let user = Auth.auth().currentUser else {
            
            return
        }
        
        defaultStore.collection("users").document(user.uid).getDocument { snapshot, err in
            
            if let err = err {
                
                print("load user error: \(err.localizedDescription)")
            } else {
                
                guard let data = snapshot?.data() else {
                    
                    return
                }
                self.userInfo = UserInfo(dictionary: data)
            }
            
        }
    }
    
    /// Set User Icon
    internal func setUserIcon(_ image: UIImage) {
        
        guard let user = Auth.auth().currentUser else {
            
            return
        }
        
        let imageRef = Storage.storage().reference().child("images/\(user.uid)_icon.png")
        let _ = imageRef.putData(UIImagePNGRepresentation(image)!, metadata: nil) { [weak self] metadata, error in
            
            guard let `self` = self else { return }
            guard let metadata = metadata else { return }
            
            let downloadURL = metadata.downloadURL()
            self.userInfo?.iconURL = downloadURL?.absoluteString ?? ""
            self.defaultStore.collection("users").document(user.uid).updateData((self.userInfo?.dictionary)!)
        }
    }
}

extension AccountHelper: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        guard let user = user else {
            
            print("Auth User Not Found")
            return
        }
        
        loadUser()
        
        // 新しいユーザーの場合
        if self.userInfo == nil {
            
            self.userInfo = UserInfo(name: user.displayName ?? "MAGirl_\(user.uid)", iconURL: "")
            self.defaultStore.collection("users").document(user.uid).setData(self.userInfo?.dictionary ?? [:], completion: { err in
                
                guard let err = err else {
                    
                    self.query = self.fetchQuery(for: "posts", limit: 50)
                    return
                }
                print("Auth error: \(err.localizedDescription)")
            })
        }
    }
    
    // TODO: ブランドデザインにあわせたい
    
//    /// ログイン方法の選択？
//    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//        return ViewController()
//    }
//
//    /// メールアドレスだけで入る画面
//    func emailEntryViewController(forAuthUI authUI: FUIAuth) -> FUIEmailEntryViewController {
//        return ViewController()
//    }
//
//    /// パスワードを入れてサインインするとこ
//    func passwordSignInViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordSignInViewController {
//        return ViewController()
//    }
//
//    /// パスワードを入れてサインアップするとこ
//    func passwordSignUpViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordSignUpViewController {
//        return ViewController()
//    }
//
//    /// パスワードを忘れた時
//    func passwordRecoveryViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordRecoveryViewController {
//        return ViewController()
//    }
//
//    /// 確認
//    func passwordVerificationViewController(forAuthUI authUI: FUIAuth, email: String, newCredential: AuthCredential) -> FUIPasswordVerificationViewController {
//        return ViewController()
//    }
}

// MARK: - Location Manger

public class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    weak var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()
        
        locationManager = CLLocationManager()
        
        guard let locationManager = locationManager else {
            
            return
        }
        
        requestAuthorization(locationManager: locationManager)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        
        startUpdatingLocation(locationManager: locationManager)
        print("start location")
    }
    
    deinit {
        
        guard let locationManager = locationManager else {
            
            return
        }
        
        stopUpdatingLocation(locationManager: locationManager)
    }
    
    // MARK: - Private
    
    private var locationManager: CLLocationManager?
    private var _latitude: CLLocationDistance? = nil
    private var _longitude: CLLocationDistance? = nil
    private var _altitude: CLLocationDistance? = nil
    private var _coordinate: CLLocationCoordinate2D? = nil
    private var _location: CLLocation? = nil
    
    // MARK: - Internal
    
    /// Latitude (default is 0.0)
    var latitude: CLLocationDistance {
        
        guard let latitude = self._latitude else {
            
            return 0.0
        }
        
        return latitude
    }
    /// Longitude (default is 0.0)
    var longitude: CLLocationDistance {
        
        guard let longitude = self._longitude else {
            
            return 0.0
        }
        
        return longitude
    }
    /// Coordinate2D
    var coordinate: CLLocationCoordinate2D {
        
        guard let coordinate = self._coordinate else {
            
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
        
        return coordinate
    }
    /// Altitude (default is 0.0)
    var altitude: CLLocationDistance {
        
        guard let altitude = self._altitude else {
            
            return 0.0
        }
        
        return altitude
    }
    var location: CLLocation {
        
        guard let location = self._location else {
            
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
        
        return location
    }
    var userHeading: CLLocationDirection!
    
    /// request authorize corelocation
    func requestAuthorization(locationManager: CLLocationManager) {
        
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .notDetermined, .restricted, .denied:
            stopUpdatingLocation(locationManager: locationManager)
        }
    }
    
    /// start up location manager
    func startUpdatingLocation(locationManager: CLLocationManager) {
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    /// end location manager
    func stopUpdatingLocation(locationManager: CLLocationManager) {
        
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    /// for init shared instance
    func run() {}
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManager delegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            self.delegate?.trackingLocation(for: location)
        }
        
        let newLocation = manager.location
        _altitude = newLocation?.altitude
        _coordinate = newLocation?.coordinate
        _longitude = newLocation?.coordinate.longitude
        _latitude = newLocation?.coordinate.latitude
        _location = newLocation
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if newHeading.headingAccuracy < 0 {
            
            return
        }
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.delegate?.trackingLocationDidFail(with: error)
    }
}

/// Location Service Delegate
protocol LocationServiceDelegate: class {
    
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}
