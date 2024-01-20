//
//  AppScreen.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import Foundation
import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case destinations
    case map
    case list
    
    
    var id: AppScreen {
        self
    }
}

extension AppScreen {

  
    @ViewBuilder
    var label: some View {
        
        
        VStack {
            switch self {
            case .destinations:
                Label("Surf spots", systemImage: "figure.surfing")
            case .map:
                Image(systemName: "plus.viewfinder")
                
            case .list:
                Label("Wave log", systemImage: "bookmark")
            }
            
      
        }
    }
    
    @ViewBuilder
   var destination: some View {
       switch self {
       case .list:
           WaveList()
       case .destinations:
           SurfDestinationMap()
       case .map:
           WaveMap()
       
      
       }
   }
  
}

struct AppTabView: View {
    
    @Binding var selection: AppScreen?
    
    var body: some View {
        
        TabView(selection: $selection,
                content:  {
            ForEach(AppScreen.allCases) {
                screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem {screen.label}
            }
            
        })
    }
}


