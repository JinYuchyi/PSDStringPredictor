//
//  CoreData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager  {
    
//    init(DBModelName name: String){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//    }
    
    func InsertDataToEntitySizeTracking(FontSize size: Int16, Tracking tracking: Int16){
        let appDel = UIApplication.sharedApplication().delegateas! AppDelegate
        let context = appDel.managedObjectContext

        let item = NSEntityDescription.insertNewObjectForEntityForName("SizeTracking", inManagedObjectContext: context)
        
        item.size = size
        item.tracking = tracking
        
        //Save
        do {
            try context.save()
            print("Saving Data Success!")
        }catch let error{
            print("context saving failed, Error:\(error)")
        }
    }
    
    func FetchTrackingDataFromEntitySizeTracking(Size size: Int16) -> [Int16]{
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SizeTracking")
        
        //Condition
        let predicate = NSPredicate(format: "size=\(size)") //format:"id=1"
        fetchRequest.predicate=predicate
        
        //Execute
        do {
            let dataList = [Int16]
            try context.executeFetchRequest(fetchRequest)as! [NSManagedObject]
            var dList = [Int16]
            for d in dataList as! [SizeTracking] {
                //Modify: use context.save() to save
                if (d.size == size){
                    dList.append(d.tracking)
                 }
                //Delete: after delete the fetched result, use context.save() to save
//                if (person.name == "小明"){
//                     context.deleteObject(person)
//                 }
             }
         }catch let error{
             print("context can't fetch!, Error:\(error)")
         }
        do {
            try context.save()
            print("Saving Success!")
         }catch let error{
             print("context can't save!, Error:\(error)")
         }
        
        return dList
    }
    
    func ClearAll(){}
    
    

    
    
    
}
