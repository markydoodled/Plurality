//
//  NewMemberView.swift
//  Plurality
//
//  Created by Mark Howard on 26/08/2023.
//

import SwiftUI
import PhotosUI
import CoreData

#if os(macOS)
struct NewMemberView: View {
    //Core Data Database Fetch
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Alters.name, ascending: true)], animation: .default)
    private var items: FetchedResults<Alters>
    
    //UI Control Variables
    @State var addNewAlterDisabled = true
    
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
    var body: some View {
        ScrollView {
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
                                .frame(width: 150, height: 150)
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
            .padding()
        }
        .navigationTitle("New Member")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
                }) {
                    Text("Done")
                }
                .disabled(addNewAlterDisabled)
            }
        }
        .onChange(of: avatarItem) {
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let nsImage = NSImage(data: data) {
                        avatarImage = Image(nsImage: nsImage)
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
        .onChange(of: newAlterName) {
            if newAlterName == "" {
                addNewAlterDisabled = true
            } else {
                addNewAlterDisabled = false
            }
        }
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
}

struct NewMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NewMemberView()
    }
}
#endif
