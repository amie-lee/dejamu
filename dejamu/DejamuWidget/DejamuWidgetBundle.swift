//
//  DejamuWidgetBundle.swift
//  DejamuWidget
//
//  Created by Seoyoung Lee on 9/25/26.
//

import WidgetKit
import SwiftUI

@main
struct DejamuWidgetBundle: WidgetBundle {
    var body: some Widget {
        DejamuWidget()
        DejamuWidgetControl()
        DejamuWidgetLiveActivity()
    }
}
