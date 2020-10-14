//
//  CoreData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

class TrackingDataManager  {
    static let shared = TrackingDataManager()
//    var context: NSManagedObjectContext
//    static let shared = CoreDataManager(context: NSManagedObjectContext)
//
//    // Initialization
//    private init(context: NSManagedObjectContext) {
//        self.context = context
//    }
    
    private init(){}
    
    static func Create(_ context: NSManagedObjectContext, _ fontSize: Int16, _ fontTracking: Int16){
        
        let items = FetchItems(context, fontSize: fontSize, fontTracking: fontTracking)
        print(items.count)
        if (items.count == 0){
            print("Saving context.")
            
            let newTracking = TrackingData(context: context)
            newTracking.fontSize = fontSize
            newTracking.fontTracking = fontTracking
            
            try? context.save()
        }
        else{
            print("Creating action skipped, for we have same data (\(fontSize),\(fontTracking)) in DB.")
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
    
    static func FetchItems(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000) -> [TrackingDataObject]{
        var trackingDatas:[TrackingDataObject] = []
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        //let predicate: NSPredicate
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ ", NSNumber(value: Int(fontSize)))
        }
        if (fontSize != -1000 && fontTracking != -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ and fontTracking = %@", NSNumber(value: Int(fontSize)), NSNumber(value: Int(fontTracking)))
        }
        
        let objs = (try? context.fetch(request)) ?? []
        for item in objs {
            trackingDatas.append(TrackingDataObject(fontSize: item.fontSize, fontTracking: item.fontTracking))
        }
        return trackingDatas
    }
    
    static func FetchNearestOne(_ context: NSManagedObjectContext, fontSize: Int16 ) -> [Int16]{
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: false)]
        request.predicate = NSPredicate(format: "fontSize <= %@ ", NSNumber(value: Int(fontSize)))
        
        let request1: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        request1.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        request1.predicate = NSPredicate(format: "fontSize > %@ ", NSNumber(value: Int(fontSize)))
        
        let objs = (try? context.fetch(request)) ?? []
        let objs1 = (try? context.fetch(request1)) ?? []
        
        let size = objs.first?.fontSize ?? 0
        let size1 = objs1.first?.fontSize ?? 0
        
        if (size1 > 0 && size > 0){
            let dist = abs(size - fontSize)
            let dist1 = abs(size1 - fontSize)
            return dist <= dist1 ? [objs.first!.fontSize, objs.first!.fontTracking] :  [objs1.first!.fontSize, objs1.first!.fontTracking]
        }
        else{
            return []
        }
    }
    
    static func Delete(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000){
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName:"TrackingData")
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ ", NSNumber(value: Int(fontSize)))
        }
        if (fontSize != -1000 && fontTracking != -1000){
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
