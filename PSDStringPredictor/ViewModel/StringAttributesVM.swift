//
//  StringAttributes.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class StringAttributesVM : ObservableObject {
    @Published var content: String = ""
    @Published var colorMode: String = "" //1 light
    @Published var color: Color = Color.white
    @Published var elementImageList: [CIImage] = []
    @Published var charList: [Character] = []
    
    func FetchInfo() {
        let selObj = DataRepository.shared.GetSelectedStringObject()
        content = selObj?.content ?? ""
        let cmode = selObj?.colorMode
        switch cmode {
            case 1:
                colorMode = "Light Mode"
            case 2:
                colorMode = "Dark Mode"
            default:
                colorMode = " "
        }
        elementImageList = selObj?.charImageList ?? []
        charList = selObj?.charArray ?? []
    }
    
    
}
