//
//  StringModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
struct StringObject: Hashable, Codable, Identifiable {
    var id: Int
    var content: String
    var position: [CGFloat]
    var width: CGFloat
    var height: CGFloat
    var tracking: CGFloat
    var fontsize: CGFloat
    


}
