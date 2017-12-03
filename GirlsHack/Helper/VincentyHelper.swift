//
//  VincentryHelper.swift
//  XmasPresentGo
//
//  Created by 藤井陽介 on 2017/11/23.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import CoreLocation

class VincentyHelper: NSObject {
    
    static let shared = VincentyHelper()
    
    // MARK: - Private
    
    private override init() {}
    
    /// Radius at equator [m]
    private let a: Double = 6378137.0
    /// Flattening of the ellipsoid
    private let f: Double = 1 / 298.257222101
    /// Radius at the poles [m]
    private let b: Double = 6356752.314245
    /// Reduced latitude
    private func u(of latitude: Double) -> Double {
        
        return atan((1 - f) * tan(latitude))
    }

    // MARK: - Internal

    func calcurateDistanceAndAzimuths(at location1: CLLocationCoordinate2D, and location2: CLLocationCoordinate2D) -> (s: Double, a1: Double, a2: Double) {
        
        let lat1 = location1.latitude.radian
        let lat2 = location2.latitude.radian
        let lon1 = location1.longitude.radian
        let lon2 = location2.longitude.radian
        
        let omega = lon2 - lon1
        let tanU1 = (1 - f) * tan(lat1)
        let cosU1 = 1 / sqrt(1 + pow(tanU1, 2.0))
        let sinU1 = tanU1 * cosU1
        let tanU2 = (1 - f) * tan(lat2)
        let cosU2 = 1 / sqrt(1 + pow(tanU2, 2.0))
        let sinU2 = tanU2 * cosU2
        
        var lambda = omega
        var lastLambda = omega - 100
        
        var cos2alpha: Double = 0.0
        var sinSigma: Double = 0.0
        var cosSigma: Double = 0.0
        var cos2sm: Double = 0.0
        var sigma: Double = 0.0
        var sinLambda: Double = 0.0
        var cosLambda: Double = 0.0
        
        while abs(lastLambda - lambda) > pow(10, -12.0) {
            
            sinLambda = sin(lambda)
            cosLambda = cos(lambda)
            let sin2sigma = pow(cosU2 * sinLambda, 2.0) + pow(cosU1 * sinU2 - sinU1 * cosU2 * cosLambda, 2.0)
            sinSigma = sqrt(sin2sigma)
            cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda
            sigma = atan2(sinSigma, cosSigma)
            let sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma
            cos2alpha = 1 - pow(sinAlpha, 2.0)
            if cos2alpha == 0 {
                
                cos2sm = 0
            } else {
                
                cos2sm = cosSigma - 2 * sinU1 * sinU2 / cos2alpha
            }
            let C = f / 16.0 * cos2alpha * (4 + f * (4 - 3 * cos2alpha))
            lastLambda = lambda
            lambda = omega + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2sm + C * cosSigma * (2 * pow(cos2sm, 2.0) - 1)))
        }

        let u2 = cos2alpha * (pow(a, 2.0) - pow(b, 2.0)) / pow(b, 2.0)
        let A = 1 + u2 / 16384 * (4096 + u2 * (-768 + u2 * (320 - 175 * u2)))
        let B = u2 / 1024 * (256 + u2 * (-128 + u2 * (74 - 47 * u2)))
        let dSigma = B * sinSigma * (cos2sm + B / 4 * (cosSigma * (2 * pow(cos2sm, 2.0) - 1) - B / 6 * cos2sm * (4 * pow(sinSigma, 2.0) - 3) * (4 * pow(cos2sm, 2.0) - 3)))
        
        // Result
        let s = b * A * (sigma - dSigma)
        let a1 = atan2(cosU2 * sinLambda, cosU1 * sinU2 - sinU1 * cosU2 * cosLambda)
        let a2 = atan2(cosU1 * sinLambda, cosU1 * sinU2 * cosLambda - sinU1 * cosU2)
        return (s: s, a1: a1.degree, a2: a2.degree)
    }

    func calcurateNextPointLocation(from location: CLLocationCoordinate2D, s: Double, a1: Double) -> (location: CLLocationCoordinate2D, a2: Double) {

        let latRad = location.latitude.radian
        let lonRad = location.longitude.radian
        let a1Rad = a1.radian
        
        let u1 = u(of: latRad)
        let sigma1 = atan2(tan(u1), cos(a1Rad))
        let sinalp = cos(u1) * sin(a1Rad)
        let cos2alp = 1 - pow(sinalp, 2.0)
        let u22 = cos2alp * (pow(a, 2.0) - pow(b, 2.0)) / pow(b, 2.0)
        let A = 1 + u22 / 16384 * (4096 + u22 * (u22 * (320 - 175 * u22) - 768))
        let B = u22 / 1024 * (256 + u22 * (u22 * (74 - 47 * u22) - 128))

        var sigma = s / b / A
        var lastSigma = sigma - 100
        
        var dm2: Double = 0.0
        
        while abs(lastSigma - sigma) > pow(10, -9.0) {
            
            lastSigma = sigma
            dm2 = 2 * sigma1 + sigma
            let x = cos(sigma) * (2 * pow(cos(dm2), 2.0) - 1) - B / 6 * cos(dm2) * (4 * pow(sin(dm2), 2.0) - 3) * (4 * pow(cos(dm2), 2.0) - 3)
            let dsigma = B * sin(sigma) * (cos(dm2) + B / 4 * x)
            sigma = s / b / A + dsigma
        }
        
        let x = sin(u1) * cos(sigma) + cos(u1) * sin(sigma) * cos(a1Rad)
        let y = (1 - f) * sqrt(pow(sinalp, 2.0) + pow(sin(u1) * sin(sigma) - cos(u1) * cos(sigma) * cos(a1Rad), 2.0))
        let lambda = atan2(sin(sigma) * sin(a1Rad), cos(u1) * cos(sigma) - cos(u1) * sin(sigma) * cos(a1Rad))
        let C = f / 16 * cos2alp * (4 + f * (4 - 3 * cos2alp))
        let z = cos(dm2) + C * cos(sigma) * (2 * pow(cos(dm2), 2.0) - 1)
        let dL = lambda - (1 - C) * f * sinalp * (sigma + C * sin(sigma) * z)
        
        // Result
        let latitude = atan2(x, y)
        let longitude = lonRad + dL
        let a2 = atan2(sinalp, cos(u1) * cos(sigma) * cos(a1) - sin(u1) * sin(sigma))
        return (location: CLLocationCoordinate2D(latitude: latitude.degree, longitude: longitude.degree), a2: a2.degree)
    }
}
