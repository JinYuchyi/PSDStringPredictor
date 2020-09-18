//
//  LogObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 9/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

struct LogObject: Identifiable {
    var id: UUID = UUID()
    var content: String
    var time: String
    var category: Category
    
    enum Category: String, CaseIterable, Codable, Hashable {
        case normal = "Normal"
        case warning = "Warning"
        case error = "Error"
    }
}
