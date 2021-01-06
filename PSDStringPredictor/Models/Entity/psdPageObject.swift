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
        //var name: String
        //var thumbnail: CIImage
        var stringObjects: [StringObject]
        var imageURL: URL
        
        fileprivate init(id: Int, stringObjects: [StringObject], imageURL: URL){
            self.id = id
            //self.thumbnail = thumbnail
            self.stringObjects = stringObjects
            self.imageURL = imageURL
        }
    }
    
    fileprivate var uniqID = 0
    
    mutating func addPSDObject( imageURL: URL, stringObjects: [StringObject]){
        PSDObjects.append(PSDObject(id: uniqID, stringObjects: stringObjects, imageURL: imageURL))
        uniqID = (uniqID + 1) % 1000000
    }
    
    mutating func removePSDObject( id: Int)  {
        let r = PSDObjects.removeAll(where: {$0.id == id})
    }

}
