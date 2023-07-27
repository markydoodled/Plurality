//
//  Plurality_watchOS_Widget.swift
//  Plurality watchOS Widget
//
//  Created by Mark Howard on 16/07/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Plurality_watchOS_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            Text("N/A")
        case .systemMedium:
            Text("N/A")
        case .systemLarge:
            Text("N/A")
        case .systemExtraLarge:
            Text("N/A")
        case .accessoryCorner:
            VStack {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.teal)
                    .widgetAccentable()
                    .widgetLabel {
                        Text("New Alter")
                    }
            }
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "plus")
                    .resizable()
                    .padding(.all)
                    .scaledToFit()
                    .foregroundColor(.teal)
                    .widgetAccentable()
                    .widgetLabel {
                        Text("Add New Alter")
                    }
            }
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading) {
                    Label("Plurality", systemImage: "person.3")
                        .bold()
                        .foregroundColor(.teal)
                        .widgetAccentable()
                    Text("Add New Alter")
                }
                Spacer()
            }
        case .accessoryInline:
            Label("New Alter", systemImage: "plus")
                .foregroundColor(.teal)
        @unknown default:
            Text("N/A")
        }
    }
}

@main
struct Plurality_watchOS_Widget: Widget {
    let kind: String = "Plurality_watchOS_Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Plurality_watchOS_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Add New Alter")
        .description("Quick Action To Get To The Add Alter Screen.")
        .supportedFamilies([.accessoryCorner, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct Plurality_watchOS_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Plurality_watchOS_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
