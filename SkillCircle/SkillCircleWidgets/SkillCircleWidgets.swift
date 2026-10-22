//
//  SkillCircleWidgets.swift
//  SkillCircleWidgets
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

// MARK: - Color Palette
extension Color {
    static let widgetNavy = Color(red: 26/255, green: 42/255, blue: 128/255)
    static let widgetBlue = Color(red: 10/255, green: 110/255, blue: 189/255)
    static let widgetBackground = Color(red: 247/255, green: 248/255, blue: 252/255)
    static let widgetTextMuted = Color(red: 90/255, green: 98/255, blue: 130/255)
}

// MARK: - 1. Tokens Widget (Small)
struct TokensWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()
                Text("TOKENS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text("12.5")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("SPARK ACTIVE")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(16)
        .background(Color.widgetNavy)
    }
}

// MARK: - 2. Next Session Widget (Small)
struct NextSessionWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.widgetBlue.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(.widgetNavy)
                        .font(.system(size: 16))
                }
                Spacer()
                Text("NEXT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.widgetTextMuted)
            }
            
            Spacer()
            
            Text("45m")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.widgetNavy)
            
            Text("STATISTICS")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.widgetBlue)
        }
        .padding(16)
        .background(Color.white)
    }
}

// MARK: - 3. Today's Schedule Widget (Medium)
struct ScheduleWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TODAY'S SCHEDULE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.widgetNavy)
                Spacer()
                Text("View All")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.widgetBlue)
            }
            
            VStack(spacing: 8) {
                scheduleRow(title: "Math Advanced", time: "3:00 PM")
                scheduleRow(title: "UI Design Principle", time: "5:00 PM")
            }
        }
        .padding(16)
        .background(Color.widgetBackground)
    }
    
    private func scheduleRow(title: String, time: String) -> some View {
        HStack {
            Circle()
                .fill(Color.widgetNavy)
                .frame(width: 6, height: 6)
            
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.widgetNavy)
            
            Spacer()
            
            Text(time)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.widgetTextMuted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

// MARK: - 4. Teaching vs Learning Chart Widget (Medium)
struct ActivityChartWidgetView: View {
    let days = ["MON", "TUE", "WED", "THU", "FRI"]
    let heights: [CGFloat] = [40, 60, 30, 75, 50]
    let colors: [Color] = [.widgetNavy, .widgetBlue, .widgetNavy, .widgetBlue, .widgetNavy]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TEACHING VS LEARNING")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.widgetNavy)
            
            Spacer()
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(0..<5) { index in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors[index])
                            .frame(height: heights[index])
                        
                        Text(days[index])
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.widgetTextMuted)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
    }
}

// MARK: - Widget Configurations
struct TokensWidget: Widget {
    let kind: String = "TokensWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            TokensWidgetView()
        }
        .configurationDisplayName("Tokens Balance")
        .description("Tracks your active Spark tokens.")
        .supportedFamilies([.systemSmall])
    }
}

struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            ScheduleWidgetView()
        }
        .configurationDisplayName("Today's Schedule")
        .description("Displays upcoming tutoring sessions for today.")
        .supportedFamilies([.systemMedium])
    }
}

struct ActivityChartWidget: Widget {
    let kind: String = "ActivityChartWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            ActivityChartWidgetView()
        }
        .configurationDisplayName("Teaching vs Learning")
        .description("Displays weekly activity breakdown.")
        .supportedFamilies([.systemMedium])
    }
}
