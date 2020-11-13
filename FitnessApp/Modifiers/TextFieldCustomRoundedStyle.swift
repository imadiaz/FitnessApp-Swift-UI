//
//  TextFieldCustomRoundedStyle.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 02/11/20.
//

import SwiftUI
struct TextFieldCustomRoundedStyle:ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 16,weight: .medium))
            .foregroundColor(.primary)
            .padding()
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary))
            .padding(.horizontal,15)
    }
}
