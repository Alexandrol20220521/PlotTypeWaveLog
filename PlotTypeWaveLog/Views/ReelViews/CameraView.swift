//
//  CameraView.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/02/06.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @EnvironmentObject var cameraModel : CameraViewModel
    var size: CGSize
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView()
        
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.preview.frame.size = size
        
        cameraModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.preview)
        
        cameraModel.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}


struct CameraView: View {
    
    @EnvironmentObject var cameraModel: CameraViewModel
    
    var body: some View {
        
        GeometryReader { proxy in
        
            let size = proxy.size
            
            CameraPreview(size: size)
                .environmentObject(cameraModel)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.25))
                
                Rectangle()
                    .fill(Color(.lightGray))
                    .frame(width: size.width * (cameraModel.recordedDuration / cameraModel.maxDuration))
            }
            .frame(height: 8)
            .frame(maxHeight: .infinity, alignment:  .top)
        }
        .onAppear(perform: {
            cameraModel.checkPermission()
        })
        .alert(isPresented: $cameraModel.alert) {
            Alert(title: Text("Access to camera"))
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            
            if cameraModel.recordedDuration <= cameraModel.maxDuration && cameraModel.isRecording {
                
                cameraModel.recordedDuration += 0.01
            }
            if cameraModel.recordedDuration >= cameraModel.maxDuration && cameraModel.isRecording {
                
                cameraModel.stopRecording()
                cameraModel.isRecording  = false
            }
        }
    }
}

#Preview {
 CameraView()
        .environmentObject(CameraViewModel())
       
}

