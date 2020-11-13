//
//  ChallengueListView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 30/10/20.
//

import SwiftUI

struct ChallengueListView:View {
    
    @StateObject private var viewModel = ChallengueListViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }else if let error = viewModel.error {
                VStack{
                    Text(error.localizedDescription)
                    Button("Retry"){
                        viewModel.send(action: .retry)
                    }
                    .padding(10)
                    .background(Rectangle().fill(Color.red).cornerRadius(5))
                }
            }else{
                mainContentView.onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)){ _ in
                    viewModel.send(action: .timeChange)
                }
            }
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack{
                LazyVGrid(columns: [.init(.flexible(),spacing:20),.init(.flexible())],spacing:20){
                    ForEach(viewModel.itemViewModels,id: \.id){ viewModel in
                        ChallengueItemView(viewModel: viewModel)
                    }
                }
                Spacer()
            }.padding(10)
        }
        .sheet(isPresented: $viewModel.showingCreateModal) {
            NavigationView {
                CreateView()
            }.preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .navigationBarItems(trailing: Button {
            viewModel.send(action: .create)
        } label:{
            Image(systemName: "plus.circle").imageScale(.large)
        })
        .navigationTitle(viewModel.title)
    }
    
}






