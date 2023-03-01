import SwiftUI
import Sparkle
import Defaults
import LaunchAtLogin
import KeyboardShortcuts

final class AppDelegate: NSObject, NSApplicationDelegate {
	var window: NSWindow!

	// I'm not that sure what this does, but as the original author keeps it... here it is
	private lazy var updateController = SPUStandardUpdaterController(startingUpdater: true,
																	 updaterDelegate: nil,
																	 userDriverDelegate: nil)

	func applicationWillFinishLaunching(_ notification: Notification) {
		UserDefaults.standard.register(defaults: [
			"NSApplicationCrashOnExceptions": true
		])
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		if let window = NSApplication.shared.windows.first {
			// close the setting window if it's poped up
			window.close()
		}
		
		
		let contentView = ContentView()
		window = NSWindow(contentRect: NSRect(origin: .init(x: 100, y: 0),
											  size: DFRGetScreenSize()),
						  styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
						  backing: .buffered,
						  defer: false)
		window.styleMask.remove(.titled)
		window.level = .screenSaver
		window.isReleasedWhenClosed = false
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)

		checkAccessibilityPermission()
		_ = updateController
		_ = window

		KeyboardShortcuts.onKeyUp(for: .init("toggleTouchBar")) { [self] in
			// switch between normal and screenSaver would do the trick
			if window.level == .normal {
				window.level = .screenSaver
			} else {
				window.level = .normal
			}
		}
	}

	func checkAccessibilityPermission() {
		// We intentionally don't use the system prompt as our dialog explains it better.
		let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: false] as CFDictionary
		if AXIsProcessTrustedWithOptions(options) {
			return
		}

		NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)

		let alert = NSAlert()
		alert.messageText = "Touch Bar Simulator needs accessibility access."
		alert.informativeText = "In the System Preferences window that just opened, find “Touch Bar Simulator” in the list and check its checkbox. Then click the “Continue” button here."
		alert.addButton(withTitle: "Continue")
		alert.addButton(withTitle: "Quit")

		guard alert.runModal() == .alertFirstButtonReturn else {
			NSApplication.shared.terminate(nil)
			return
		}

		NSApplication.shared.terminate(nil)
		NSApplication.shared.run()
	}
}
