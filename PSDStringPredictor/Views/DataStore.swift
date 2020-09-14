//
//  TargetImageStore.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 14/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import Vision

class DataStore: ObservableObject{
    @Published var targetImage: CIImage  = CIImage.init()
    @Published var targetImageName: String = "default_image"
    @Published var targetImageSize: [Int64] = []
    @Published var logListData = [
        LogObject(id: 1, content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
        LogObject(id: 2, content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
    ]
    
    //Image Process
    @Published var gammaValue: CGFloat = 0.75
//    
//    static let shared = DataStore()
//    private init(){}
    
}


