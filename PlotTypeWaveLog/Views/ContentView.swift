//
//  ContentView.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import SwiftUI
import MapKit



struct ContentView: View {
    
    @State private var launchAnimation = true
    
    @State private var selectedTab : Int = 0
   
    @Binding var selection: AppScreen?
    
    @State private var buttonPressed = false
    
    var body: some View {

            
        NavigationStack{
            
            ZStack {
                if launchAnimation {
                    SplashScreenVew()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 3.0), value: launchAnimation)
                } else {
                    
                    //   AppTabView(selection: $selection)
                    
                    ZStack {
                        TabView(selection: $selectedTab,
                                content:  {
                            
                            SurfDestinationMap()
                                .tabItem {Image(systemName: "figure.surfing")
                                    Text("Surf spots")}.tag(0)
                            
                            WaveMap()
                                .tabItem {
                                    Image(systemName: "")
                                        .frame(width: 100, height: 100)
                                    
                                }
                            
                                .tag(1)
                            
                            
                            
                            
                            WaveList().tabItem { Image(systemName: "bookmark")
                                Text("Wave list")}.tag(2)
                        })
                    }
                    
                    VStack {
                        Spacer()
                        NavigationLink(destination: WaveMap()) {
                            Image(.appIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(.circle)
                        }
                    }
                }
                
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        launchAnimation = false
                    }
                }
            }
            
            
        }
    }
    }


#Preview {
    ContentView(selection: .constant(.destinations))
}
