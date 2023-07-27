//
//  ContentView.swift
//  Plurality watchOS Watch App
//
//  Created by Mark Howard on 16/07/2023.
//

import SwiftUI
import PhotosUI
import CoreData
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var tabSelection = 1
    @State var showingNewAlter = false
    @State var addNewAlterDisabled = true
    @State var searchMembersText = ""
    @State var searchHistoryText = ""
    
    @State var appNotificationsTitleText = ""
    @State var appNotificationsDueDateAndTime = Date()
    @State var showingAppNotificationsClearedAlert = false
    
    @State var newAlterName = ""
    @State var newAlterAge = Int64(1)
    @State var newAlterBirthday = Date()
    @State var newAlterDescription = ""
    @State var newAlterRole = ""
    @State var newAlterLikes = ""
    @State var newAlterDislikes = ""
    @State var newAlterGender = ""
    @State var newAlterPronouns = ""
    @State var newAlterSexuality = ""
    @State var newAlterFavouriteFood = ""
    @State var newAlterHobbies = ""
    @State var newAlterNotes = ""
    @State var newAlterAvatarImageData = Data()
    
    @State var avatarItem: PhotosPickerItem?
    @State var avatarImage: Image?
    
    @State var alterDetailsName = ""
    @State var alterDetailsAge = Int64(1)
    @State var alterDetailsBirthday = Date()
    @State var alterDetailsDescription = ""
    @State var alterDetailsRole = ""
    @State var alterDetailsLikes = ""
    @State var alterDetailsDislikes = ""
    @State var alterDetailsGender = ""
    @State var alterDetailsPronouns = ""
    @State var alterDetailsSexuality = ""
    @State var alterDetailsFavouriteFood = ""
    @State var alterDetailsHobbies = ""
    @State var alterDetailsNotes = ""
    @State var alterDetailsAvatarImageData = Data()
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                members
            }
                .tag(1)
            NavigationStack {
                history
            }
                .tag(2)
            NavigationStack {
                more
            }
                .tag(3)
        }
    }
    var members: some View {
        Text("Members")
    }
    var history: some View {
        Text("History")
    }
    var more: some View {
        Form {
            Section {
                NavigationLink(destination: appNotifications) {
                    Label("App Notifications", systemImage: "app.badge")
                }
            }
            Section {
                NavigationLink(destination: settings) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .navigationTitle("More")
    }
    var settings: some View {
        Text("Settings")
    }
    var appNotifications: some View {
        Text("App Notifications")
    }
    var newAlter: some View {
        Text("New Alter")
    }
    var alterDetails: some View {
        Text("Alter Details")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
