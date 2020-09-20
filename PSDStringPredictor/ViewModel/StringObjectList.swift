//
//  StringObjectListData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

class StringObjectList: ObservableObject{
    
    //@Published var stringObjectListData: [StringObject]  = []
    @Published var ocr: OCR = OCR()
    @Published var data: DataStore = DataStore()
    
    func Count() -> Int{
        return stringObjectList.count
    }
    
    func AddElement(NewElement element: StringObject){
        stringObjectList.append(element)
    }
    
    func Clean(){
        stringObjectList.removeAll()
    }
    
    func CreateStringObjects(FromCIImage img: CIImage){
        //For init targetImageProcessed, think about place it someplace before delete
//        if data.targetImageProcessed.extent.width > 0{
//        }
//        else{
//            data.targetImageProcessed = data.targetImage
//        }
        //targetImageSize = [Int64(img.extent.width), Int64(img.extent.height)]

        if img.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img )
            stringObjectList = stringObjects
        }
        else{
            print("Load Image failed.")
        }
    }
    
}
