//
//  LocationModel.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import Foundation
import MapKit

struct LocationModel :Codable, Identifiable, Equatable {
    
    var id: UUID
    
    var name: String
    var latitude: Double
    var longitude: Double
    var description: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example = LocationModel(id: UUID(), name: "Buckingham Palace", latitude: 51.501, longitude: -0.141, description: "It is palace.")
    #endif
    
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        lhs.id == rhs.id
    }
}
