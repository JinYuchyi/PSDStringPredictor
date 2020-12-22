//
//  KeyboardManager.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 22/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Cocoa

class MediaApplication: NSApplication {
    
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if (state) {
            switch(key) {
            case NX_KEYTYPE_PLAY:
                print("Play")
                break
            case NX_KEYTYPE_FAST:
                print("Next")
                break
            case NX_KEYTYPE_REWIND:
                print("Prev")
                break
            default:
                break
            }
        }
    }
    
    override func sendEvent(_ event: NSEvent) {
        if (event.type == .systemDefined && event.subtype.rawValue == 8) {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
            let keyRepeat = (keyFlags & 0x1)
            mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: ((keyRepeat) != 0))
        }

        super.sendEvent(event)
    }


}
