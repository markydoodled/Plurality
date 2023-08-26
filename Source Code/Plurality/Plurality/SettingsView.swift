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
    var body: some View {
        VStack {
            GroupBox {
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
            } label: {
                Label("Notifications", systemImage: "app.badge")
            }
            .padding(.horizontal)
            GroupBox {
                HStack {
                    Spacer()
                    VStack {
                        LabeledContent("Version", value: "1.0")
                        LabeledContent("Build", value: "1")
                    }
                    Spacer()
                }
            } label: {
                Label("Misc.", systemImage: "ellipsis.circle")
            }
            .padding(.horizontal)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
