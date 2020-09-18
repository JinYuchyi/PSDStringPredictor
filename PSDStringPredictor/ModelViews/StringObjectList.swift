//
//  StringObjectListData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class StringObjectList: ObservableObject{
    @Published var stringObjectListData: [StringObject]  = [
    ]
    
    func Count() -> Int{
        return stringObjectListData.count
    }
    
    func AddElement(NewElement element: StringObject){
        stringObjectListData.append(element)
    }
    
    func Clean(){
        stringObjectListData.removeAll()
    }
    
    func CreateStringObjects(FromCIImage img: CIImage){
        //For init targetImageProcessed, think about place it someplace before delete
//        if data.targetImageProcessed.extent.width > 0{
//        }
//        else{
//            data.targetImageProcessed = data.targetImage
//        }
        data.targetImageSize = [Int64(img.extent.width), Int64(img.extent.height)]

        if img.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
            stringObjectList.stringObjectListData = stringObjects
        }
        else{
            print("Load Image failed.")
        }
    }
    
}
