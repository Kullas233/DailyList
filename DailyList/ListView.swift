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
//import UIImage


extension UNNotificationAttachment {

    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let imageData = UIImage.pngData(image)
            try imageData()?.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}

struct ListView: View {
    @State private var categories: [String] = ["All"] // List of items
    @State private var red: Bool = false
    @State private var yellow: Bool = false
    @State private var green: Bool = false
    @State private var selectedHour: Int = 12
    @State private var selectedMinute: Int = 30
    
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
                            content.title = "Feed the dog"
                            content.subtitle = "She looks hungry"
                            content.sound = UNNotificationSound.default
                            
                            // show this notification five seconds from now
                            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                            
                            var dateComponents = DateComponents()
                            dateComponents.hour = selectedHour
                            dateComponents.minute = selectedMinute
                            // repeats: true makes it a daily notification
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                            
                            var maybe: [UNNotificationAttachment] = []
                            if let url = URL(string: "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/pork_chop_25_25.png") {
                                
                                let pathExtension = url.pathExtension
                                
                                let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
                                    if let result = result {
                                        
                                        let identifier = ProcessInfo.processInfo.globallyUniqueString
                                        let target = FileManager.default.temporaryDirectory.appendingPathComponent(identifier).appendingPathExtension(pathExtension)
                                        
                                        do {
                                            try FileManager.default.moveItem(at: result, to: target)
                                            
                                            let attachment = try UNNotificationAttachment(identifier: identifier, url: target, options: nil)
                                            content.attachments.append(attachment)
                                            maybe.append(attachment)
                                            print("1")
                                            print(maybe)
                                            print(content.attachments.count)
                                            print(content.attachments)
                                            
                                            let notification = UNNotificationRequest(identifier: Date().description, content: content, trigger: trigger)
                                            UNUserNotificationCenter.current().add(notification, withCompletionHandler: { (error) in
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                                task.resume()
                            }
                            if let url = URL(string: "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/person.png") {
                                
                                let pathExtension = url.pathExtension
                                
                                let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
                                    if let result = result {
                                        
                                        let identifier = ProcessInfo.processInfo.globallyUniqueString
                                        let target = FileManager.default.temporaryDirectory.appendingPathComponent(identifier).appendingPathExtension(pathExtension)
                                        
                                        do {
                                            try FileManager.default.moveItem(at: result, to: target)
                                            
                                            let attachment = try UNNotificationAttachment(identifier: identifier, url: target, options: nil)
                                            maybe.append(attachment)
                                            content.attachments = maybe
                                            print("2")
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                                task.resume()
                            }
                            print("3")
                            
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
                            
                            content.title = "Feed the dog"
                            content.subtitle = "She looks hungry"
                            content.sound = UNNotificationSound.default
                        }
                    }
                    VStack {
                        let onRed = Binding<Bool>(get: { self.red }, set: { self.red = $0; self.yellow = false; self.green = false })
                        let onYellow = Binding<Bool>(get: { self.yellow }, set: { self.red = false; self.yellow = $0; self.green = false })
                        let onGreen = Binding<Bool>(get: { self.green }, set: { self.red = false; self.yellow = false; self.green = $0 })
                        Toggle("Enable Feature Red", isOn: onRed)
                            .padding()
                        Toggle("Enable Feature Yellow", isOn: onYellow)
                            .padding()
                        Toggle("Enable Feature Green", isOn: onGreen)
                            .padding()
                        Button("Clear Notifications") {
                            clearAllPendingLocalNotifications()
                        }
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300) // Default size for macOS
    }
    
    func clearAllPendingLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending local notifications removed.")
    }
    
    func listRepeatingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("--- Repeating Notifications ---")
            for request in requests {
                if let trigger = request.trigger, trigger.repeats {
                    print("Identifier: \(request.identifier)")
                    
                    if let calendarTrigger = trigger as? UNCalendarNotificationTrigger {
                        let dateComponents = calendarTrigger.dateComponents
                        print("  Type: Calendar (Repeats on: \(dateComponents))")
                    } else if let timeIntervalTrigger = trigger as? UNTimeIntervalNotificationTrigger {
                        print("  Type: Time Interval (Repeats every: \(timeIntervalTrigger.timeInterval) seconds)")
                    } else {
                        print("  Type: Repeating but not Calendar or TimeInterval (e.g., location)")
                    }
                }
            }
            print("-----------------------------")
        }
    }
    
    func requestPushPermission() async {
        // Request Permission for Push Notifications
        Task {
            do {
                let success = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])

                if success {
                    print("All set!")
                } else {
                    print("User denied permissions")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
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
