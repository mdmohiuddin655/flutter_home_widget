//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Omie Talukdar on 7/1/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            data: NutritionData(
                calories: 3205,
                caloriesInPercentage: 0.25,
                carbsInGram: 340,
                carbsInPercentage: 0.87,
                fatInGram: 145,
                fatInPercentage: 0.44,
                proteinInGram: 405,
                proteinInPercentage: 0.7
            )
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: configuration,
            data: NutritionData(
                calories: 3205,
                caloriesInPercentage: 0.25,
                carbsInGram: 340,
                carbsInPercentage: 0.87,
                fatInGram: 145,
                fatInPercentage: 0.44,
                proteinInGram: 405,
                proteinInPercentage: 0.7
            )
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                configuration: configuration,
                data: NutritionData(
                    calories: 3205,
                    caloriesInPercentage: 0.25,
                    carbsInGram: 340,
                    carbsInPercentage: 0.87,
                    fatInGram: 145,
                    fatInPercentage: 0.44,
                    proteinInGram: 405,
                    proteinInPercentage: 0.7
                )
            )
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct NutritionData {
    var calories: Double = 0
    var caloriesInPercentage: Double = 0
    var carbsInGram: Double = 0
    var carbsInPercentage: Double = 0
    var fatInGram: Double = 0
    var fatInPercentage: Double = 0
    var proteinInGram: Double = 0
    var proteinInPercentage: Double = 0
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var data: NutritionData = NutritionData()
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

struct HomeWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct HomeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Nutrition(data: entry.data)
    }
}

struct Nutrition: View {
    var data: NutritionData = NutritionData()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🔥 Calories left")
                    .font(.caption)
                    .foregroundColor(.gray)
                    
                    Text("\(Int(data.calories))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    ProgressBar(
                        value: data.caloriesInPercentage,
                        color: .blue
                    )
                    .frame(height: 10)
                    .padding(.trailing, 12)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    NutrientMeter(title: "🍗 Protein left", value: "\(Int(data.proteinInGram))g", percentage: data.proteinInPercentage, color: .orange)
                    NutrientMeter(title: "🍞 Carbs left", value: "\(Int(data.carbsInGram))g", percentage: data.carbsInPercentage, color: .yellow)
                    NutrientMeter(title: "🧀 Fat left", value: "\(Int(data.fatInGram))g", percentage: data.fatInPercentage, color: .red)
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.top, 24)
            .padding(.bottom, 12)
            Divider()
                .frame(height: 0)
            HStack {
                FooterButton(iconName: "magnifyingglass", label: "Describe")
                Divider()
                FooterButton(iconName: "barcode.viewfinder", label: "Scan Food")
                Divider()
                FooterButton(iconName: "doc.text", label: "Label Scan")
            }
            .padding(.leading, 12)
            .padding(.trailing, 12)
            .frame(height: 40)
        }
        .background(Color.white)
        .cornerRadius(24)
        .frame(width: .infinity, height: .infinity)
    }
}

struct ProgressBar: View {
    var value: Double
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                Rectangle()
                    .fill(color)
                    .frame(width: CGFloat(value) * geometry.size.width)
            }
            .cornerRadius(25)
        }
    }
}

struct NutrientMeter: View {
    var title: String
    var value: String
    var percentage: Double
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Spacer()
                Text(value)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
            }
            ProgressBar(value: percentage, color: color)
                .frame(height: 4)
        }
    }
}

struct FooterButton: View {
    var iconName: String
    var label: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: 10))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Page: View {
    var body: some View {
        VStack {
            Spacer()
            Nutrition()
            Spacer()
        }.background(Color.black)
    }
}

#Preview(as: .systemSmall) {
    HomeWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: .smiley,
        data: NutritionData(
            calories: 9205,
            caloriesInPercentage: 0.25,
            carbsInGram: 340,
            carbsInPercentage: 0.87,
            fatInGram: 145,
            fatInPercentage: 0.44,
            proteinInGram: 405,
            proteinInPercentage: 0.7
        )
    )
    SimpleEntry(
        date: .now,
        configuration: .starEyes,
        data: NutritionData(
            calories: 6205,
            caloriesInPercentage: 0.25,
            carbsInGram: 340,
            carbsInPercentage: 0.87,
            fatInGram: 145,
            fatInPercentage: 0.44,
            proteinInGram: 405,
            proteinInPercentage: 0.7
        )
    )
}
