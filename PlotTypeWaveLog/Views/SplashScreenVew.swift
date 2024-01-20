//
//  SplashScreenVew.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import SwiftUI

struct SplashScreenVew: View {
    var body: some View {
        ZStack{
              LinearGradient(colors: [Color.blue, Color.cyan,  Color.white], startPoint: .bottomLeading, endPoint: .trailing)
                  .ignoresSafeArea()
              
            
              Image(.appIcon)
                  .font(.largeTitle)
                  .bold()
                  .phaseAnimator([1,4]) {
                      content, phase in
                      content
                          .scaleEffect(phase == 1 ? 2 : 6)
                      
                          .opacity(phase == 4 ? 0 : 1)
                  } animation: {
                      phase in
                          .easeOut(duration: 2)
                          .repeatForever(autoreverses: false)
                          
                  }
                    
              
           
              
                  
                  
       
                  
          }
    }
}

#Preview {
    SplashScreenVew()
}
