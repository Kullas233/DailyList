//
//  MainPage.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/18/26.
//

import SwiftUI
import Foundation
import UserNotifications
import UIKit

struct ListView: View {
    @State private var red: Bool = false
    @State private var yellow: Bool = false
    @State private var green: Bool = false
    @State private var selectedHour: Int = 12
    @State private var selectedMinute: Int = 30
    @State private var reminderTitle: String = ""
    @State private var reminderBody: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Daily Lists")
                    .font(.custom("Helvetica-Bold", size: 35)) // Apply font directly
            }
            .task {
                await requestPushPermission()
                listRepeatingNotifications()
            }
            
            GeometryReader { geometry in
                VStack{
                    VStack {
                        HStack {
                            Text("Hour")
                                .font(.headline)
                            
                            Divider()
                                .padding(EdgeInsets(top: 0, leading: geometry.size.width/6, bottom: 0, trailing: geometry.size.width/6))
                                .frame(maxHeight: geometry.size.height/16)
                            
                            Text("Minute")
                                .font(.headline)
                        }
                        
                        HStack {
                                Picker("Select a value", selection: $selectedHour) {
                                    ForEach(0...23, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxHeight: geometry.size.height/5)
                            
                                
                                
                                Picker("Select a value", selection: $selectedMinute) {
                                    ForEach(0...59, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxHeight: geometry.size.height/5)
                            
                        }
                        
                        Button("Schedule Notification") {
                            print("HERE")
                            let content = UNMutableNotificationContent()
                            content.title = reminderTitle
                            content.subtitle = reminderBody
                            content.sound = UNNotificationSound.default
                            
                            var dateComponents = DateComponents()
                            dateComponents.hour = selectedHour
                            dateComponents.minute = selectedMinute
                            
                            // repeats: true makes it a daily notification
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                            
                            var image = UIImage()
                            if red {
                                image = UIImage(named: "red")!
                            }
                            else if yellow {
                                image = UIImage(named: "yellow")!
                            }
                            else if green {
                                image = UIImage(named: "green")!
                            }
                            else
                            {
                                print("NO IMAGE")
                            }
                            content.attachments = createImageAttachment(image: image)
                            
                            let notification = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(notification, withCompletionHandler: { (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            })
                            
                            reminderTitle = ""
                            reminderBody = ""
                            
//                            USING URL
//                            if let url = URL(string: "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/person.png") {
//                                let pathExtension = url.pathExtension
//                                let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
//                                    if let result = result {
//
//                                        let identifier = ProcessInfo.processInfo.globallyUniqueString
//                                        let target = FileManager.default.temporaryDirectory.appendingPathComponent(identifier).appendingPathExtension(pathExtension)
//
//                                        do {
//                                            try FileManager.default.moveItem(at: result, to: target)
//
//                                            let attachment = try UNNotificationAttachment(identifier: identifier, url: target, options: nil)
//                                            maybe.append(attachment)
//                                            content.attachments = maybe
//                                            print("2")
//                                        }
//                                        catch {
//                                            print(error.localizedDescription)
//                                        }
//                                    }
//                                }
//                                task.resume()
//                            }
                        }
                    }
                    VStack {
                        TextField("Enter Title", text: $reminderTitle)
                            .textFieldStyle(.roundedBorder)
                            .padding(EdgeInsets(top: 0, leading: geometry.size.width/16, bottom: 0, trailing: geometry.size.width/16))
                        TextField("Enter Body", text: $reminderBody)
                            .textFieldStyle(.roundedBorder)
                            .padding(EdgeInsets(top: 0, leading: geometry.size.width/16, bottom: 0, trailing: geometry.size.width/16))
                    }
                    VStack {
                        let onRed = Binding<Bool>(get: { self.red }, set: { self.red = $0; self.yellow = false; self.green = false })
                        let onYellow = Binding<Bool>(get: { self.yellow }, set: { self.red = false; self.yellow = $0; self.green = false })
                        let onGreen = Binding<Bool>(get: { self.green }, set: { self.red = false; self.yellow = false; self.green = $0 })
                        Toggle("Enable Feature Red", isOn: onRed)
                            .padding()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -geometry.size.width/32, trailing: 0))
                        Toggle("Enable Feature Yellow", isOn: onYellow)
                            .padding()
                            .padding(EdgeInsets(top: -geometry.size.width/32, leading: 0, bottom: -geometry.size.width/32, trailing: 0))
                        Toggle("Enable Feature Green", isOn: onGreen)
                            .padding()
                            .padding(EdgeInsets(top: -geometry.size.width/32, leading: 0, bottom: 0, trailing: 0))
                    }
                    Spacer()
                    Button("Clear Notifications") {
                        clearAllPendingLocalNotifications()
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300) // Default size for macOS
    }
}

// Preview for both platforms
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
            .previewDevice("iPhone 16 Pro")
        MainPage()
            .frame(width: 500, height: 400) // macOS preview
    }
}
