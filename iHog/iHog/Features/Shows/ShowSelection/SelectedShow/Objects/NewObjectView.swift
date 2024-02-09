//
//  NewObjectView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

enum SavingObjectError: Error {
  case noNumber

  var title: String {
    switch self {
      case .noNumber:
        "No object number"
    }
  }

  var expanded: String {
    switch self {
      case .noNumber:
        "Assign the number that is the same as the object's number in your Hog show file"
    }
  }
}

struct NewObjectView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(\.dismiss) var dismiss

  var show: ShowEntity

  @State private var name: String = ""
  @State private var number: String = ""
  @State private var error: SavingObjectError? = nil
  @State private var objectType = ObjectType.group

  var body: some View {
    NavigationStack {
      Form {
        if let error {
          Section {
            Text(error.title)
              .foregroundStyle(.red)
            Text(error.expanded)
          } header: {
            Text("Could not save object")
          }
        }

        Section {
          TextField("Name", text: $name)
          TextField("Number", text: $number)
            .keyboardType(.decimalPad)
          Picker("Type", selection: $objectType) {
            ForEach(ObjectType.allCases) { objType in
              Text(objType.label)
                .tag(objType)
            }
          }
        }

        Section {
          Button("Add 1 \(objectType.label)") {
            bulkAddObject()
          }
        }

        Section {
          Button("Add 5 \(objectType.label)s starting at \(number)") {
            bulkAddObject(amount: 5)
          }
          Button("Add 10 \(objectType.label)s starting at \(number)") {
            bulkAddObject(amount: 10)
          }
          Button("Add 100 \(objectType.label)s starting at \(number)") {
            bulkAddObject(amount: 100)
          }
        } header: {
          Text("Quick add")
        } footer: {
          Text(
            "\(objectType.label) number will be incremented by 1 and have the same name if you entered a name"
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            if moc.hasChanges {
              moc.reset()
            }
            dismiss()
          }
          .tint(.red)
        }
      }
    }
  }

  func bulkAddObject(amount: Int = 1) {
    do {
      try validate()
      for num in 0...(amount - 1) {
        let object = ShowObjectEntity(context: moc)
        object.name = name
        object.givenID = UUID()
        object.number = Double(number)! + Double(num)
        object.showID = show.givenID?.uuidString
        object.objType = objectType.rawValue
        object.show = show
      }
      saveObject()
      dismiss()
    } catch {
      self.error = .noNumber
      return
    }
  }

  func saveObject() {
    do {
      try moc.save()
    } catch {
      print(error)
    }
  }

  func validate() throws {
    if number.isEmpty {
      throw SavingObjectError.noNumber
    }
  }
}

#Preview {
  NewObjectView(show: .mock)
    .environment(\.managedObjectContext, .mock)
}
