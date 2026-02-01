//
//  DailyListWidgetLiveActivity.swift
//  DailyListWidget
//
//  Created by Dylan Kullas on 1/30/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DailyListWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DailyListWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyListWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DailyListWidgetAttributes {
    fileprivate static var preview: DailyListWidgetAttributes {
        DailyListWidgetAttributes(name: "World")
    }
}

extension DailyListWidgetAttributes.ContentState {
    fileprivate static var smiley: DailyListWidgetAttributes.ContentState {
        DailyListWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DailyListWidgetAttributes.ContentState {
         DailyListWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DailyListWidgetAttributes.preview) {
   DailyListWidgetLiveActivity()
} contentStates: {
    DailyListWidgetAttributes.ContentState.smiley
    DailyListWidgetAttributes.ContentState.starEyes
}
