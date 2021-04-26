//
//  GoalsView.swift
//  Saver
//
//  Created by Joben Gohlke on 4/25/21.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
  var goals: IdentifiedArrayOf<Goal> = []
}

enum AppAction: Equatable {
  case addGoalButtonTapped
  case delete(IndexSet)
  case goal(id: UUID, action: GoalAction)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  goalReducer.forEach(
    state: \.goals,
    action: /AppAction.goal(id:action:),
    environment: { _ in GoalEnvironment() }
  ),
  Reducer { state, action, environment in
    switch action {
      case .addGoalButtonTapped:
        state.goals.insert(Goal(id: environment.uuid(), amount: 0.0), at: 0)
        return .none
      case let .delete(indexSet):
        state.goals.remove(atOffsets: indexSet)
        return .none
      case .goal(id: _, action: .archived):
        return .none
      case .goal:
        return .none
    }
  }
)

struct GoalsView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        List {
          ForEachStore(
            self.store.scope(state: { $0.goals }, action: AppAction.goal(id:action:)),
            content: GoalView.init(store:)
          )
        }
        
        .navigationBarTitle("Goals")
        .navigationBarItems(
          leading: Button(
            action: { viewStore.send(.addGoalButtonTapped, animation: .default) },
            label: { Image(systemName: "plus.circle") }
          ),
          trailing: EditButton())
      }
      
    }
  }
}

extension IdentifiedArray where ID == UUID, Element == Goal {
  static let mock: Self = [
    Goal(
      id: UUID(),
      description: "Buy new TV",
      amount: 1000,
      progress: 50,
      isArchived: false
    ),
    Goal(
      id: UUID(),
      description: "Beach vacation",
      amount: 500,
      progress: 100,
      isArchived: false
    )
  ]
}

struct GoalsView_Previews: PreviewProvider {
  static var previews: some View {
    GoalsView(
      store: Store(
        initialState: AppState(goals: .mock),
        reducer: appReducer,
        environment: AppEnvironment(
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          uuid: UUID.init
        )
      )
    )
  }
}
