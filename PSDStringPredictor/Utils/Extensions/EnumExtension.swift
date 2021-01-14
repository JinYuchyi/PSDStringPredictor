//
//  EnumExtension.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 14/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

extension StringAlignment {
    func Next() -> StringAlignment{
        let allCases = Self.allCases
        return allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
    }
}
