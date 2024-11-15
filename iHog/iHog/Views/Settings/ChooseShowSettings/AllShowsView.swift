//
//  AllShowsView.swift
//  iHog
//
//  Created by Jay Wilson on 2/19/22.
//

import CoreData
import SwiftUI

struct EmptyShowList: View {
  var body: some View {
    VStack {
      HStack { Spacer() }
      Text("No shows added.\nAdd a show to control Lists, Groups, Scenes, and Palettes.")
        .multilineTextAlignment(.center)
    }
  }
}

struct AllShowsView: View {
  @EnvironmentObject var user: UserState
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  // Gets shows
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CDShowEntity.dateLastModified, ascending: true)],
    animation: .default
  )
  private var shows: FetchedResults<CDShowEntity>

  @State private var isAddingShow: Bool = false
  @State private var showCurrentPaywall = false

  var body: some View {
    switch horizontalSizeClass {
      case .regular:
        List {
          Section {
            HStack {
              Text("Show name")
                .font(.subheadline)
                .foregroundColor(.gray)
              Spacer()
              Text("Last Modified Date")
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground).opacity(0.5))
            .listRowSeparator(.hidden)
            if shows.count == 0 {
              EmptyShowList()
            }
            ForEach(shows) { show in
              NavigationLink(
                destination: {
                  ShowNavigation(selectedShow: show)
                },
                label: {
                  HStack {
                    Image(systemName: show.icon ?? SFSymbol._folder.name)
                    Text(show.name ?? "Name not found")
                    Spacer()
                    Text(
                      show.dateLastModified?
                        .formatted(
                          .iso8601
                            .month()
                            .day()
                            .year()
                            .dateSeparator(.dash)
                        ) ?? "Date not found"
                    )
                  }
                }
              )
              .listRowBackground(Color(UIColor.systemGroupedBackground))
            }
            .onDelete { indexSet in
              self.delete(at: indexSet)
            }
          }
        }
        .onAppear {
          UITableView.appearance().backgroundColor = UIColor.clear
        }
      default:
        Section {
          HStack {
            Text("Show name")
              .font(.subheadline)
              .foregroundColor(.gray)
            Spacer()
            Text("Last Modified Date")
              .font(.subheadline)
              .foregroundColor(.gray)
          }
          .listRowBackground(Color(UIColor.systemGroupedBackground).opacity(0.5))
          .listRowSeparator(.hidden)

          if shows.count == 0 {
            EmptyShowList()
          }
          ForEach(shows) { show in
            NavigationLink(
              destination: {
                ShowNavigation(selectedShow: show)
              },
              label: {
                HStack {
                  Image(systemName: show.icon ?? SFSymbol._folder.name)
                  Text(show.name ?? "Name not found")
                  Spacer()
                  Text(
                    show.dateLastModified?
                      .formatted(
                        .iso8601
                          .month()
                          .day()
                          .year()
                          .dateSeparator(.dash)
                      ) ?? "Date not found"
                  )
                }
              }
            )
            .listRowBackground(Color(UIColor.systemGroupedBackground))
          }
          .onDelete { indexSet in
            self.delete(at: indexSet)
          }

        }
    }
  }

  func addShow() {
    if user.isPro {
      isAddingShow.toggle()
    } else {
      if shows.count >= 1 {
        showCurrentPaywall.toggle()
      } else {
        isAddingShow.toggle()
      }
    }
  }

  func delete(at offsets: IndexSet) {
    let indexOfShow: Int = offsets.first ?? 0

    let showID: NSUUID = shows[indexOfShow].id! as NSUUID

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
      entityName: "ShowEntity"
    )
    fetchRequest.predicate = NSPredicate(format: "id == %@", showID as CVarArg)
    fetchRequest.fetchLimit = 1
    do {
      let test = try viewContext.fetch(fetchRequest)
      let showToDelete = test[0] as! NSManagedObject
      viewContext.delete(showToDelete)
      try viewContext.save()
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .critical)
    }
  }
}
