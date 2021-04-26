//
//  AddGoalView.swift
//  Saver
//
//  Created by Joben Gohlke on 4/26/21.
//

import SwiftUI

struct AddGoalView: View {
  @State var description = ""
  @State var goalAmount = ""
  @State var startingAmount = ""
  
  var body: some View {
    NavigationView {
      List {
        TextField("Description", text: $description)
        TextField("Goal Amount", text: $goalAmount)
        TextField("Starting Amount", text: $startingAmount)
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle("New Goal")
      .navigationBarItems(
        leading: Button("Cancel", action: {
          
        }),
        trailing: Button("Add", action: {
          
        }))
    }
  }
}

struct AddGoalView_Previews: PreviewProvider {
  static var previews: some View {
    AddGoalView()
  }
}
