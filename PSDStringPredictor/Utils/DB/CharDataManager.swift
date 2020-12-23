//
//  CharData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

class CharDataManager{
    static let shared = CharDataManager()
    
    private init(){}
    
    static func Insert(_ context: NSManagedObjectContext, _ char: String, _ fontSize: Int16 , _ width: Int16, _ height: Int16, _ fontWeight: String){
        var keyvalues: [String: AnyObject] = [:]
        keyvalues["char"] = char as AnyObject
        keyvalues["fontSize"] = fontSize as AnyObject
        keyvalues["width"] = width as AnyObject
        keyvalues["height"] = height as AnyObject
        keyvalues["fontWeight"] = fontWeight as AnyObject
        
        let items = CharDataManager.FetchItems(context, keyValues: keyvalues)
        
        
        if (items.count == 0){
            let newCharData = CharacterData(context: context)
            newCharData.char = char
            newCharData.fontSize = fontSize
            newCharData.width = width
            newCharData.height = height
            
            try? context.save()
        }
        else{
            print("For we already have \(items.count) same item(s), the creating action skipped.")
        }
    }
    
    static func BatchInsert(_ context: NSManagedObjectContext, CharObjectList: [CharDataObject]){
        //Create objects
        var objects: [[String: Any]] = []
        for item in CharObjectList{
            var tmpItem: [String: Any] = [:]
            tmpItem["char"] = item.char
            tmpItem["fontSize"] = item.fontSize
            tmpItem["width"] = item.width
            tmpItem["height"] = item.height
            tmpItem["fontWeight"] = item.fontWeight
            objects.append(tmpItem)
        }
        
        context.perform {
            let insertRequest = NSBatchInsertRequest(entityName: "CharacterData", objects: objects)
            let insertResult = try? context.execute(insertRequest) as? NSBatchInsertResult
            let success = insertResult?.result as! Bool
            print("Batch insert \(success)")
        }
    }
    
    //    static func FetchAll(_ context: NSManagedObjectContext)->[TrackingDataObject]{
    //        var trackingDatas:[TrackingDataObject] = []
    //        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName:"TrackingData")
    //        request.sortDescriptors = [NSSortDescriptor(key: "size", ascending: true)]
    //        let objs = (try? context.fetch(request)) ?? []
    //        for item in objs {
    //            trackingDatas.append(TrackingDataObject(size: item.size, tracking: item.tracking))
    //        }
    //        return trackingDatas
    //
    //    }
    
    static func FetchItems(_ context: NSManagedObjectContext, keyValues: [String: AnyObject]) -> [CharDataObject]{
        var charDataList:[CharDataObject] = []
        let request: NSFetchRequest<CharacterData> = NSFetchRequest(entityName: "CharacterData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        
        var predicateList: [NSPredicate] = []
        
        if(keyValues.count > 0){
            for (key, value) in keyValues {
                //print("%K == %@", key, value as! NSObject)
                let predicate:NSPredicate = NSPredicate(format: "%K == %@", key, value as! NSObject)
                predicateList.append(predicate)
            }
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:predicateList)
        }
        //    static func FetchItems(_ context: NSManagedObjectContext, char: String = "", fontSize: Int16 = -1000, width: Int16 = -1000, height: Int16 = -1000) -> [CharDataObject]{
        //        var charDatas:[CharDataObject] = []
        //        let request: NSFetchRequest<CharacterData> = NSFetchRequest(entityName: "CharacterData")
        //        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        //        //let predicate: NSPredicate
        //        if (char != "" && fontSize == -1000 && width == -1000 && height == -1000){
        //            request.predicate = NSPredicate(format: "char = %@ ", char)
        //        }
        //        else if (char != "" && fontSize != -1000 && width == -1000 && height == -1000){
        //            request.predicate = NSPredicate(format: "char = %@ and fontSize = %@", char, NSNumber(value: Int(fontSize)))
        //        }
        //        else if (char != "" && fontSize != -1000 && width != -1000 && height == -1000){
        //            request.predicate = NSPredicate(format: "char = %@ and fontSize = %@ and width = %@", char, NSNumber(value: Int(fontSize)), NSNumber(value: Int(width)))
        //        }
        //        else if (char != "" && fontSize != -1000 && width != -1000 && height != -1000){
        //            request.predicate = NSPredicate(format: "char = %@ and fontSize = %@ and width = %@ and height = %@", char, NSNumber(value: Int(fontSize)), NSNumber(value: Int(width)), NSNumber(value: Int(height)))
        //        }
        //        else if (char != "" && fontSize == -1000 && width != -1000 && height != -1000){
        //            request.predicate = NSPredicate(format: "char = %@ and width = %@ and height = %@", char, NSNumber(value: Int(width)), NSNumber(value: Int(height)))
        //        }
        
        let objs = (try? context.fetch(request)) ?? []
        //print("Fetched \(objs.count) items, from char = \(char), width = \(width), height = \(height) ")
        for item in objs {
            charDataList.append(CharDataObject(char: item.char!, fontSize: item.fontSize, height: item.height, width: item.width, fontWeight: item.fontWeight!))
        }
        return charDataList
    }
    
    static func FetchNearestOne(_ context: NSManagedObjectContext, fontSize: Int16 ) -> CharDataObject{
        let request: NSFetchRequest<CharacterData> = NSFetchRequest(entityName: "CharacterData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: false)]
        request.predicate = NSPredicate(format: "fontSize <= %@ ", NSNumber(value: Int(fontSize)))
        
        let request1: NSFetchRequest<CharacterData> = NSFetchRequest(entityName: "CharacterData")
        request1.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        request1.predicate = NSPredicate(format: "fontSize > %@ ", NSNumber(value: Int(fontSize)))
        
        let objs = (try? context.fetch(request)) ?? []
        let objs1 = (try? context.fetch(request1)) ?? []
        
        let size = objs.first?.fontSize ?? 0
        let size1 = objs1.first?.fontSize ?? 0
        
        if (size1 > 0 && size > 0){
            let dist = abs(size - fontSize)
            let dist1 = abs(size1 - fontSize)
            return dist <= dist1 ? CharDataObject(char: objs.first!.char!, fontSize: objs.first!.fontSize, height: objs.first!.height, width: objs.first!.width, fontWeight: objs.first!.fontWeight!) :  CharDataObject(char: objs1.first!.char!, fontSize: objs1.first!.fontSize, height: objs1.first!.height, width: objs1.first!.width, fontWeight: objs.first!.fontWeight!)
        }
        else{
            return CharDataObject(char: "", fontSize: 0,height: 0,width: 0, fontWeight: "SFProDisplay-Regular")
        }
    }
    
    static func Delete(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000){
        let request: NSFetchRequest<CharacterData> = NSFetchRequest(entityName:"CharacterData")
        
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ ", NSNumber(value: Int(fontSize)))
        }
        else if (fontSize != -1000 && fontTracking != -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ and fontTracking = %@", NSNumber(value: Int(fontSize)), NSNumber(value: Int(fontTracking)))
        }
        
        let objs = (try? context.fetch(request)) ?? []
        let index = objs.count
        var index1 = 0
        for item in objs {
            context.delete(item)
            index1 += 1
        }
        
        try? context.save()
        print("\(index1) of \(index) items have been deleted.")
        
    }
    
}
