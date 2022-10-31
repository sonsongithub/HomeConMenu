//
//  SUColorPanel.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/31.
//

import Foundation
import SwiftUI
import ColorWheelPanelView


struct SUColorPanel: NSViewRepresentable {
    typealias NSViewType = ColorWheelPanelView
    
//    @Binding private var brightness: Double
//    @Binding private var saturation: Double
//    @Binding private var hue: Double
//    @Binding private var isContinuous: Bool

    var brightness: Double = 0
    var saturation: Double = 0
    var hue: Double = 0
    var isContinuous: Bool = false
    
//    init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>, continuous: Binding<Bool>) {
//        self._brightness = brightness
//        self._hue = hue
//        self._saturation = saturation
//        self._isContinuous = continuous
//    }
    
    init() {
        
    }

    func makeNSView(context: Context) -> ColorWheelPanelView {
        let view = ColorWheelPanelView()
        view.delegate = context.coordinator
        return view
    }
    
    func updateNSView(_ nsView: ColorWheelPanelView, context: Context) {
        nsView.brightness = brightness / 100.0
        nsView.saturation = saturation / 100.0
        nsView.hue = hue / 100.0
        nsView.isContinuous = isContinuous
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ColorWheelPanelViewDelegate {
        var parent: SUColorPanel

        init(_ parent: SUColorPanel) {
            self.parent = parent
        }

        func didChangeColor(hue: Double, saturation: Double, brightness: Double) {
            self.parent.brightness = brightness * 100
            self.parent.saturation = saturation * 100
            self.parent.hue = hue * 100
        }
    }

}
