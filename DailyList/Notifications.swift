//
//  Notifications.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/28/26.
//

import UIKit

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
