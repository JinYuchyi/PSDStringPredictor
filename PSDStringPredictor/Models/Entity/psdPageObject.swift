//
//  psdPageObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

struct psdPage: Identifiable {
    var id: UUID = UUID()
    var name: String = "PSD File Name"
    var image: CIImage = CIImage.init()
    var isCommitted: Bool = false
    
//     func ToggleCommit(){
//        self.isCommitted =  !self.isCommitted
//    }
}
