//
//  ReelView.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/21.
//

import SwiftUI

struct ReelView: View {
    @StateObject var cameraModel = CameraViewModel()
    var body: some View {
        ZStack(alignment: .bottom){
            
            //MARK: - Camera View
            CameraView()
                .environmentObject(cameraModel)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                .padding(.top, 10)
                .padding(.bottom, 30)
            
            ZStack{
                
                Button {
                    
                } label: {
                    Image(systemName: "video")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.black)
                        .padding(4)
                        .frame(width: 50, height: 50)
                        .padding(6)
                        .background{
                            Circle()
                                .stroke(lineWidth: 4)
                                .foregroundStyle(.black)
                        }
                        .padding(10)
                        .background{
                            Circle()
                            .foregroundStyle(.white)                        }
                    
                    
                    
                }
                
                Button {
                    
                } label: {
                    Label {
                        Image(systemName: "chevron.right")
                            .font(.callout)
                    } icon: {
                        Text("Preview")
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background{
                        Capsule()
                            .stroke(lineWidth: 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            //.padding(.bottom, 10)
            .padding(.bottom, 40)
           
            
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        
    }
        
}

#Preview {
    ReelView()
        .environmentObject(CameraViewModel())
}
