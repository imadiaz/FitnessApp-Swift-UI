//
//  CreateView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 29/10/20.
//

import SwiftUI
struct CreateView:View {
    @StateObject var viewModel = CreateChallengueViewModel()
    
    var dropdownList: some View {
        
        Group{
            DropdownView(viewModel: $viewModel.excerciseDropDown)
            DropdownView(viewModel: $viewModel.startAmountDropDown)
            DropdownView(viewModel: $viewModel.increseDropDown)
            DropdownView(viewModel: $viewModel.lengthDropDown)
        }
    }
  
    var mainContentView: some View {
        ScrollView{
            VStack{
                dropdownList
                Spacer()
                Button(action:{
                    viewModel.send(action: .createChallengue)
                }){
                    Text("Create").font(.system(size: 22, weight: .medium))
                        .foregroundColor(.primary)
                }
                
            }
        }
    }
    
    var body : some View {
        ZStack{
            if viewModel.isLoading {
                ProgressView()
            }else{
                mainContentView
            }
        }.alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)) {
            Alert(
                title: Text("Error!"),
                message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""),
                dismissButton: .default(Text("Ok"),action: {
                    viewModel.error = nil
                })
            )
        }
        .navigationBarTitle("Create")
        .navigationBarBackButtonHidden(true)
        .padding(.bottom,15)
    }
}



struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
