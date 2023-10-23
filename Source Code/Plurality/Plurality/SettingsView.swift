//
//  SettingsView.swift
//  Plurality
//
//  Created by Mark Howard on 25/08/2023.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State var showingAppNotificationsClearedAlert = false
    @State var tabSelection = 1
    var body: some View {
        TabView(selection: $tabSelection) {
            notificationSettings
                .tag(1)
                .tabItem {
                    Image(systemName: "app.badge")
                    Text("Notifications")
                }
                .frame(width: 300, height: 200)
            miscSettings
                .tag(2)
                .tabItem {
                    Image(systemName: "ellipsis.circle")
                    Text("Misc.")
                }
                .frame(width: 300, height: 150)
        }
    }
    var notificationSettings: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("Notifications Setup")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }) {
                        Text("Request Permissions")
                    }
                    Button(action: {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        showingAppNotificationsClearedAlert = true
                    }) {
                        Text("Clear All Scheduled Notifications")
                    }
                    .alert("Notifications Cleared", isPresented: $showingAppNotificationsClearedAlert) {
                        Button(action: {self.showingAppNotificationsClearedAlert = true}) {
                            Text("Done")
                        }
                    }
                }
                Spacer()
            }
        }
    }
    var miscSettings: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    LabeledContent("Version", value: "1.0")
                    LabeledContent("Build", value: "1")
                }
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
