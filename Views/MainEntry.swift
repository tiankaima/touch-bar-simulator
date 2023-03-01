//
//  MainEntry.swift
//  Touch Bar Simulator
//
//  Created by Tiankai Ma on 2023/2/26.
//  Copyright © 2023 Sindre Sorhus. All rights reserved.
//

import SwiftUI
import CoreGraphics
import LaunchAtLogin
import KeyboardShortcuts
import WindowManagement

@main
struct TouchBarSimulator: App {
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
	@State var launchAtLogin: Bool = LaunchAtLogin.isEnabled
	@Environment(\.openWindow) private var openWindow
	
	@NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

	var body: some Scene {
		Window("Settings", id: "settings") {
			Form {
				Picker("Docking", selection: $windowDocking) {
					ForEach(WindowDocking.allCases, id: \.self) { dockingType in
						Text(dockingType.name)
					 		.tag(dockingType)
					}
				}
				
				if windowDocking != .floating && windowDocking != .floatingTitleless {
					Slider(value: $windowPadding, in: 0.0...120.0) {
						Text("Padding: \(String(format: "%.1f", windowPadding))")
					} minimumValueLabel: {
						Text("0.0")
					} maximumValueLabel: {
						Text("120.0")
					}
				}
				
				LabeledContent("Keyboard shortcuts") {
					KeyboardShortcuts.Recorder(for: .init("toggleTouchBar"))
				}
				
				Slider(value: $windowTransparency, in: 0.5...1.0) {
					Text("Opacity: \(String(format: "%.2f", windowTransparency))")
				} minimumValueLabel: {
					Text("0.5")
				} maximumValueLabel: {
					Text("1.0")
				}
				
				Toggle("Show on all desktops", isOn: $showOnAllDesktops)
				Toggle("Hide automatically", isOn: $dockBehavior)
				Toggle("Launch at login", isOn: $launchAtLogin)
					.onChange(of: launchAtLogin) { newValue in
						LaunchAtLogin.isEnabled = newValue
					}
				
				Button("Quit") {
					NSApplication.shared.terminate(nil)
				}
				.keyboardShortcut("q")
			}
			.padding()
		}
		.windowResizability(.contentSize)
		
		MenuBarExtra("TouchBar Simulator", systemImage: "menubar.dock.rectangle") {
			Picker("Docking", selection: $windowDocking) {
				ForEach(WindowDocking.allCases, id: \.self) { dockingType in
					Text(dockingType.name)
						.tag(dockingType)
				}
			}
			
			Toggle("Show on all desktops", isOn: $showOnAllDesktops)
			Toggle("Hide automatically", isOn: $dockBehavior)
			Toggle("Launch at login", isOn: $launchAtLogin)
				.onChange(of: launchAtLogin) { newValue in
					LaunchAtLogin.isEnabled = newValue
				}
			Button("Open settings") {
				openWindow(id: "settings")
			}
			
			Button("Quit") {
				NSApplication.shared.terminate(nil)
			}
			.keyboardShortcut("q")
		}
	}
}

struct ContentView: View {
	var body: some View {
		TouchBarWindowView()
			.frame(width: DFRGetScreenSize().width, height: DFRGetScreenSize().height)
	}
}

enum WindowDocking: String, CaseIterable {
	case floating
	case floatingTitleless
	case dockedToTop
	case dockedToBottom
	
	var name: LocalizedStringKey {
		switch self {
		case .floating:
			return "Floating"
		case .floatingTitleless:
			return "Floating (TitleLess)"
		case .dockedToTop:
			return "Docked to Top"
		case .dockedToBottom:
			return "Docked to Bottom"
		}
	}
}
