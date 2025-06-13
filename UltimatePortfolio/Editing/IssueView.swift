//
//  IssueView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/18/25.
//

import SwiftUI

struct IssueView: View {
    @ObservedObject var issue: Issue
    @EnvironmentObject var dataController: DataController
    @State private var showingNotificationsError = false
    @Environment(\.openURL) var openURL
    
    #if os(iOS)
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        
        openURL(settingsURL)
    }
    #endif
    
    func updateReminder() {
        dataController.removeReminders(for: issue)
        
        Task { @MainActor in
            if issue.reminderEnabled {
                let success = await dataController.addReminder(for: issue)
                
                if success == false {
                    issue.reminderEnabled = false
                    showingNotificationsError = true
                }
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                        .labelsHidden()
                    
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                    
                    Text("**Status:** \(issue.issueStatus)").foregroundStyle(.secondary)
                }
                
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                #if !os(watchOS)
                Menu {
                    TagsMenuView(issue: issue)
                } label: {
                    Text(issue.issueTagsList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: issue.issueTagsList)
                }
                #endif
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical
                    )
                    .labelsHidden()
                }
            }
            
            Section("Reminders") {
                Toggle("Show reminders", isOn: $issue.reminderEnabled.animation())
                
                if issue.reminderEnabled {
                    DatePicker(
                        "Reminder time",
                        selection: $issue.issueReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                }
            }
        }
        .disabled(issue.isDeleted)
        .onReceive(issue.objectWillChange) { _ in
            dataController.save()
        }
        .onSubmit(dataController.save)
        .toolbar {
            IssueViewToolbar(issue: issue)
        }
        .alert("Oops!", isPresented: $showingNotificationsError) {
            #if os(macOS)
            SettingsLink {
                Text("Check Settings")
            }
            #elseif os(iOS)
            Button("Check Settings", action: showAppSettings)
            #endif
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There was a problem setting your notifications. Please check you have notifications enabled.")
        }
        .onChange(of: issue.reminderEnabled) { _ in
            updateReminder()
        }
        .onChange(of: issue.reminderTime) { _ in
            updateReminder()
        }
        .formStyle(.grouped)
    }
}

#Preview {
    IssueView(issue: .example)
}
