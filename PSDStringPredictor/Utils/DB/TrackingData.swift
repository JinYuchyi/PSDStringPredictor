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
        let newTracking = TrackingData(context: context)
        newTracking.fontSize = fontSize
        newTracking.fontTracking = fontTracking
        
        let items = FetchItems(context, fontSize: fontSize, fontTracking: fontTracking)
        if (items.count == 0){
            do{
                try context.save()
            }catch{
                print("Create new item failed.")
            }
        }else{
            print("Creating action skipped, for we have same data in DB.")
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
    
    static func FetchItems(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000)->[TrackingDataObject]{
        var trackingDatas:[TrackingDataObject] = []
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName: "TrackingData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        //let predicate: NSPredicate
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ ", fontSize)
        }
        else if (fontSize != -1000 && fontTracking != -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ and fontTracking = %@", fontSize, fontTracking)
        }
        
        let objs = (try? context.fetch(request)) ?? []
        for item in objs {
            trackingDatas.append(TrackingDataObject(fontSize: item.fontSize, fontTracking: item.fontTracking))
        }
        return trackingDatas
    }
    
    static func Delete(_ context: NSManagedObjectContext, fontSize: Int16 = -1000, fontTracking: Int16 = -1000){
        let request: NSFetchRequest<TrackingData> = NSFetchRequest(entityName:"TrackingData")
        if (fontSize != -1000 && fontTracking == -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ ", NSNumber(value: fontSize))
        }
        else if (fontSize != -1000 && fontTracking != -1000){
            request.predicate = NSPredicate(format: "fontSize = %@ and fontTracking = %@", NSNumber(value: fontSize), NSNumber(value: fontTracking))
        }
        let objs = (try? context.fetch(request)) ?? []
        for item in objs {
            context.delete(item)
        }
    }
    
    
}
