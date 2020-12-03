//
//  CharRectData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

struct CharFrame: Identifiable, Hashable{
    var id: UUID = UUID()
    var rect: CGRect
    var char: String
    var predictedSize: Int16
    
}


