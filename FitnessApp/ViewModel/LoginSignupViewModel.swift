//
//  LoginSignupViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 02/11/20.
//

import Combine
import SwiftUI
final class  LoginSignupViewModel:ObservableObject {
    private let mode:Mode
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    @Binding var isPushed: Bool
    private let userService:UserServiceProtocol
    private var cancellables:[AnyCancellable] = []
    
    init(
        mode:Mode,
        userService:UserServiceProtocol = UserService(),
        isPushed: Binding<Bool>
    ) {
        self.mode = mode
        self.userService = userService
        self._isPushed = isPushed
        
        Publishers.CombineLatest($emailText,$passwordText)
            .map { [weak self] email,password in
                print("validate fields")
                return self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
            }.assign(to: &$isValid)
    }
    
    var title:String {
        switch mode{
        case .login :
            return "Welcome back!"
        case .signup:
            return "Create an account"
        }
    }
    
    var subtitle:String {
        switch mode {
        case .login:
            return "Log in with your email"
        case .signup:
            return "Sign up via email"
        
    }
    }
    
    var buttonTitle:String {
        switch mode{
        case .login :
            return "Login"
        case .signup:
            return "Sign up"
        }
    }
    
    func tappedActionButton(){
        switch mode {
        case .login:
            userService.login(email: emailText, password: passwordText)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished:break
                    }
                } receiveValue: { _ in
                    
                }.store(in: &cancellables)
        case .signup:
            userService.linkAccount(email: emailText, password: passwordText)
                .sink {[weak self] completion in
                    switch completion {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished:
                        self?.isPushed = false
                        print("finished")
                    }
                } receiveValue: { _ in}
                .store(in: &cancellables)
    }
    }
}
extension LoginSignupViewModel {
    func isValidEmail(_ email:String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 5
    }
    func isValidPassword(_ passowrd:String) -> Bool {
        return passowrd.count > 5
    }
}
extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
