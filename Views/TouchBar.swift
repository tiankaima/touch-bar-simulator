import Cocoa
import SwiftUI

final class TouchBarView: NSView {
	static var shared = TouchBarView()
	private var stream: CGDisplayStream?

	override init(frame: CGRect) {
		super.init(frame: .zero)
		wantsLayer = true
		start()
		setFrameSize(DFRGetScreenSize())
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		stop()
	}

	override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

	func start() {
		for value in 0..<7 {
			DFRSetStatus(Int32(value))
		}

		stream = SLSDFRDisplayStreamCreate(0, .main) { [weak self] status, _, frameSurface, _ in
			guard
				let self = self,
				status == .frameComplete,
				let layer = self.layer
			else {
				return
			}

			layer.contents = frameSurface
		}.takeUnretainedValue()

		stream?.start()
	}

	func stop() {
		guard let stream = stream else {
			return
		}

		stream.stop()
		self.stream = nil
	}

	private func mouseEvent(_ event: NSEvent) {
		let location = convert(event.locationInWindow, from: nil)
		DFRFoundationPostEventWithMouseActivity(event.type, location)
	}

	override func mouseDown(with event: NSEvent) {
		mouseEvent(event)
	}

	override func mouseUp(with event: NSEvent) {
		mouseEvent(event)
	}

	override func mouseDragged(with event: NSEvent) {
		mouseEvent(event)
	}
}

struct TouchBarViewRepresentable: NSViewRepresentable {
	func makeNSView(context: Context) -> TouchBarView {
		TouchBarView.shared
	}
	
	func updateNSView(_ nsView: TouchBarView, context: Context) {
	}
	
	typealias NSViewType = TouchBarView
}
