//
//  ProgressCircleViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 02/11/20.
//

import Foundation
struct ProgressCircleViewModel {
    let title:String
    let message:String
    let percentageComplete:Double
    var shouldShowTitle:Bool {
        percentageComplete <= 1
}
}
