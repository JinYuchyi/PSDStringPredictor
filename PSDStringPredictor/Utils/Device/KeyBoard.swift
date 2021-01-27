//
//  KeyBoard.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 19/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

//var pressedKeyCode = UInt16.init()
    
//Using it by calling ".background(KeyEventHandling())" in SwiftUI view.
struct KeyEventHandling: NSViewRepresentable {

    class KeyView: NSView, ObservableObject {
        @Published var pressedKeyCode = UInt16.init()

        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            super.keyDown(with: event)
            print(">> key \(event.charactersIgnoringModifiers ?? "")")
            pressedKeyCode = event.keyCode
        }
        
        
    }

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

//class KeyViewModel: NSView, ObservableObject {
//    @Published var pressedKeyCode: UInt16 = UInt16.init()
//    override var acceptsFirstResponder: Bool { true }
//    override func keyDown(with event: NSEvent) {
//        super.keyDown(with: event)
//        print(">> key \(event.charactersIgnoringModifiers ?? "")")
//        pressedKeyCode = event.keyCode
//
//    }
//}

