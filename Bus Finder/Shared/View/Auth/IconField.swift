//
//  IconField.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/06/06.
//

import SwiftUI


// MARK: EmailField
struct EmailField: View {
    
//  MARK: Variables
    var icon: Image
    var title: String
    @Binding var text:String
    @Binding var isEmailValid: Bool
    
    var body: some View {
        HStack {
            icon.font(.system(size: 20)).foregroundColor(!isEmailValid && text != "" ? .red : .gray).padding([.leading, .vertical])
            TextField(title ,text: $text, onCommit: {
                self.isEmailValid = self.text.isValidEmail()
            })
                .padding([.vertical, .trailing])
                .padding(.leading, 5)
                .font(Font.body.bold())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
        }.background(Color.gray.opacity(0.2)).font(Font.body.bold()).cornerRadius(16).keyboardType(.emailAddress)
        .if(!isEmailValid && text != "") { $0.overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.red, lineWidth: 2)) }
    }
}


// MARK: - PasswordField
struct PasswordField: View {
    
//  MARK: Variables
    var icon: Image
    var title: String
    @Binding var text:String
    
    var body: some View {
        HStack {
            icon.font(.system(size: 20)).foregroundColor(.gray).padding([.leading, .vertical])
            SecureField(title, text: $text).padding([.vertical, .trailing]).padding(.leading, 5).font(Font.body.bold())
            
        }.background(Color.gray.opacity(0.2)).cornerRadius(16)
        //                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.black, lineWidth: 2))
    }
}
