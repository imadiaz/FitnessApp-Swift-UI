//
//  TabContainerView.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 30/10/20.
//

import SwiftUI

struct TabContainerView:View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    var body: some View{
        TabView(selection:$tabContainerViewModel.selectedTab){
            ForEach(tabContainerViewModel.tabItemViewModels,id: \.self){ viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        Text(viewModel.title)
                    }.tag(viewModel.type)
            }
        }.accentColor(.primary)
    }
    @ViewBuilder
    func tabView(for tabItemtype:TabItemViewModel.TabItemType) -> some View{
        switch tabItemtype {
        case .log:
            Text("Log")
        case .challengueList:
            NavigationView {
                ChallengueListView()
            }
        case .settings:
            NavigationView{
                SettingView()
            }
    }
}
    
}

final class TabContainerViewModel: ObservableObject {
    @Published var selectedTab: TabItemViewModel.TabItemType = .challengueList
    let tabItemViewModels = [
        TabItemViewModel(imageName: "list.bullet", title: "Challengues", type: .challengueList),
        TabItemViewModel(imageName: "gear", title: "Settings", type: .settings),
    ]
}

struct TabItemViewModel:Hashable {
    let imageName:String
    let title:String
    let type:TabItemType
    
    enum TabItemType {
        case log
        case challengueList
        case settings
        
    }
}
