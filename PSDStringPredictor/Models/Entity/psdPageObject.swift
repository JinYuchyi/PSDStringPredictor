//
//  psdPageObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

struct PSD {
    var PSDObjects = [PSDObject]()
    
    struct PSDObject: Identifiable{
        var id: Int
        var name: String
        var thumbnail: CIImage
        var stringObjects: [StringObject]
        
        fileprivate init(id: Int, name: String, thumbnail: CIImage, stringObjects: [StringObject]){
            self.id = id
            self.name = name
            self.thumbnail = thumbnail
            self.stringObjects = stringObjects
        }
    }
    
    fileprivate var uniqID = 0
    
    mutating func addPSDObject( name: String, thumbnail: CIImage, stringObjects: [StringObject]){
        PSDObjects.append(PSDObject(id: uniqID, name: name, thumbnail:thumbnail, stringObjects:stringObjects))
        uniqID = (uniqID + 1) % 1000000
        
    }
    
    mutating func removePSDObject( id: Int)  {
        let r = PSDObjects.removeAll(where: {$0.id == id})
    }

}
