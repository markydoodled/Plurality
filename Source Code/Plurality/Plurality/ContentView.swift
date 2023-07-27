//
//  ContentView.swift
//  Plurality
//
//  Created by Mark Howard on 14/07/2023.
//

import SwiftUI
import CoreData
import UserNotifications
import MessageUI
import LocalAuthentication
import PhotosUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Alters.name, ascending: true)], animation: .default)
    private var items: FetchedResults<Alters>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Fronting.name, ascending: true)], animation: .default)
    private var frontHistory: FetchedResults<Fronting>
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var tabSelection = 1
    @State var showingSettings = false
    @State var showingNewAlter = false
    @State var isUnlocked = false
    @State var addNewAlterDisabled = true
    @State var searchMembersText = ""
    @State var searchHistoryText = ""
    @State var openedViewName: String?
    
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
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    var body: some View {
        if horizontalSizeClass == .regular {
            if isUnlocked == true {
                NavigationSplitView {
                    List {
                        NavigationLink(destination: members) {
                            Label("Members", systemImage: "person.3")
                        }
                        NavigationLink(destination: history) {
                            Label("History", systemImage: "clock")
                        }
                        NavigationLink(destination: more) {
                            Label("More", systemImage: "ellipsis.circle")
                        }
                    }
                    .listStyle(.sidebar)
                    .navigationTitle("Plurality")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {showingSettings = false}) {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                } detail: {
                    Image("AppsIcon")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(25)
                }
            } else {
                VStack {
                    Text("App Locked")
                        .font(.title2)
                        .padding(.bottom)
                    Button(action: {authenticate()}) {
                        Label("Unlock App", systemImage: "lock.open")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } else {
            if isUnlocked == true {
                TabView(selection: $tabSelection) {
                    NavigationStack {
                        members
                    }
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Members")
                    }
                    .tag(1)
                    NavigationStack {
                        history
                    }
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
                    .tag(2)
                    NavigationStack {
                        more
                    }
                    .tabItem {
                        Image(systemName: "ellipsis.circle")
                        Text("More")
                    }
                    .tag(3)
                }
                .onOpenURL { incomingURL in
                    print("App was opened via URL: \(incomingURL)")
                    handleIncomingURL(incomingURL)
                }
            } else {
                VStack {
                    Text("App Locked")
                        .font(.title2)
                        .padding(.bottom)
                    Button(action: {authenticate()}) {
                        Label("Unlock App", systemImage: "lock.open")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    var members: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    alterDetails
                        .onAppear() {
                            alterDetailsName = item.name ?? "None"
                            alterDetailsAge = item.age
                            alterDetailsBirthday = item.birthday ?? Date()
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
                } label: {
                    HStack {
                        /*Image("\(item.avatar)")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                            .scaledToFill()*/
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 50, height: 50)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text("\(item.name ?? "None")")
                                .bold()
                                .font(.title3)
                            Text("\(item.pronouns ?? "None")")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                .searchable(text: $searchMembersText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search For Members..."))
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Members")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarLeading) {
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
    }
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
                .searchable(text: $searchHistoryText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search For Fronts..."))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    var more: some View {
        Form {
            Section {
                NavigationLink(destination:
                    NavigationStack {
                        appNotifications
                    }
                ) {
                    Label("App Notifications", systemImage: "app.badge")
                }
            }
            Section {
                Link("NHS", destination: URL(string: "https://www.nhs.uk/mental-health/conditions/dissociative-disorders/")!)
                Link("Childline", destination: URL(string: "https://www.childline.org.uk/")!)
                Link("Clinic For Dissociative Studies", destination: URL(string: "https://www.clinicds.org.uk")!)
            } header: {
                Label("Useful Links", systemImage: "link")
            }
        }
        .navigationTitle("More")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {showingSettings = true}) {
                    Image(systemName: "gearshape")
                }
                .sheet(isPresented: $showingSettings) {
                    NavigationStack {
                        settings
                    }
                }
            }
        }
    }
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
                Button(action: {self.isShowingMailView.toggle()}) {
                    Text("Send Feedback")
                }
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result)
                }
                Button(action: {UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)}) {
                    Text("Open Settings App")
                }
            } header: {
                Label("Misc.", systemImage: "ellipsis.circle")
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {showingSettings = false}) {
                    Text("Done")
                }
            }
        }
    }
    var newAlter: some View {
        Form {
            Group {
                Section {
                    TextField("Name...", text: $newAlterName)
                    Stepper("Age - \(newAlterAge)", value: $newAlterAge, in: 1...1000)
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
        .navigationTitle("New Alter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            ToolbarItem(placement: .navigationBarTrailing) {
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
    }
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
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: "/")!, subject: Text("Exoprted Alter"), message: Text("Information About An Alter"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {}) {
                        Label("Start Front", systemImage: "play")
                    }
                    .disabled(true)
                    Button(action: {}) {
                        Label("Stop Front", systemImage: "stop")
                    }
                    .disabled(true)
                } label: {
                    Label("Set As Front", systemImage: "person.badge.plus")
                }
            }
        }
    }
    var appNotifications: some View {
        Form {
            TextField(text: $appNotificationsTitleText, prompt: Text("Enter The Notification Title...")) {
                Text("Title")
            }
            DatePicker(selection: $appNotificationsDueDateAndTime, displayedComponents: [.date, .hourAndMinute]) {
                Text("Date And Time")
            }
            Button(action: {
                let content = UNMutableNotificationContent()
                content.title = appNotificationsTitleText
                content.sound = UNNotificationSound.default
                let timeInt = appNotificationsDueDateAndTime.timeIntervalSinceNow
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInt, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }) {
                Text("Schedule Notification")
            }
        }
        .navigationTitle("App Notifications")
    }
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
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Your Data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    print("Authenticated")
                    isUnlocked = true
                } else {
                    print("Not Authenticated")
                    isUnlocked = false
                }
            }
        } else {
            print("No Biometrics Avaliable")
        }
    }
    func handleIncomingURL(_ url: URL) {
            guard url.scheme == "plurality" else {
                return
            }
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                print("Invalid URL")
                return
            }

            guard let action = components.host, action == "open-add-alter" else {
                print("Unknown URL")
                return
            }

            guard let viewName = components.queryItems?.first(where: { $0.name == "name" })?.value else {
                print("View Name Not Found")
                return
            }

            openedViewName = viewName
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["markhoward2005@gmail.com"])
        vc.setSubject("Plurality App Feedback")
        vc.setMessageBody("Rating: \nBugs: \nFeature Request: \nOther Notes: ", isHTML: false)
        return vc
    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
