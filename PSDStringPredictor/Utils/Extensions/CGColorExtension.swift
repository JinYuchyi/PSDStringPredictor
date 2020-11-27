//
//  CGColorExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 27/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

extension CGColor{
    func ToColor()->Color{
        return Color.init(red: Double(self.components![0]), green: Double(self.components![1]), blue: Double(self.components![2]))
    }
}
