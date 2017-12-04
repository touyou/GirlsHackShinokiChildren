//
//  CLLocationCoordinate2D+Extensions.swift
//  XmasPresentGo
//
//  Created by 藤井陽介 on 2017/11/18.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import CoreLocation

let metersPerRadianLat: Double = 6373000.0
let metersPerRadianLon: Double = 5602900.0

extension CLLocationCoordinate2D {
    
    /// Calcurate bearing toward other coordinate
    func bearing(to coordinate: CLLocationCoordinate2D) -> Double {
        
        let a = sin(coordinate.longitude.radian - longitude.radian) * cos(coordinate.latitude.radian)
        let b = cos(latitude.radian) * sin(coordinate.latitude.radian) - sin(latitude.radian) * cos(coordinate.latitude.radian) * cos(coordinate.longitude.radian - longitude.radian)
        return atan2(a, b)
    }
    
    /// Calcurate direction toward other coordinate
    func direction(to coordinate: CLLocationCoordinate2D) -> CLLocationDirection {
        
        return self.bearing(to: coordinate).degree
    }
    
    /// Calcurate coordinate with bearing and distance
    func coordinate(with bearing: Double, and distance: Double) -> CLLocationCoordinate2D {
        
        let distRadiansLat = distance / metersPerRadianLat
        let distRadiansLon = distance / metersPerRadianLon
        
        let lat1 = self.latitude.radian
        let lon1 = self.longitude.radian
        
        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadiansLon) * cos(lat1), cos(distRadiansLon) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2.degree, longitude: lon2.degree)
    }
}

extension Double {
    
    /// Convert degree value to radian value
    var radian: Double {
        
        return self * .pi / 180.0
    }
    
    /// Convert radian value to degree value
    var degree: Double {
        
        return self * 180.0 / .pi
    }
}
