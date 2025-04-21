import Foundation

@Observable
class BoardItemViewModel {
  var showObject: ShowObject?
  private let boardItem: BoardItem
  private let showObjectRepository: ShowObjectRepository

  var size: CGSize { boardItem.size }

  init(boardItem: BoardItem, showObjectRepository: ShowObjectRepository) {
    self.boardItem = boardItem
    self.showObjectRepository = showObjectRepository
  }

  func fetchShowObject() async {
    let referenceID = boardItem.referenceID

    do {
      let showObject = try await showObjectRepository.getObject(by: referenceID)
      await MainActor.run {
        self.showObject = showObject
      }
    } catch {
      print("Error fetching show object: \(error)")
    }
  }
}
