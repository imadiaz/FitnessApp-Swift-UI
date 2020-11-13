//
//  CreateChallengueViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 29/10/20.
//

import SwiftUI
import Combine
typealias UserId = String
final class CreateChallengueViewModel : ObservableObject {

    @Published  var excerciseDropDown = ChallenguePartViewModel(type: .exercise)
    @Published  var startAmountDropDown = ChallenguePartViewModel(type: .startAmount)
    @Published  var increseDropDown = ChallenguePartViewModel(type: .increse)
    @Published  var lengthDropDown = ChallenguePartViewModel(type: .length)
    @Published var error:FitnessAppError?
    @Published var isLoading = false
    
    private let userService:UserServiceProtocol
    private var cancellables:[AnyCancellable] = []
    private let challengueService:ChallengueServiceProtocol
    
    
    enum Action {
        case createChallengue
    }
    
    
    init(userService:UserServiceProtocol = UserService(),challengueService:ChallengueServiceProtocol = ChallengueService()) {
        self.userService = userService
        self.challengueService = challengueService
    }
    
    func send(action:Action){
        switch action {
        case .createChallengue :
            isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void,FitnessAppError> in
                return self.createChallengue(userId: userId)
            }.sink{ completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("completed")
                    break
                }
            } receiveValue: { userId in
                print("retrieved userId = \(userId)")
            }.store(in: &cancellables)
       }
    }
    
    private func createChallengue(userId:UserId) -> AnyPublisher<Void,FitnessAppError>{
        print("al create firestore")
        guard let exercise = excerciseDropDown.text,
              let startAmount = startAmountDropDown.number,
              let increase = increseDropDown.number,
              let length = lengthDropDown.number else {
            return Fail(error: .default(description:"Error to save user in firestore")).eraseToAnyPublisher()
        }
        let startDate = Calendar.current.startOfDay(for: Date())
        let challengue = Challengue(
            exercise: exercise,
            startAmount: startAmount,
            increase: increase,
            length: length,
            userId: userId,
            startDate: startDate,
            activities: (0..<length).compactMap { dayNum in
                if let dateForDayNum = Calendar.current.date(byAdding: .day, value: dayNum, to: startDate){
                    return .init(date: dateForDayNum,isComplete:false)
                } else {
                    return nil
                }
            }
        )
        return challengueService.createChallengue(challengue).eraseToAnyPublisher()
    }

    
    private func currentUserId() -> AnyPublisher<UserId,FitnessAppError> {
        return userService.currentUserPublisher().flatMap{ user -> AnyPublisher<UserId,FitnessAppError> in
            if let userId = user?.uid {
                print("return exist user")
                return Just(userId)
                    .setFailureType(to:FitnessAppError.self)
                    .eraseToAnyPublisher()
            }else{
                print("create a new user")
                return self.userService.signInAnonymusly()
                    .map{$0.uid}
                    .eraseToAnyPublisher()
            } 
        }.eraseToAnyPublisher()
    }
}


extension CreateChallengueViewModel {
    struct ChallenguePartViewModel:DropdownItemProtocol {
        var selectedOption: DropdownOption
                
        var options: [DropdownOption]
        
        var headerTitle: String {
            type.rawValue
        }
        
        var dropdownTitle: String {
            selectedOption.formatted
        }
        
        var isSelected: Bool = false
        private let type:ChallenguePartType
        
        init(type:ChallenguePartType) {
            
            switch type {
            case .exercise:
                self.options = ExerciseOption.allCases.map{ $0.toDropdownOption }
            case .startAmount :
                self.options = StartOption.allCases.map{ $0.toDropdownOption }
                
            case .increse :
                self.options = IncreaseOption.allCases.map { $0.toDropdownOption }
                
            case .length :
                self.options = LengthOption.allCases.map { $0.toDropdownOption }
            }
 
            self.type = type
            self.selectedOption  =  options.first!

        }
        
        enum ChallenguePartType : String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Starting Amount"
            case increse = "Daily Increase"
            case length = "Challengue Length"
        }
        enum ExerciseOption:String,CaseIterable,DropdownOptionProtocol {
            case pullups
            case pushups
            case siups
            var toDropdownOption: DropdownOption {
                .init(type: .text(rawValue),
                      formatted: rawValue.capitalized)
            }
        }
        
        enum StartOption: Int,CaseIterable ,DropdownOptionProtocol {
            case one = 1,two,three,four,five
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue),
                      formatted: "\(rawValue)")
            }
        }
        
        enum IncreaseOption: Int,CaseIterable ,DropdownOptionProtocol {
            case one = 1, two,three,four,five
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue),
                      formatted: "+\(rawValue)")
            }
        }
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven=7,fourteen=14,twentyOne=21,twentyEight=28
            var toDropdownOption: DropdownOption{
                .init(type: .number(rawValue),
                      formatted: "\(rawValue) days")
            }
            
            
        }
        
    }
}

extension CreateChallengueViewModel.ChallenguePartViewModel {
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }
    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        }
        return nil
    }
}
