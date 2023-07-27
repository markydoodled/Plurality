//
//  AppIntents.swift
//  Plurality
//
//  Created by Mark Howard on 16/07/2023.
//

import AppIntents

struct AddAlterIntent: AppIntent {
    static let title: LocalizedStringResource = "Add New Alter"
    static let description: LocalizedStringResource = "Add A New Alter To The Plurality App"
    static let openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        //DeepLinkManager.handle(TransferURLScheme.createTransferFromShareExtension)
        return .result()
    }
}

struct AddAlterAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddAlterIntent(),
            phrases: ["Add A New \(.applicationName) Alter"],
            shortTitle: "Add A New Alter",
            systemImageName: "plus"
        )
    }
}
