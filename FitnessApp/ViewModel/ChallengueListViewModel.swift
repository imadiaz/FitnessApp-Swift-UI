//
//  ChallengueListViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 30/10/20.
//

import SwiftUI
import Combine
final class ChallengueListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengueService: ChallengueServiceProtocol
    private var cancellables:[AnyCancellable] = []
    @Published private(set) var itemViewModels:[ChallengueItemViewModel] = []
    @Published private(set) var error:FitnessAppError?
    @Published private(set) var isLoading = false
    @Published var showingCreateModal = false
    
    let title = "Challengues"
    
    enum Action {
        case retry
        case create
        case timeChange
    }
    
    init(userService:UserServiceProtocol = UserService(),
         challengueService: ChallengueServiceProtocol = ChallengueService()) {
        self.userService = userService
        self.challengueService = challengueService
        observeChallengues()
    }
    
    
    
    func send(action:Action){
        switch action {
        case .retry:
            observeChallengues()
        case .create:
            showingCreateModal = true
        case .timeChange:
            cancellables.removeAll()
            observeChallengues()
        }
        
    }
    
    
    
    private func observeChallengues(){
        isLoading = true
        userService.currentUserPublisher()
            .compactMap{
                $0?.uid
            }
            .flatMap{ [weak self] userId -> AnyPublisher<[Challengue],FitnessAppError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher()}
                return self.challengueService.observeChallengues(userId: userId)
            }.sink{[weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("finished")
                }
              
            }receiveValue: {[weak self] challengues in
                guard let self = self else { return }
                self.error = nil
                self.isLoading = false
                self.showingCreateModal = false
                self.itemViewModels = challengues.map{ challengue in
                    .init(challengue,
                          onDelete: { [weak self] id in
                            self?.deleteChallengue(id)
                          },
                          onToggleComplete: {[weak self] id, activities in
                            self?.updateChallengue(id:id,activities:activities)
                          })
                    }
            }.store(in: &cancellables)
        
    }
    private func deleteChallengue(_ challengueId:String){
        challengueService.delete(challengueId).sink { completion in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: {_ in
        }.store(in: &cancellables)
    }
    
    private func updateChallengue(id:String,activities:[Activity]){
        challengueService.updateChallengue(id, activities: activities)
            .sink { completion in
                switch completion{
                case let .failure(error):
                    self.error = error
                case .finished:break
                }
            } receiveValue: { _ in
            }.store(in: &cancellables)
    }
}
