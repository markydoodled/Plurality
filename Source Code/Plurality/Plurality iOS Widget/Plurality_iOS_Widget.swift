//
//  Plurality_iOS_Widget.swift
//  Plurality iOS Widget
//
//  Created by Mark Howard on 15/07/2023.
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

struct Plurality_iOS_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .scaledToFill()
                VStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(.all)
                        .background(.thinMaterial, in: Circle())
                    Text("New Alter")
                        .bold()
                        .foregroundColor(.white)
                }
            }
        case .systemMedium:
            Text("N/A")
        case .systemLarge:
            Text("N/A")
        case .systemExtraLarge:
            Text("N/A")
        case .accessoryCorner:
            Text("N/A")
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "plus")
                    .resizable()
                    .padding(.all)
                    .scaledToFit()
            }
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading) {
                    Label("Plurality", systemImage: "person.3")
                        .bold()
                    Text("Add New Alter")
                }
                Spacer()
            }
        case .accessoryInline:
            Label("New Alter", systemImage: "plus")
        @unknown default:
            Text("N/A")
        }
    }
}

struct Plurality_iOS_Widget: Widget {
    let kind: String = "Plurality_iOS_Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Plurality_iOS_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Add New Alter")
        .description("Quick Action To Get To The Add Alter Screen.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

struct Plurality_iOS_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Plurality_iOS_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
