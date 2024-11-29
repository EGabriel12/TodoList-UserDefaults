//
//  ContentView.swift
//  TodoList
//
//  Created by Elias Gabriel dos Santos Correa on 29/11/24.
//

import SwiftUI
import Foundation

struct Todo: Identifiable, Equatable, Codable {
  var id = UUID()
  var text: String = ""
  var isDone = false
}

struct ContentView: View {

  @State private var todos: [Todo] = []

  private let key = "todosModelViewData"

  var body: some View {
    NavigationStack {
      List {
        ForEach($todos) { $todo in
          HStack {
            TextField("Todo", text: $todo.text)
            Spacer()
            Image(systemName: todo.isDone ? "checkmark.circle" : "circle")
              .onTapGesture {
                todo.isDone.toggle()
              }
          }
          .onChange(of: todo) { oldValue, newValue in
            save(items: todos, key: key)
          }

        }
      }
      .onAppear {
        todos = load(key: key)
      }
      .navigationTitle("Todos ✅")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            todos.append(Todo())
            save(items: todos, key: key)
          } label: {
            Image(systemName: "plus")
          }

        }
      }
    }
  }
}

#Preview {
  ContentView()
}

func save<T: Identifiable & Codable>(items: [T], key: String) {
  if let encoded = try? JSONEncoder().encode(items) {
    UserDefaults.standard.setValue(encoded, forKey: key)
  }
}


func load<T: Identifiable & Codable>(key: String) -> [T] {
  guard let data = UserDefaults.standard.data(forKey: key) else {
    return []
  }

  if let dataArray = try? JSONDecoder().decode([T].self, from: data) {
    return dataArray
  }

  return []
}
