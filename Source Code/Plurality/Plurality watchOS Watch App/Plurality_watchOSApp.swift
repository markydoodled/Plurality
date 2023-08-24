//
//  Plurality_watchOSApp.swift
//  Plurality watchOS Watch App
//
//  Created by Mark Howard on 16/07/2023.
//

import SwiftUI

@main
struct Plurality_watchOS_Watch_AppApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
