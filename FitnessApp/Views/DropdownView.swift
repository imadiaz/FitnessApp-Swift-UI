//
//  DropdownView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 29/10/20.
//

import SwiftUI
struct DropdownView<T:DropdownItemProtocol>:View {
    @Binding var viewModel: T
    
    var actionSheet : ActionSheet {
        ActionSheet(
            title: Text("Select"),
            buttons: viewModel.options.map {option in
                return .default(
                    Text(option.formatted)){
                        viewModel.selectedOption = option
                    }
            })
    }
    var body: some View{
        VStack{
            HStack{
                Text(viewModel.headerTitle)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }.padding(.vertical,10)
            Button(action:{
                viewModel.isSelected = true
            }){
                HStack{
                    Text(viewModel.dropdownTitle)
                        .font(.system(size: 28, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: 24, weight: .medium))
                }
            }.buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
        }.actionSheet(isPresented:$viewModel.isSelected) {
            actionSheet
        }.padding(15)
    }
}


