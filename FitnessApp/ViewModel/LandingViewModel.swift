//
//  LandingViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 02/11/20.
//

import Foundation
final class LandingViewModel:ObservableObject {
    @Published var loginSignUpPushed = false
    @Published var createPushed = false
    
    let title = "Increment"
}
