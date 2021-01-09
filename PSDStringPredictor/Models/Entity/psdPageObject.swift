//
//  psdPageObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 26/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage
import SwiftUI

struct PSDObject: Identifiable{
    var id: Int
    //var name: String
    //var thumbnail: CIImage
    var stringObjects: [StringObject]
    var imageURL: URL
    var thumbnail: NSImage = NSImage.init()
    

    
    fileprivate init(id: Int, stringObjects: [StringObject], imageURL: URL){
        self.id = id
        //self.thumbnail = thumbnail
        self.stringObjects = stringObjects
        self.imageURL = imageURL
        self.thumbnail = FetchThumbnail(size: sizeOfThumbnail)
    }
    
    fileprivate func FetchThumbnail(size: Int) -> NSImage{
        let imgData = (try? Data(contentsOf: imageURL))
        if imgData != nil {
            let rowImage = NSImage.init(data: imgData!)
            return rowImage!.resize(sizeOfThumbnail)
        }
        return NSImage.init()
    }
}

struct PSD {
    var PSDObjects = [PSDObject]()
    
    fileprivate var uniqID = 0
    
    mutating func addPSDObject( imageURL: URL, stringObjects: [StringObject]){
        PSDObjects.append(PSDObject(id: uniqID, stringObjects: stringObjects, imageURL: imageURL))
        uniqID = (uniqID + 1) % 1000000
    }
    
    mutating func removePSDObject( id: Int)  {
        let r = PSDObjects.removeAll(where: {$0.id == id})
    }
    
    mutating func removePSDObject( imageUrl: URL)  {
         PSDObjects.removeAll(where: {$0.imageURL == imageUrl})
    }

}

extension PSDObject {
    func CalcColorMode() -> Int{
        return 0
    }
    

}
