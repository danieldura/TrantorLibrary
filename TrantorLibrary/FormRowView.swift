//
//  FormRowView.swift
//  TrantorLibrary
//
//  Created by Angel Fernandez Barrios on 15/2/23.
//

import SwiftUI

struct FormRowView: View {
    @Binding var error:Bool
    let label: String
    let placeholder: String
    @Binding var text: String
    var validation:((String) -> String?)?
    
    @State var message = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .bold()
            
            HStack {
                TextField(placeholder, text: $text)
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark")
                            .symbolVariant(.circle)
                            .symbolVariant(.fill)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .opacity(0.5)
                }
            }
            .background {
                Rectangle()
                    .stroke(lineWidth: 2)
                    .fill(.red)
                    .opacity(error ? 1.0 : 0.0)
            }
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            
            if error {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: text) { newValue in
            if let validation, let message = validation(newValue) {
                self.message = message
                self.error = true
            } else {
                self.error = false
            }
        }
    }
}

struct FormRowView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowView(error: .constant(false), label: "Field", placeholder: "Enter data", text: .constant(""))
    }
}
