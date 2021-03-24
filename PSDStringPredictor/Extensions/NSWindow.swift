//
//  NSWindow.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import Cocoa



class ClosableWindow: NSWindow {
    override func close() {
        self.orderOut(NSApp)
    }
}
