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
import WatchDatePicker

struct ContentView: View {
    //Core Data Database Fetch
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Alters.name, ascending: true)], animation: .default)
    private var items: FetchedResults<Alters>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Fronting.name, ascending: true)], animation: .default)
    private var frontHistory: FetchedResults<Fronting>
    
    //UI Control Variables
    @State var showingNewAlter = false
    @State var addNewAlterDisabled = true
    @State var searchMembersText = ""
    @State var searchHistoryText = ""
    //@State var openedViewName: String?
    
    //Custom Notification UI Storage
    @State var appNotificationsTitleText = ""
    @State var appNotificationsDueDateAndTime = Date()
    @State var showingAppNotificationsClearedAlert = false
    
    //Add Alter UI Storage
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
    
    //Alter Image Storage
    @State var avatarItem: PhotosPickerItem?
    @State var avatarImage: Image?
    
    //Alter Details UI Storage
    @State var alterDetailsName = ""
    @State var alterDetailsAge = Int64(1)
    @State var alterDetailsBirthday = ""
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
        NavigationStack {
            members
        }
    }
    
    //Members Main View
    var members: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    alterDetails
                        .onAppear() {
                            alterDetailsName = item.name ?? "None"
                            alterDetailsAge = item.age
                            alterDetailsBirthday = item.birthday?.formatted(date: .long, time: .omitted) ?? Date().formatted(date: .long, time: .omitted)
                            alterDetailsDescription = item.desc ?? "None"
                            alterDetailsRole = item.role ?? "None"
                            alterDetailsLikes = item.likes ?? "None"
                            alterDetailsDislikes = item.dislikes ?? "None"
                            alterDetailsGender = item.gender ?? "None"
                            alterDetailsPronouns = item.pronouns ?? "None"
                            alterDetailsSexuality = item.sexuality ?? "None"
                            alterDetailsFavouriteFood = item.food ?? "None"
                            alterDetailsHobbies = item.hobbies ?? "None"
                            alterDetailsNotes = item.notes ?? "None"
                            alterDetailsAvatarImageData = item.avatar ?? Data()
                        }
                        .id(item.id)
                } label: {
                    HStack {
                        /*Image("\(item.avatar)")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                            .scaledToFill()*/
                        Circle()
                            .foregroundColor(.secondary)
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text("\(item.name ?? "None")")
                                .bold()
                                .font(.title3)
                            if item.pronouns != "" {
                                Text("\(item.pronouns ?? "None")")
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
                .searchable(text: $searchMembersText, placement: .toolbar, prompt: Text("Search..."))
            }
            .onDelete(perform: deleteItems)
            Section {
                NavigationLink(destination: history) {
                    Label("History", systemImage: "clock.fill")
                }
                NavigationLink(destination: more) {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
            }
        }
        .listStyle(.automatic)
        .navigationTitle("Members")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {showingNewAlter = true}) {
                    Label("Add Item", systemImage: "plus")
                }
                .fullScreenCover(isPresented: $showingNewAlter) {
                    NavigationStack {
                        newAlter
                    }
                }
            }
        }
        .privacySensitive()
    }
    
    //Fronting History View
    var history: some View {
        List {
            ForEach(frontHistory) { frontHistory in
                NavigationLink {
                    Text("Test")
                } label: {
                    HStack {
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text("Alter Name")
                                .bold()
                                .font(.title3)
                            Text("Front Start Date - End Date")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                .searchable(text: $searchHistoryText, placement: .toolbar, prompt: Text("Search For Fronts..."))
            }
        }
        .listStyle(.automatic)
        .navigationTitle("History")
        .privacySensitive()
    }
    
    //More Options View
    var more: some View {
        Form {
            /*Section {
                NavigationLink(destination: appNotifications) {
                    Label("App Notifications", systemImage: "app.badge")
                }
            }*/
            Section {
                NavigationLink(destination: settings) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .navigationTitle("More")
    }
    
    //App Settings View
    var settings: some View {
        Form {
            Section {
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
            } header: {
                Label("Notifications", systemImage: "app.badge")
            }
            Section {
                LabeledContent("Version", value: "1.0")
                LabeledContent("Build", value: "1")
            } header: {
                Label("Misc.", systemImage: "ellipsis.circle")
            }
        }
        .navigationTitle("Settings")
    }
    
    //Custom App Notifications View
    var appNotifications: some View {
        Text("App Notifications")
    }
    
    //UI To Add A New Member Data
    var newAlter: some View {
        Form {
            Group {
                Section {
                    TextField("Name...", text: $newAlterName)
                    Stepper(value: $newAlterAge, in: 1...1000) {
                        Text("Age - \(newAlterAge)")
                            .font(.body)
                    }
                    DatePicker("Birthday", selection: $newAlterBirthday, displayedComponents: [.date])
                    TextField("Description...", text: $newAlterDescription, axis: .vertical)
                    TextField("Role...", text: $newAlterRole)
                } header: {
                    Label("Basic Info", systemImage: "info.circle")
                }
                Section {
                    PhotosPicker("Select Avatar...", selection: $avatarItem, matching: .images)
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .scaledToFit()
                    }
                } header: {
                    Label("Avatar", systemImage: "photo")
                }
                Section {
                    TextField("Likes...", text: $newAlterLikes, axis: .vertical)
                    TextField("Dislikes...", text: $newAlterDislikes, axis: .vertical)
                } header: {
                    Label("Likes And Dislikes", systemImage: "hand.thumbsup")
                }
                Section {
                    TextField("Gender...", text: $newAlterGender)
                    TextField("Pronouns...", text: $newAlterPronouns)
                    TextField("Sexuality...", text: $newAlterSexuality)
                } header: {
                    Label("Identity", systemImage: "figure.dress.line.vertical.figure")
                }
            }
            Group {
                Section {
                    TextField("Favourite Food...", text: $newAlterFavouriteFood, axis: .vertical)
                    TextField("Hobbies...", text: $newAlterHobbies, axis: .vertical)
                } header: {
                    Label("Activites", systemImage: "tennisball")
                }
                Section {
                    TextField("Notes...", text: $newAlterNotes, axis: .vertical)
                } header: {
                    Label("Other", systemImage: "ellipsis.circle")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    newAlterName = ""
                    newAlterAge = Int64(1)
                    newAlterBirthday = Date()
                    newAlterDescription = ""
                    newAlterRole = ""
                    newAlterLikes = ""
                    newAlterDislikes = ""
                    newAlterGender = ""
                    newAlterPronouns = ""
                    newAlterSexuality = ""
                    newAlterFavouriteFood = ""
                    newAlterHobbies = ""
                    newAlterNotes = ""
                    newAlterAvatarImageData = Data()
                    avatarItem = nil
                    avatarImage = nil
                    showingNewAlter = false
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    addItem()
                    newAlterName = ""
                    newAlterAge = Int64(1)
                    newAlterBirthday = Date()
                    newAlterDescription = ""
                    newAlterRole = ""
                    newAlterLikes = ""
                    newAlterDislikes = ""
                    newAlterGender = ""
                    newAlterPronouns = ""
                    newAlterSexuality = ""
                    newAlterFavouriteFood = ""
                    newAlterHobbies = ""
                    newAlterNotes = ""
                    newAlterAvatarImageData = Data()
                    avatarItem = nil
                    avatarImage = nil
                    showingNewAlter = false
                }) {
                    Text("Done")
                }
                .disabled(addNewAlterDisabled)
            }
        }
        .onChange(of: avatarItem) { _ in
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        avatarImage = Image(uiImage: uiImage)
                        return
                    }
                }
                print("Failed")
            }
        }
        .onAppear() {
            if newAlterName == "" {
                addNewAlterDisabled = true
            } else {
                addNewAlterDisabled = false
            }
        }
        .onChange(of: newAlterName) { _ in
            if newAlterName == "" {
                addNewAlterDisabled = true
            } else {
                addNewAlterDisabled = false
            }
        }
        .privacySensitive()
    }
    
    //Details For A Member From The Database
    var alterDetails: some View {
        Form {
            Group {
                Section {
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("No Avatar")
                    }
                } header: {
                    Label("Avatar", systemImage: "photo")
                }
                Section {
                    LabeledContent("Name") {
                        Text("\(alterDetailsName)")
                    }
                    LabeledContent("Age") {
                        Text("\(alterDetailsAge)")
                    }
                    LabeledContent("Birthday") {
                        Text("\(alterDetailsBirthday)")
                    }
                    LabeledContent("Description") {
                        Text("\(alterDetailsDescription)")
                    }
                    LabeledContent("Role") {
                        Text("\(alterDetailsRole)")
                    }
                } header: {
                    Label("Basic Info", systemImage: "info.circle")
                }
                Section {
                    LabeledContent("Likes") {
                        Text("\(alterDetailsLikes)")
                    }
                    LabeledContent("Dislikes") {
                        Text("\(alterDetailsDislikes)")
                    }
                } header: {
                    Label("Likes And Dislikes", systemImage: "hand.thumbsup")
                }
                Section {
                    LabeledContent("Gender") {
                        Text("\(alterDetailsGender)")
                    }
                    LabeledContent("Pronouns") {
                        Text("\(alterDetailsPronouns)")
                    }
                    LabeledContent("Sexuality") {
                        Text("\(alterDetailsSexuality)")
                    }
                } header: {
                    Label("Identity", systemImage: "figure.dress.line.vertical.figure")
                }
            }
            Group {
                Section {
                    LabeledContent("Favourite Food") {
                        Text("\(alterDetailsFavouriteFood)")
                    }
                    LabeledContent("Hobbies") {
                        Text("\(alterDetailsHobbies)")
                    }
                } header: {
                    Label("Activites", systemImage: "tennisball")
                }
                Section {
                    LabeledContent("Notes") {
                        Text("\(alterDetailsNotes)")
                    }
                } header: {
                    Label("Other", systemImage: "ellipsis.circle")
                }
            }
            Section {
                Button(action: {}) {
                    Label("Set As Front", systemImage: "person")
                }
                Button(action: {}) {
                    Label("Add To Front", systemImage: "person.2")
                }
            }
            Section {
                Button(action: {}) {
                    Label("Edit Member", systemImage: "slider.horizontal.3")
                }
                ShareLink(item: URL(string: "/")!, subject: Text("Exported Alter"), message: Text("Information About An Alter"))
            }
        }
        .navigationTitle("\(alterDetailsName)")
        .privacySensitive()
    }
    
    //Add A New Member To The Members Database
    private func addItem() {
        withAnimation {
            let newItem = Alters(context: viewContext)
            newItem.id = UUID()
            newItem.name = newAlterName
            newItem.age = newAlterAge
            newItem.birthday = newAlterBirthday
            newItem.desc = newAlterDescription
            newItem.dislikes = newAlterDislikes
            newItem.food = newAlterFavouriteFood
            newItem.gender = newAlterGender
            newItem.hobbies = newAlterHobbies
            newItem.likes = newAlterLikes
            newItem.notes = newAlterNotes
            newItem.pronouns = newAlterPronouns
            newItem.role = newAlterRole
            newItem.sexuality = newAlterSexuality
            newItem.avatar = newAlterAvatarImageData
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved Error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //Delete Items From The Members Database
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved Error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
