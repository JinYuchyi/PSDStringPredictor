//
//  StringLabel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 24/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

struct StringLabelObject {
    var id : UUID = UUID()
    var position: [CGFloat]
    var height: CGFloat
    var width: CGFloat
    var fontsize: CGFloat
    var tracking: CGFloat
    var content: String
    var color: Color
}
