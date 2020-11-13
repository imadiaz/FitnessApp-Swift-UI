//
//  ChallengueService.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 29/10/20.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
protocol ChallengueServiceProtocol {
    func createChallengue(_ challengue: Challengue) -> AnyPublisher<Void,FitnessAppError>
    func observeChallengues(userId:UserId) -> AnyPublisher<[Challengue],FitnessAppError>
    func delete(_ challengue:String) -> AnyPublisher<Void,FitnessAppError>
    func updateChallengue(_ challengueId:String,activities:[Activity]) -> AnyPublisher<Void,FitnessAppError>
}
final class ChallengueService:ChallengueServiceProtocol {
    private let db = Firestore.firestore()
    func createChallengue(_ challengue: Challengue) -> AnyPublisher<Void, FitnessAppError> {
        
        return Future<Void,FitnessAppError>{ promise in
            do{
                _ = try self.db.collection("challengues").addDocument(from: challengue){ error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                    }else{
                        promise(.success(()))
                    }
                }
                promise(.success(()))
            } catch{
                promise(.failure(.default()))
            }
        }.eraseToAnyPublisher()
    }
    
    func observeChallengues(userId: UserId) -> AnyPublisher<[Challengue], FitnessAppError> {
        let query = db.collection("challengues").whereField("userId", isEqualTo: userId).order(by: "startDate",descending: true)
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap{ snapShot -> AnyPublisher<[Challengue],FitnessAppError> in
                do {
                    let challengues = try snapShot.documents.compactMap {
                        try $0.data(as: Challengue.self)
                    }
                    return Just(challengues).setFailureType(to: FitnessAppError.self).eraseToAnyPublisher()
                }catch{
                    return Fail(error: .default(description:"Parsing error")).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func delete(_ challengue: String) -> AnyPublisher<Void, FitnessAppError> {
        return Future<Void,FitnessAppError> { promise in
            self.db.collection("challengues").document(challengue).delete { error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateChallengue(_ challengueId: String, activities: [Activity]) -> AnyPublisher<Void, FitnessAppError> {
        return Future<Void,FitnessAppError> { promise in
            self.db.collection("challengues").document(challengueId).updateData(
                [
                    "activities": activities.map {
                        return ["date":$0.date,"isComplete":$0.isComplete]
                    }
                ]
            )
            { error in
                if let error = error {
                    promise(.failure(.default(description:error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
