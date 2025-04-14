//
//  EditObjectView.swift
//  iHog
//
//  Created by Jay Wilson on 11/21/20.
//

import CoreData
import SwiftUI

struct EditObjectView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode

  @ObservedObject var show: ChosenShow

  @State var obj: ShowObject

  @State private var name = ""
  @State private var number = ""
  @State private var isOutlined = false
  @State private var objColor = 1
  @State private var indexOfOBJ = 0

  var body: some View {
    VStack {
      HStack {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
          Text("Cancel")
        }
        .foregroundColor(.red)
        .padding(.horizontal)
        Spacer()
        Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          saveValues()
        }) {
          Text("Save")
        }
        .foregroundColor(.green)
        .padding(.horizontal)
      }
      .padding(.vertical)
      Form {
        TextField("Name", text: $name)
          .multilineTextAlignment(.leading)
          .frame(alignment: .leading)
        TextField("Number", text: $number)
          .keyboardType(.decimalPad)
          .multilineTextAlignment(.leading)
          .frame(alignment: .leading)
        Toggle("Is Outlined", isOn: $isOutlined)
        Picker("Color", selection: $objColor) {
          ForEach(0..<OBJ_COLORS.count, id: \.self) {
            Text(OBJ_COLORS[$0].description.capitalized)
          }
        }
        .pickerStyle(MenuPickerStyle())
      }
      ShowObjectView(
        show: show,
        obj: ShowObject(
          objType: obj.objType,
          number: Double(number) ?? obj.number,
          name: name,
          objColor: OBJ_COLORS[objColor].description,
          isOutlined: isOutlined
        ),
        size: "medium"
      )
    }
    .onAppear {
      getInitialValues()
    }
  }

  func getInitialValues() {
    name = obj.getName()
    number = obj.getObjNumber()
    isOutlined = obj.isOutlined
    objColor = obj.getColor()
  }

  func saveValues() {
    let num = Double(number) ?? obj.number
    if obj.getName() != name {
      obj.setName(name)
    }

    obj.setNumber(num)
    obj.setColor(OBJ_COLORS[objColor].description)
    obj.setOutline(isOutlined)

    Task {
      let updatedObject = obj
      do {
        try await show.updateObject(updatedObject)
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }
}

//struct EditObjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditObjectView(obj: testShowObjects[0])
//    }
//}
