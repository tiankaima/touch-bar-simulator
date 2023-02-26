//
//  HintView.swift
//  Touch Bar Simulator
//
//  Created by Tiankai Ma on 2023/2/26.
//  Copyright © 2023 Sindre Sorhus. All rights reserved.
//

import Cocoa
import SwiftUI

struct MarkView: View {
	static var main = MarkView()
	@State var offsetInt: Int = 1 // 1...48
	let width = DFRGetScreenSize().width

	func updateOffset() {
		Task {
			try await Task.sleep(for: .seconds(2))
			offsetInt = (offsetInt + 1) % 48
			updateOffset()
		}
	}

	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 5)
				.fill(.red)
				.opacity(0.5)
				.offset(x: Double(offsetInt - 24) / 49.0 * width)
				.frame(width: width / 48, height: DFRGetScreenSize().height)
		}
		.frame(width: width, height: DFRGetScreenSize().height)
//		.border(.blue.opacity(0.1))
		.task {
			updateOffset()
		}
	}
}

final class HintView: NSView {
	override init(frame: CGRect) {
		super.init(frame: .zero)
		wantsLayer = true
		let _view = NSHostingView(rootView: MarkView.main)
		_view.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(_view)
		_view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		_view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		setFrameSize(DFRGetScreenSize())
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {}
	override func acceptsFirstMouse(for event: NSEvent?) -> Bool { false }
}
