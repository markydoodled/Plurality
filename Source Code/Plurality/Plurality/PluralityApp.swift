//
//  PluralityApp.swift
//  Plurality
//
//  Created by Mark Howard on 14/07/2023.
//

import SwiftUI

@main
struct PluralityApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .commands {
            SidebarCommands()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        Window("New Member", id: "new-member") {
            NewMemberView()
                .frame(minWidth: 900, minHeight: 600)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #endif
    }
}
