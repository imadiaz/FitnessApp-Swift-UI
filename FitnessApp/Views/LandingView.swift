//
//  ContentView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 27/10/20.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var viewModel = LandingViewModel()
    
    
    var title: some View {
        Text(viewModel.title)
            .font(.system(size:64,
                          weight: .medium))
            .foregroundColor(.white)
    }
    var createButton: some View {
        Button(action:{
            viewModel.createPushed = true
        }){
            HStack(spacing:15) {
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.system(size: 24,weight:.semibold))
                    .foregroundColor(.white)
                Text("Create a challengue")
                    .font(.system(size: 24,weight:.semibold))
                    .foregroundColor(.white)
                Spacer()
            }
        }.padding(15)
        .buttonStyle(PrimaryButtonStyle())
    }
    
    var createAccount:some View {
        Button("I already have an account"){
            viewModel.loginSignUpPushed = true
        }.foregroundColor(.white)
    }
    
    var backgroundImage: some View{
        Image("pullups")
            .resizable()
            .aspectRatio(
                contentMode: .fill
            ).overlay(Color.black.opacity(0.4))
           
    }
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                VStack {
                    Spacer().frame(height:proxy.size.height * 0.08)
                    title
                    Spacer()
                    NavigationLink(destination:CreateView(),isActive:$viewModel.createPushed){
                   createButton
                    }
                    NavigationLink(
                        destination:LoginSignupView(viewModel: .init(mode: .login,isPushed: $viewModel.loginSignUpPushed))
                        ,isActive:$viewModel.loginSignUpPushed){
                       createAccount
                    }
                }.padding(.bottom,15)
                .frame(maxWidth: .infinity,
                        maxHeight: .infinity)
                .background(
                    backgroundImage.frame(width:proxy.size.width)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }.accentColor(.primary)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

