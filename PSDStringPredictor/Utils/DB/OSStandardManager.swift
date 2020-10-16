//
//  CharData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 13/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

class OSStandardManager{
    static let shared = OSStandardManager()
    
    private init(){}
    
    static func Insert(_ context: NSManagedObjectContext, _ os: String, _ style: FontStyleType , _ weight: FontWeightType, _ fontSize: Int16, _ lineHeight: Int16){
        
        let items = OSStandardManager.FetchItems(context, cmds: ["os = \(os)", "style = \(style.rawValue)", "weight = \(weight.rawValue)", "fontSize = %d", "lineHeight = %d"])
        if (items.count == 0){
            let standard = Standard(context: context)
            standard.os = os
            standard.style = style.rawValue
            standard.weight = weight.rawValue
            standard.fontSize = fontSize
            standard.lineHeight = lineHeight
            try? context.save()
        }
        else{
            print("For we already have \(items.count) same item(s), the creating action skipped.")
        }
    }
    
    static func BatchInsert(_ context: NSManagedObjectContext, FontStandardObjectList: [FontStandardObject]){
        //Create objects
        var objects: [[String: Any]] = []
        for item in FontStandardObjectList{
            var tmpItem: [String: Any] = [:]
            tmpItem["os"] = item.os
            tmpItem["style"] = item.style.rawValue
            tmpItem["weight"] = item.weight.rawValue
            tmpItem["fontSize"] = item.fontSize
            tmpItem["lineHeight"] = item.lineHeight
            objects.append(tmpItem)
        }
        
        context.perform {
            let insertRequest = NSBatchInsertRequest(entityName: "Standard", objects: objects)
            let insertResult = try? context.execute(insertRequest) as! NSBatchInsertResult
            let success = insertResult?.result as! Bool
            //print("Batch insert \(success)")
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
    
    static func FetchItems(_ context: NSManagedObjectContext, cmds: [String]) -> [FontStandardObject]{
        var charDataList:[FontStandardObject] = []
        let request: NSFetchRequest<Standard> = NSFetchRequest(entityName: "Standard")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        
        var predicateList: [NSPredicate] = []
        
        if(cmds.count > 0){
            for cmd in cmds {
                let predicate:NSPredicate = NSPredicate(format: cmd)
                predicateList.append(predicate)
            }
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:predicateList)
        }


        let objs = (try? context.fetch(request)) ?? []
        for item in objs {
            //print("Appending: \(item.os),\(item.fontSize), \(item.weight), \(item.lineHeight)")
            charDataList.append( FontStandardObject(os: item.os!, style: FontStyleType.init(rawValue: item.style!)!, weight: FontWeightType.init(rawValue: item.weight!)!, fontSize: item.fontSize, lineHeight: item.lineHeight) )
        }
        return charDataList
    }
    
    static func FetchNearestOne(_ context: NSManagedObjectContext, fontSize: Int16 ) -> FontStandardObject{
        let request: NSFetchRequest<Standard> = NSFetchRequest(entityName: "Standard")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: false)]
        request.predicate = NSPredicate(format: "fontSize <= %@ ", NSNumber(value: Int(fontSize)))
        
        let request1: NSFetchRequest<Standard> = NSFetchRequest(entityName: "Standard")
        request1.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        request1.predicate = NSPredicate(format: "fontSize > %@ ", NSNumber(value: Int(fontSize)))
        
        let objs = (try? context.fetch(request)) ?? []
        let objs1 = (try? context.fetch(request1)) ?? []
        
        let size = objs.first?.fontSize ?? 0
        let size1 = objs1.first?.fontSize ?? 0


        if (size1 > 0 && size > 0){
            let dist = abs(size - fontSize)
            let dist1 = abs(size1 - fontSize)
            
            return dist <= dist1 ? FontStandardObject(os: objs.first!.os!, style: FontStyleType.init(rawValue: objs.first!.style!)!, weight: FontWeightType.init(rawValue: objs.first!.weight!)!, fontSize: objs.first!.fontSize, lineHeight: objs.first!.lineHeight) :
                FontStandardObject(os: objs1.first!.os!, style: FontStyleType.init(rawValue: objs1.first!.style!)!, weight: FontWeightType.init(rawValue: objs1.first!.weight!)!, fontSize: objs1.first!.fontSize, lineHeight: objs1.first!.lineHeight)
        }
        else{
            return FontStandardObject(os: "", style: FontStyleType.Body, weight: FontWeightType.Regular, fontSize: 0, lineHeight: 0)
        }
    }
    
    static func DeleteAll(_ context: NSManagedObjectContext){
        let request: NSFetchRequest<Standard> = NSFetchRequest(entityName:"Standard")

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
