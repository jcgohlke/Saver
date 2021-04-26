//
//  Goal.swift
//  Saver
//
//  Created by Joben Gohlke on 4/25/21.
//

import Foundation
import ComposableArchitecture

struct Goal: Equatable, Identifiable {
  let id: UUID
  var description = ""
  let amount: Double
  var progress: Double = 0
  var isArchived = false
}

enum GoalAction: Equatable {
  case progressChanged(Double)
  case textFieldChanged(String)
  case archived
}

struct GoalEnvironment {}

let goalReducer = Reducer<Goal, GoalAction, GoalEnvironment> { goal, action, _ in
  switch action {
    case .archived:
      goal.isArchived.toggle()
      return .none
    case let .progressChanged(amountChanged):
      goal.progress += amountChanged
      return .none
    case let .textFieldChanged(description):
      goal.description = description
      return .none
  }
}
