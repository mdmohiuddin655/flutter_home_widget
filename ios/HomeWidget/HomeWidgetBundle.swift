//
//  HomeWidgetBundle.swift
//  HomeWidget
//
//  Created by Omie Talukdar on 7/1/25.
//

import WidgetKit
import SwiftUI

@main
struct HomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HomeWidget()
        HomeWidgetControl()
        HomeWidgetLiveActivity()
    }
}
