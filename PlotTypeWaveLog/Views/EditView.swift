//
//  EditView.swift
//  PlotTypeWaveLog
//
//  Created by Ryuutarou Nakajima on 2024/01/10.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    var location: LocationModel
    let tint : Color = .black
    @State private var name: String
    @State private var description: String
    
    
    var onSave: (LocationModel) -> Void
    
    init(locaion: LocationModel, onSave: @escaping (LocationModel) -> Void) {
        
        self.location = locaion
        self.onSave = onSave
        
        _name = State(initialValue: locaion.name)
        _description = State(initialValue: locaion.description)
    }
    
    var body: some View {
        NavigationStack {
       
            
     
           
            ScrollView(.horizontal) {
                
                HStack {
                    Spacer(minLength: 100)
                    NavigationLink(destination: ReelView()) {
                        
                        
                        
                        VStack {
                            Image(systemName: "film")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                                .padding(.top, 30)
                                .padding([.trailing, .leading], 50)
                            
                            Text("Film")
                                .padding(.bottom, 20)
                        }
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(tint.opacity(0.07).gradient)
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                                    .padding(1)
                            }
                        }
                        
                        
                        
                        
                    }
                    Spacer(minLength: 80)
                    NavigationLink(destination: ReelView()) {
                        
                        
                        
                        VStack {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                                .padding(.top, 30)
                                .padding([.trailing, .leading], 50)
                            
                            Text("Photo")
                                .padding(.bottom, 20)
                        }
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(tint.opacity(0.07).gradient)
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                                    .padding(1)
                            }
                        }
                        
                        
                        
                        
                    }
                }
                
            }
   
            Form {
           
              
                Section("surfPonit") {
                   
                        TextField("Place name", text: $name)
                    
                        TextField("Description", text: $description)
                }
                
                Section("Condition") {
                    TextField("Where that wind came from", text: $name)
                    TextField("Size of waves", text:  $name)
                    TextField("Face", text: $name)
                }
                
              
            }
            .navigationTitle("Wave details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
               
            }
        }
    }
}

#Preview {
    EditView(locaion: .example) { _ in}
}
