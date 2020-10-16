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
    
    static func Insert(_ context: NSManagedObjectContext, _ fontSize: Int16, _ fontTracking: Int16, _ fontTrackingPoints: Float){
        
        let items = FetchItems(context, fontSize: fontSize, fontTracking: fontTracking)
        //print(items.count)
        if (items.count == 0){
            print("Saving context.")
            
            let newTracking = TrackingData(context: context)
            newTracking.fontSize = fontSize
            newTracking.fontTracking = fontTracking
            newTracking.fontTrackingPoints = fontTrackingPoints
            try? context.save()
        }
        else{
            print("Creating action skipped, for we have same data (\(fontSize),\(fontTracking)) in DB.")
        }
    }
    
    static func BatchInsert(_ context: NSManagedObjectContext, trackingObjectList: [TrackingDataObject]){
        //Create objects
        var objects: [[String: Any]] = []
        for item in trackingObjectList{
            var tmpItem: [String: Any] = [:]
            tmpItem["fontSize"] = item.fontSize
            tmpItem["fontTracking"] = item.fontTracking
            tmpItem["fontTrackingPoints"] = item.fontTrackingPoints
            objects.append(tmpItem)
        }
        
        context.perform {
            let insertRequest = NSBatchInsertRequest(entityName: "TrackingData", objects: objects)
            let insertResult = try? context.execute(insertRequest) as! NSBatchInsertResult
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
    
    static func FetchItems(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000) -> [TrackingDataObject]{
        var trackingDatas:[TrackingDataObject] = []
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        //request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        //let predicate: NSPredicate
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@", NSNumber(value: Int(fontSize)))
        }
        else if (fontSize != -1000 && fontTracking != -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ and fontTracking = %@", NSNumber(value: Int(fontSize)), NSNumber(value: Int(fontTracking)))
        }
        //let trackingDataList = try? request.execute()
        
        let objs = (try? context.fetch(request)) ?? []
        for item in objs {
            trackingDatas.append(TrackingDataObject(fontSize: item.fontSize, fontTracking: item.fontTracking, fontTrackingPoints: item.fontTrackingPoints))
        }
        print("fontSize = \(NSNumber(value: Int(fontSize))), count = \(objs.count)")

        return trackingDatas
    }
    
    static func FetchNearestOne(_ context: NSManagedObjectContext, fontSize: Int16 ) -> TrackingDataObject{
        //var object: TrackingDataObject
        let fetchedResult = TrackingDataManager.FetchItems(context, fontSize: fontSize)
        print("Fetching \(fontSize), result count is \(fetchedResult.count)")

        if (fetchedResult.count > 0) {
            //print("FetchNearestOne: \(fetchedResult.first!.fontSize), \(fetchedResult.first!.fontTracking)")
            return fetchedResult.first!
        }
        
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: false)]
        request.predicate = NSPredicate(format: "fontSize < %@ ", NSNumber(value: Int(fontSize)))
        
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
            return dist <= dist1 ? TrackingDataObject(fontSize: objs.first!.fontSize, fontTracking: objs.first!.fontTracking, fontTrackingPoints: objs.first!.fontTrackingPoints) :
                TrackingDataObject(fontSize: objs1.first!.fontSize, fontTracking: objs1.first!.fontTracking, fontTrackingPoints: objs1.first!.fontTrackingPoints)
        }
        else{
            return TrackingDataObject(fontSize: 0, fontTracking: 0, fontTrackingPoints: 0)
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
