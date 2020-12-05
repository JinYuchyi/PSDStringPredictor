//
//  CharImageThumbnailObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import SwiftUI

struct CharImageThumbnailObject {
    var image: CIImage = CIImage.init()
    var char: String
    var weight: String
    var size: Int
    var id: UUID = UUID()
}
