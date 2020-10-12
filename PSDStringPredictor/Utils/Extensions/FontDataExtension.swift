//
//  FontDataExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreData

extension FontData{
    static func Create(_ size: Int16, _ tracking: Int16, context: NSManagedObjectContext)  {
        let request = NSFetchRequest<FontData>(entityName: "FontData")
        request.predicate = NSPredicate(format: "size = %@", size)
        request.sortDescriptors = [NSSortDescriptor(key:"size", ascending:true)]
        let fonts = (try? context.fetch(request)) ?? []
        if let fontData = fonts.first {
            //return fontData
            print("Item already exist with size of \(size)")
        }else{
            let fontData = FontData(context: context)
            fontData.size = size
            fontData.tracking = tracking
            try? context.save()
        }
    }
}
