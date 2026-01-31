//
//  Notifications.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/28/26.
//

import UIKit

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

extension UIImage {
    func createLocalURL() -> URL? {
        guard let imageName = self.accessibilityIdentifier else {
            return nil
        }

        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let url = cacheDirectory.appendingPathComponent("\(imageName).png")

        guard fileManager.fileExists(atPath: url.path) else {
            guard let data = self.pngData() else { return nil }
            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }

        return url
    }
}

func createImageAttachment(image: UIImage?) -> [UNNotificationAttachment] {
    var notificationAttachment: [UNNotificationAttachment] = []
    if let image = image,
        let imageUrl = image.createLocalURL(),
        let attachment = try? UNNotificationAttachment(identifier: "image", url: imageUrl, options: nil) {

        notificationAttachment.append(attachment)
    }

    return notificationAttachment
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
