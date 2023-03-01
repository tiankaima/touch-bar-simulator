//
//  TouchBarWindowView.swift
//  Touch Bar Simulator
//
//  Created by Tiankai Ma on 2023/3/1.
//  Copyright © 2023 Sindre Sorhus. All rights reserved.
//

import SwiftUI

struct TouchBarWindowView: View {
	@AppStorage("windowTransparency") var windowTransparency: Double = 0.75
	@AppStorage("windowDocking") var windowDocking: WindowDocking = .floating
	@AppStorage("windowPading") var windowPadding: Double = 0.0
	@AppStorage("showOnAllDesktops") var showOnAllDesktops: Bool = false
	@AppStorage("lastFloatingPosition") var _lastFloatingPosition: [Double] = []
	var lastFloatingPosition: CGPoint {
		get {
			return CGPoint(x: _lastFloatingPosition[0], y: _lastFloatingPosition[1])
		}
		set {
			_lastFloatingPosition = [newValue.x, newValue.y]
		}
	}
	@AppStorage("dockBehavior") var dockBehavior: Bool = false
	@AppStorage("lastWindowDockingWithDockBehavior") var lastWindowDockingWithDockBehavior: WindowDocking = .dockedToTop
	@Environment(\.openWindow) private var openWindow
	
	var body: some View {
		TouchBarViewRepresentable()
			.opacity(windowTransparency)
	}
}
