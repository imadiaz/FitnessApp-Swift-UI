//
//  UserService.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 29/10/20.
//

import Combine
import FirebaseAuth

protocol UserServiceProtocol {
    var currentUser:User? {
        get
    }
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signInAnonymusly() -> AnyPublisher<User,FitnessAppError>
    func observeAuthChanges() -> AnyPublisher<User?,Never>
    func linkAccount(email:String,password:String) -> AnyPublisher<Void,FitnessAppError>
    func logout() -> AnyPublisher<Void,FitnessAppError>
    func login(email:String,password:String) -> AnyPublisher<Void,FitnessAppError>
}

final class UserService:UserServiceProtocol{
    let currentUser = Auth.auth().currentUser
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func signInAnonymusly() -> AnyPublisher<User, FitnessAppError> {
        return Future<User,FitnessAppError>{ promise in
            Auth.auth().signInAnonymously { result,error in
                if let error = error {
                    return promise(.failure(.auth(description: error.localizedDescription)))
                }else if let user = result?.user {
                    return promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, FitnessAppError> {
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        return Future<Void,FitnessAppError> { promise in
            Auth.auth().currentUser?.link(with: emailCredential){ result, error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                }else if let user = result?.user {
                    Auth.auth().updateCurrentUser(user){error in
                        if let error = error {
                            return promise(.failure(.default(description: error.localizedDescription)))
                        }else{
                            return promise(.success(()))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, FitnessAppError> {
        return Future<Void,FitnessAppError> { promise in
            do{
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, FitnessAppError> {
        return Future<Void,FitnessAppError>{ promise in
            Auth.auth().signIn(withEmail: email, password: password){ result,error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                }else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
   
}
