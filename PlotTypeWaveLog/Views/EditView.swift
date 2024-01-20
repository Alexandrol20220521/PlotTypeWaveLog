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
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
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
