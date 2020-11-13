//
//  ChallengueItemViewModel.swift
//  FitnessApp
//
//  Created by Immanuel Díaz on 30/10/20.
//

import Foundation

struct ChallengueItemViewModel: Identifiable {
    private let challengue:Challengue
    var id:String {
        challengue.id!
    }
    var title:String {
        challengue.exercise.capitalized
    }
    
    var progressCircleViewModel : ProgressCircleViewModel {
        let dayNumber = daysFromStart + 1
        let title = "Day"
        let message = isComplete ? "Done" : "\(dayNumber) of \(challengue.length)"
        return .init(title: title, message: message, percentageComplete: Double(dayNumber) / Double(challengue.length))
    }
    
    private var daysFromStart: Int {
        let startDate = Calendar.current.startOfDay(for: challengue.startDate)
        let toDate = Calendar.current.startOfDay(for: Date())
        guard let daysFromstart = Calendar.current.dateComponents([.day],from: startDate,to: toDate).day else {
            return 0
        }
        return abs(daysFromstart)
    }
    
     var isComplete: Bool {
        daysFromStart - challengue.length >= 0
    }
    var statusText:String {
        guard !isComplete else { return "Done" }
        let dayNumber = daysFromStart + 1
        return "Day \(dayNumber) of \(challengue.length)"
    }
    var dailyIncreaseText:String {
        "+\(challengue.increase) daily"
    }
    init(_ challengue: Challengue,onDelete: @escaping (String) -> Void,onToggleComplete: @escaping (String,[Activity]) -> Void) {
        self.challengue = challengue
        self.onDelete = onDelete
        self.onToggleComplete = onToggleComplete
    }
    
    let todayTitle  = "Today"
    var todayRepTitle:String {
        let repNumber = challengue.startAmount + (daysFromStart * challengue.increase)
        let exercise: String
        if repNumber == 1 {
            var challengueExercise = challengue.exercise
            challengueExercise.removeLast()
            exercise = challengueExercise
        } else{
            exercise = challengue.exercise
        }
        return isComplete ? "Completed" : "\(repNumber) " + exercise
    }
    var shouldShowTodayView: Bool {
        !isComplete
    }
    var isDayComplete:Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return challengue.activities.first(where: {$0.date == today})?.isComplete == true
    }
    
    private let onDelete:(String) -> Void
    
    private let onToggleComplete:(String,[Activity]) -> Void
    
    func send(action: Action){
        guard let id = challengue.id else { return }
        switch action {
        case .delete:
            onDelete(id)
        case .toggleComplete:
            let today = Calendar.current.startOfDay(for: Date())
            let activities =  challengue.activities.map {activity -> Activity in
                if today == activity.date {
                    return .init(date: today, isComplete: !activity.isComplete)
                }else{
                    return activity
                }
            }
            onToggleComplete(id,activities)
        }
    }
}

extension ChallengueItemViewModel {
    enum Action {
        case delete
        case toggleComplete
    }
}
