////
////  ContentView.swift
////  HelloSunset
////
////  Created by JarvanSun on 2022/5/25.
////
//
//import SwiftUI
//import Solar
//
//struct ContentView: View {
//    @StateObject var locationManager = LocationManager()
//    
//    var userLatitude: String {
//        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
//    }
//    
//    var userLongitude: String {
//        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
//    }
//    
//    var body: some View {
//        VStack {
//            Text("location status: \(locationManager.statusString)")
//            HStack {
//                Text("latitude: \(userLatitude)")
//                Text("longitude: \(userLongitude)")
//            }
//            
//            Spacer()
//            
//            if userLatitude != "0" && userLongitude != "0" {
//                Text(
//                    sunrise(), style: .time
//                )
//            }
//            
//            if userLatitude != "0" && userLongitude != "0" {
//                Text(
//                    sunset(), style: .time
//                )
//            }
//        }
//    }
//    
//    private func sunset() -> Date {
//        guard let coordinate = locationManager.lastLocation?.coordinate,
//              let sunset = Solar(for: Date(), coordinate: coordinate)?.sunset else {
//            return Date(timeIntervalSince1970: 0)
//        }
//        return sunset
//    }
//    
//    private func sunrise() -> Date {
//        guard let coordinate = locationManager.lastLocation?.coordinate,
//              let sunset = Solar(for: Date(), coordinate: coordinate)?.sunrise else {
//            return Date(timeIntervalSince1970: 0)
//        }
//        return sunset
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.locale, Locale(identifier: "fr"))
//    }
//}
