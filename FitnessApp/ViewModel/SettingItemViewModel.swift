//
//  SettingItemViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 31/10/20.
//

import Foundation
extension SettingViewModel{
    struct SettingItemViewModel:Hashable{
        let title:String
        let iconName:String
        let type:SettingItemType
    }
    enum SettingItemType {
        case account
        case mode
        case privacy
        case logout
    }
}
