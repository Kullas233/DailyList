//
//  DailyListWidgetBundle.swift
//  DailyListWidget
//
//  Created by Dylan Kullas on 1/30/26.
//

import WidgetKit
import SwiftUI

@main
struct DailyListWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyListWidget()
        DailyListWidgetControl()
        DailyListWidgetLiveActivity()
    }
}
