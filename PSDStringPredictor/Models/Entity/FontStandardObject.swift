//
//  FontStandard.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

struct FontStandardObject: Identifiable{
    var id: UUID = UUID()
    var os: String
    var style: FontStyleType
    var weight: FontWeightType 
    var fontSize: Int16
    var lineHeight: Int16
}

enum FontWeightType: String,CaseIterable {
    case Regular = "Regular"
    case Medium = "Medium"
    case Bold = "Bold"
}

enum FontStyleType: String,CaseIterable{
    case LargeTitle = "LargeTitle"
    case Title1 = "Title1"
    case Title2 = "Title2"
    case Title3 = "Title3"
    case Headline = "Headline"
    case Subheadline = "Subheadline"
    case Body = "Body"
    case Callout = "Callout"
    case Footnote = "Footnote"
    case Caption1 = "Caption1"
    case Caption2 = "Caption2"
}
