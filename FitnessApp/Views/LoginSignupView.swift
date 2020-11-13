//
//  LoginSignupView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 02/11/20.
//

import SwiftUI

struct LoginSignupView:View {
    @ObservedObject var viewModel: LoginSignupViewModel
    var emailTextField: some View {
        TextField("Email",text:$viewModel.emailText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)
    }
    
    var passwordTextField: some View{
        SecureField("Password",text:$viewModel.passwordText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)

    }
    var actionButton: some View {
        Button(viewModel.buttonTitle){
            viewModel.tappedActionButton()
        }.padding()
        .frame(maxWidth:.infinity)
        .foregroundColor(.white)
        .background(Color(.systemPink))
        .cornerRadius(16)
        .padding()
        .disabled(!viewModel.isValid)
        .opacity(viewModel.isValid ? 1 : 0.4)
    }
    
    var body: some View {
        VStack{
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.subtitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
            Spacer().frame(height:50)
            emailTextField
            passwordTextField
            actionButton
            Spacer()
            
        }.padding()
    }
}


