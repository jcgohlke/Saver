//
//  GoalView.swift
//  Saver
//
//  Created by Joben Gohlke on 4/25/21.
//

import SwiftUI
import ComposableArchitecture

struct GoalView: View {
  
  let store: Store<Goal, GoalAction>
  let priceFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    
    return f
  }()
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 20) {
        HStack {
          Button(action: { viewStore.send(.archived) }) {
            Image(systemName: viewStore.isArchived ? "checkmark.square" : "square")
          }
          .buttonStyle(PlainButtonStyle())
          
          TextField(
            "Goal description",
            text: viewStore.binding(get: { $0.description }, send: GoalAction.textFieldChanged)
          )
          .font(.title)
        }
        HStack {
          Text(priceFormatter.string(from: viewStore.progress as NSNumber)!)
          
          ProgressView(value: viewStore.progress / viewStore.amount)

          Text(priceFormatter.string(from: viewStore.amount as NSNumber)!)
        }
      }
      .padding()
    }
  }
}

struct GoalView_Previews: PreviewProvider {
  static var previews: some View {
    GoalView(
      store: Store(
        initialState: Goal(
          id: UUID(),
          description: "New 4K TV",
          amount: 1000,
          progress: 50,
          isArchived: false
        ),
        reducer: goalReducer,
        environment: GoalEnvironment()
      )
    )
    .previewLayout(.sizeThatFits)
  }
}
