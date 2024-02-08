//
//  WaveMap.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import SwiftUI
import MapKit

struct WaveMap: View {
    
   @State private var locations = [LocationModel]()
    
   @State private var selectedLocation: LocationModel?
    
  let dummyURL = URL(string: "https://example.com/video.mp4")!

    let position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2DMake(51.507222, -0.1275), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    )
    
    var body: some View {
        
      
        
        MapReader { proxy in
            Map(initialPosition: position,interactionModes: [.all]) {
                
                
            
                ForEach(locations.suffix(1)) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(.appIcon)
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture {
                                selectedLocation = location
                            }
                    }
                   
                }
            }
                .mapStyle(.hybrid(elevation: .realistic))
                .onTapGesture(perform: {
                    tappedPosition in
                    
                    if let coordinate = proxy.convert(tappedPosition, from: .local) {
                        
                        let newLocation = LocationModel(id: UUID(), name: "surf point", latitude: coordinate.latitude, longitude: coordinate.longitude, description: "", video: dummyURL)
                        
                        locations.append(newLocation)
                        print("\(coordinate)")
                    }
                })
                .sheet(item: $selectedLocation) { location in
                    EditView(locaion: location) { newLocation in
                        if let index = locations.firstIndex(of: location) {
                            locations[index] = newLocation
                        }
                    }
                }
        }
    }
}

#Preview {
    WaveMap()
}
