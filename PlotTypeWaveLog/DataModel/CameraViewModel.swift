//
//  CameraDataModel.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/24.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate  {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) async {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        //Created successfully
        print(outputFileURL)
        self.recordedURLs.append(outputFileURL)
        if self.recordedURLs.count == 1 {
            self.previewURL = outputFileURL
            return
        }
        
        
        //Converting URLs to Assets
        let assets = recordedURLs.compactMap {url -> AVURLAsset in
            
            return AVURLAsset(url: url)
        }
        self.previewURL = nil
        
        
        //Merging videos
        
        await mergevideos(assets: assets) { exporter in
            exporter.exportAsynchronously {
                if exporter.status == .failed {
                    print(exporter.error!)
                }
                else {
                    if let finalURL = exporter.outputURL{
                        print(finalURL)
                        DispatchQueue.main.async {
                            self.previewURL = finalURL
                        }
                    }
                }
            }
        }
    }
    
    
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureMovieFileOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    //MARK: - Video Recoder Properties
    @Published var isRecording : Bool = false
    @Published var recordedURLs : [URL] = []
    @Published var previewURL : URL?
    @Published var showPreview : Bool = false
    
    @Published var recordedDuration : CGFloat = 0
    @Published var maxDuration : CGFloat = 20
    
    func checkPermission(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status {
                    self.setUp()
                }
                
            }
            
        case .denied:
            self.alert.toggle()
            return
            
        case .authorized:
            setUp()
            return
            
        case .restricted:
            return
            
        @unknown default:
            return
        }
    }
    
    func setUp() {
        
        do {
            self.session.beginConfiguration()
            
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let audioDevice =
            AVCaptureDevice.default(for: .audio)
            
            let videoInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if self.session.canAddInput(videoInput) && self.session.canAddInput(audioInput) {
                
                self.session.addInput(videoInput)
                self.session.canAddInput(audioInput)
                
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
                
            }
            
            self.session.commitConfiguration()
        
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func startRecording() async{
    //MARK: - temporary URL for recording Video
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov"
        output.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording(){
        output.stopRecording()
        isRecording = false
    }
    

    
    func mergevideos(assets: [AVURLAsset], completion: @escaping( _ exporter: AVAssetExportSession)->()) async {
    
        let compostion = AVMutableComposition()
        var lastTime: CMTime = .zero
        
        guard let videoTrack = compostion.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else{return}
        guard let audioTrack = compostion.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else{return}
        
        for asset in assets {
            // Linking Audio and Video
            do{
                try await videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.load(.duration)), of: asset.loadTracks(withMediaType: .video)[0], at: lastTime)
                // Safe Check if Video has Audio
                if try await !asset.loadTracks(withMediaType: .audio).isEmpty{
                    try await audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.load(.duration)), of: asset.loadTracks(withMediaType: .audio)[0], at: lastTime)
                }
            }
            catch{
                // HANDLE ERROR
                print(error.localizedDescription)
            }
            
            // Updating Last Time
            do {
                try await
                lastTime = CMTimeAdd(lastTime, asset.load(.duration))
            } catch{
                print(error.localizedDescription)
            }
        
        }
        
        // MARK: Temp Output URL
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + "Reel-\(Date()).mp4")
        
        // VIDEO IS ROTATED
        // BRINGING BACK TO ORIGNINAL TRANSFORM
        
        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        
        // MARK: Transform
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: 90 * (.pi / 180))
        transform = transform.translatedBy(x: 0, y: -videoTrack.naturalSize.height)
        layerInstructions.setTransform(transform, at: .zero)
        
        let instructions = AVMutableVideoCompositionInstruction()
        instructions.timeRange = CMTimeRange(start: .zero, duration: lastTime)
        instructions.layerInstructions = [layerInstructions]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
        videoComposition.instructions = [instructions]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        guard let exporter = AVAssetExportSession(asset: compostion, presetName: AVAssetExportPresetHighestQuality) else{return}
        exporter.outputFileType = .mp4
        exporter.outputURL = tempURL
        exporter.videoComposition = videoComposition
        completion(exporter)
    }
    
    
    
}
