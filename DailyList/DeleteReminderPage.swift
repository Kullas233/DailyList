//
//  DeleteReminderPage.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/29/26.
//

import SwiftUI
import Foundation

struct DeleteReminderPage: View {
    @State private var notificationList: [UNNotificationRequest] = [] // Non-editable title
    @State private var showPopup: Bool = false
    @State private var popupText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(alignment: .center) {
                    Text("Delete")
                        .font(.custom("Helvetica-Bold", size: 35)) // Apply font directly
                        .padding()
                    
                    if(showPopup)
                    {
                        VStack {
                            Text(popupText)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Dismiss") {
                                showPopup = false
                            }
                            .padding()
                        }
                        .border(Color.black, width: 2)
                        .presentationCompactAdaptation(.none) // Forces popover style in compact size classes
                    }
                    List {
                        ForEach($notificationList, id: \.self) { $request in
                            VStack {
                                if(request.content.title != "") {
                                    Text(request.content.title)
                                } else if (request.content.body != "") {
                                    Text(request.content.body)
                                } else {
                                    Text(request.identifier)
                                }
                                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                                    let _ = print("Trigger type: Calendar")
                                    Text("Next trigger date: \(trigger.nextTriggerDate()?.description ?? "N/A")")
                                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                                    let _ = print("Trigger type: Time Interval")
                                    Text("Time interval: \(trigger.timeInterval) seconds")
                                } else if request.trigger is UNLocationNotificationTrigger {
                                    Text("Trigger type: Location")
                                } else {
                                    Text("Trigger type: Unknown/None")
                                }
                            }
                        }
                        .onDelete(perform: deleteItems) // Swipe to delete
                    }
                    .scrollContentBackground(.hidden) // Hides the default background
                    .background(Color(red: 0.87, green: 0.87, blue: 0.87, opacity: 1.0))
                    .padding(EdgeInsets(top: -20, leading: 0, bottom: -20, trailing: 0))
                }
                .task {
                    fetchPendingNotificationRequests { requests in
                        notificationList = requests
                    }
                }
            }
        }
    }
    
    // Function to delete items
    private func deleteItems(at offsets: IndexSet) {
        var deleteIndex = 0
        for index in offsets{
            deleteIndex = index
        }
        let deleteNotification = notificationList.remove(at: deleteIndex)
        deletePendingNotification(identifier: deleteNotification.identifier)
        print("DELETEINDEX: ", deleteIndex)
    }
}

// Preview for both platforms
struct DeleteReminderPage_Previews: PreviewProvider {
    static var previews: some View {
        DeleteReminderPage()
            .previewDevice("iPhone 16 Pro")
        DeleteReminderPage()
            .frame(width: 500, height: 400) // macOS preview
    }
}
