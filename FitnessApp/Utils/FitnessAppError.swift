//
//  FitnessAppError.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 30/10/20.
//

import Foundation

enum FitnessAppError:LocalizedError {
    case auth(description: String)
    case `default` (description:String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
        return description ?? "something went wrong"
    }
}
}
