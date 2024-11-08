//
//  Analytics.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

import TelemetryDeck
import CoreData

class Analytics {
    // Analytics should only be initialized one time so a signleton it is!
    static let shared = Analytics()
    
    private let appID = "63666D7A-FE6E-4509-B166-A00FF4A7171C"
    
    init() {
        let config = TelemetryDeck.Config(appID: appID)
        TelemetryDeck.initialize(config: config)
    }
    
    func updateUserID(with userID: String) {
        TelemetryDeck.updateDefaultUserID(to: userID)
    }
    
    private func getNumberOfShows() async -> Int {
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        let numberOfShows: Int? = try? await backgroundContext.perform {
            let fetchRequest: NSFetchRequest<ShowEntity> = ShowEntity.fetchRequest()
            let count = try backgroundContext.count(for: fetchRequest)
            return count
        }
        return numberOfShows ?? 0
    }
    
    func logEvent(with event: AnalyticEvent, parameters: [AnalyticEventParameter: String] = [:]) {
        Task {
            var parameters = parameters
            // Everytime an event occurs, get the numberOfShows
            parameters[.numberOfShows] = await String(getNumberOfShows())
            // Convert enum keys to strings
            let stringParameters = parameters.reduce(into: [String: String]()) { result, pair in
                result[pair.key.rawValue] = pair.value
            }
            
            TelemetryDeck.signal(event.rawValue, parameters: stringParameters)
            HogLogger.log(category: .analytics).debug("🔦 Logged event: \(event.rawValue) | \(stringParameters)")
        }
    }

    func logError(with error: Error, for logCategory: LogCategory) {
        HogLogger.log(category: logCategory).error("🚨 Error: \(error)")
        TelemetryDeck.signal("TelemetryDeck.Error.occurred", parameters: ["TelemetryDeck.Error.id": error.localizedDescription])
    }
}
