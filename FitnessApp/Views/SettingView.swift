//
//  SettingView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 31/10/20.
//

import SwiftUI

struct SettingView:View {
    @StateObject private var viewModel = SettingViewModel()
    var body: some View {
        List(viewModel.itemViewModel,id:\.self){ item in
            Button {
                viewModel.tappedItem(with: item)
            } label: {
                HStack{
                    Image(systemName: item.iconName)
                    Text(item.title)
                }
            }
        }.background(
        NavigationLink(
            destination: LoginSignupView(viewModel: .init(mode: .signup,isPushed: $viewModel.loginSignupPushed)),
            isActive: $viewModel.loginSignupPushed
        ){
            
        }
        )
        .navigationTitle(viewModel.title)
    }
}
