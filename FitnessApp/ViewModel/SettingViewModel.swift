//
//  SettingViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 31/10/20.
//

import Combine
import SwiftUI
final class SettingViewModel:ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModel:[SettingItemViewModel] = []
    @Published var loginSignupPushed = false
    private var cancellables:[AnyCancellable] = []
    let title="Settings"
    
    private let userService:UserServiceProtocol
    
    init(userService:UserServiceProtocol = UserService()) {
        self.userService = userService
        buildItems()
    }
    
    func tappedItem(with item:SettingItemViewModel){
        switch item.type {
        case .account:
            guard userService.currentUser?.email == nil else { return }
            loginSignupPushed = true
        case .mode:
            isDarkMode = !isDarkMode
            buildItems()
        case .logout :
            userService.logout().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case  .finished:
                    break
                }
            } receiveValue: { _ in}
            .store(in: &cancellables)
        default:
            break
        }
    }
    
    private func buildItems(){
        itemViewModel = [
            .init(title: userService.currentUser?.email ?? "Create account", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Ligth":"Dark") mode", iconName: "lightblulb", type: .mode),
            .init(title: "Privacy policy", iconName: "shield", type: .privacy)
        ]
        if userService.currentUser?.email != nil {
            itemViewModel += [.init(title: "Logout", iconName: "arrowshape.turn.up.left", type: .logout)]
        }
    }
    
    
}
