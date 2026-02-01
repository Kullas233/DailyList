//
//  DailyListWidget.swift
//  DailyListWidget
//
//  Created by Dylan Kullas on 1/30/26.
//

import WidgetKit
import SwiftUI
import UIKit
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct DailyListWidget: Widget {
    let kind: String = "DailyListWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyListWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge, //IPAD only
            
            // Added new families
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

struct DailyListWidgetEntryView: View {
    @State var entry: Provider.Entry
    
    // Access to the current widget family
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        VStack {
            switch widgetFamily {
                case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
                    DailyListView(entry: entry)


                case .accessoryCircular:
                    DailyListCircularView(entry: entry)
                case .accessoryRectangular:
                    DailyListRectangularView(entry: entry)
                case .accessoryInline:
                    DailyListInlineView(entry: entry)
                @unknown default:
                    DailyListView(entry: entry)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct DailyListView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
            VStack {
                HStack {
                    Image("red")
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Image("yellow")
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                    //                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Image("green")
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                HStack {
                    Button(intent: Delete()) {
                        Text("Delete")
                    }
                    .padding()
                    Button(intent: Next()) {
                        Text("Next")
                    }
                    .padding()
                }
            }
        }
    }
    
    struct Next: AppIntent {
        
        static var title: LocalizedStringResource = "Next"
//        static var description = IntentDescription("All heroes get instant 100% health.")
        
        func perform() async throws -> some IntentResult {
            print("Next")
            return .result()
        }
    }
    
    struct Delete: AppIntent {
        
        static var title: LocalizedStringResource = "Delete"
//        static var description = IntentDescription("All heroes get instant 100% health.")
        
        func perform() async throws -> some IntentResult {
            print("Delete")
            return .result()
        }
    }
}

struct DailyListCircularView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack{
            Text("hi")
//            Gauge(value: Double(entry.count) * 0.1) {
//                Image(systemName: "drop")
//            }
//            .gaugeStyle(.accessoryCircularCapacity)
        }
    }
}

struct DailyListRectangularView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack{
            Image("red")
                .resizable() // Makes the image resizable
                .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Image("yellow")
                .resizable() // Makes the image resizable
                .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Image("green")
                .resizable() // Makes the image resizable
                .aspectRatio(contentMode: .fit) // Maintains aspect ratio
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}

struct DailyListInlineView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Number of cups: \\(entry.count)")
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    DailyListWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
