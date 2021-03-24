//
//  CharData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

class CharBoundsDataManager{
    static let shared = CharBoundsDataManager()
    
    private init(){}
    
    static func Insert(_ context: NSManagedObjectContext, _ char: String, _ fontSize: Int16 , _ x1: Int16, _ y1: Int16, _ x2: Int16, _ y2: Int16, _ weight: String){
        var keyvalues: [String: AnyObject] = [:]
        keyvalues["char"] = char as AnyObject
        keyvalues["fontSize"] = fontSize as AnyObject
        keyvalues["x1"] = x1 as AnyObject
        keyvalues["y1"] = y1 as AnyObject
        keyvalues["x2"] = x2 as AnyObject
        keyvalues["y2"] = y2 as AnyObject
        keyvalues["weight"] = weight as AnyObject
        let items = CharBoundsDataManager.FetchItems(context, keyValues: keyvalues)
        
        //print("Count: \(items.count)")
        
        if (items.count == 0){
            let newCharData = CharBounds(context: context)
            newCharData.char = char
            newCharData.fontSize = fontSize
            newCharData.x1 = x1
            newCharData.y1 = y1
            newCharData.x2 = x2
            newCharData.y2 = y2
            newCharData.weight = weight
            try? context.save()
        }
        else{
            print("For we already have \(items.count) same item(s), the creating action skipped.")
        }
    }
    
    static func BatchInsert(_ context: NSManagedObjectContext, CharBoundsList: [CharBoundsObject]){
        //Create objects
        var objects: [[String: Any]] = []
        for item in CharBoundsList{
            var tmpItem: [String: Any] = [:]
            tmpItem["char"] = item.char
            tmpItem["fontSize"] = item.fontSize
            tmpItem["x1"] = item.x1
            tmpItem["y1"] = item.y1
            tmpItem["x2"] = item.x2
            tmpItem["y2"] = item.y2
            tmpItem["weight"] = item.weight
            objects.append(tmpItem)
        }
        
        context.perform {
            let insertRequest = NSBatchInsertRequest(entityName: "CharBounds", objects: objects)
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
    
    static func FetchItems(_ context: NSManagedObjectContext, keyValues: [String: AnyObject]) -> [CharBoundsObject]{
        var charBoundsList:[CharBoundsObject] = []
        let request: NSFetchRequest<CharBounds> = NSFetchRequest(entityName: "CharBounds")
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

        let objs = (try? context.fetch(request)) ?? []
        //print("Fetched \(objs.count) items, from char = \(char), width = \(width), height = \(height) ")
        for item in objs {
            
            charBoundsList.append(CharBoundsObject(char: item.char!, fontSize: item.fontSize, x1: item.x1, y1: item.y1, x2: item.x2, y2: item.y2, weight: item.weight!))
            
        }
        return charBoundsList
    }
    
    static func FetchNearestOne(_ context: NSManagedObjectContext, fontSize: Int16 ) -> CharBoundsObject{
        let request: NSFetchRequest<CharBounds> = NSFetchRequest(entityName: "CharBounds")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: false)]
        request.predicate = NSPredicate(format: "fontSize <= %@ ", NSNumber(value: Int(fontSize)))
        
        let request1: NSFetchRequest<CharBounds> = NSFetchRequest(entityName: "CharBounds")
        request1.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        request1.predicate = NSPredicate(format: "fontSize > %@ ", NSNumber(value: Int(fontSize)))
        
        let objs = (try? context.fetch(request)) ?? []
        let objs1 = (try? context.fetch(request1)) ?? []
        
        let size = objs.first?.fontSize ?? 0
        let size1 = objs1.first?.fontSize ?? 0
        
        if (size1 > 0 && size > 0){
            let dist = abs(size - fontSize)
            let dist1 = abs(size1 - fontSize)
            return dist <= dist1 ? CharBoundsObject(char: objs.first!.char!, fontSize: objs.first!.fontSize, x1: objs.first!.x1, y1: objs.first!.y1, x2: objs.first!.x2, y2: objs.first!.y2, weight: objs.first!.weight!) :  CharBoundsObject(char: objs1.first!.char!, fontSize: objs1.first!.fontSize, x1: objs1.first!.x1, y1: objs1.first!.y1, x2: objs1.first!.x2, y2: objs1.first!.y2, weight: objs.first!.weight!)
        }
        else{
            return CharBoundsObject(char: "", fontSize: 0, x1: 0, y1: 0, x2: 0, y2: 0, weight: "")
        }
    }
    
    static func Delete(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, char: String = "", weight: String = ""){
        let request: NSFetchRequest<CharBounds> = NSFetchRequest(entityName: "CharBounds")
        
        if (fontSize != -1000 && char != ""){
            request.predicate = NSPredicate(format: "fontSize = %@ and char = %@", NSNumber(value: Int(fontSize)), String(char))
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
