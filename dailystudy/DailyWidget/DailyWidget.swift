//
//  DailyWidget.swift
//  DailyWidget
//
//  Created by jingjun on 2021/12/26.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct DailyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image("icon_img")
                .resizable()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(20)

            VStack(alignment: .leading, spacing: 10) {
                Text("国画 - 山水画技法")
                    .font(.body)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 26, trailing: 6))
                HStack(alignment: .center, spacing: 10) {
                    Text("12.27 11:19")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    
                    // 图片 和 文字 button
                        Button(action: {
                            print("")
                        }) {
                            // 默认是横向布局(HStack)
                            // 图片和文字都默认渲染成 foregroundColor, foregroundColor 默认为蓝色
                            // 图片会撑开 button
                            HStack{
                                Image(systemName: "play.rectangle")
                                Text("看直播")
                            }
                        }
                        .font(.footnote)
                        .padding(6)
                        .background(Color.orange)
                        .foregroundColor(Color.white)
                        .cornerRadius(14)
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 6, trailing: 6))
            }
            
        }
        
    }
}

@main
struct DailyWidget: Widget {
    let kind: String = "DailyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DailyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct DailyWidget_Previews: PreviewProvider {
    static var previews: some View {
        DailyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
