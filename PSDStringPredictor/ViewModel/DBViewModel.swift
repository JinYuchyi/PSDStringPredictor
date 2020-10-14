//
//  DBViewModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI
import GRDB

class DBViewModel: ObservableObject{
    //var dbModel = DB()
    let imgUtil = ImageUtil()
    let csv = CSVManager()
    @Published private var dbPathString = "db.sqlite3"
    @Environment(\.managedObjectContext) private var viewContext

    
    func ConnectDB()  {
        //imgUtil.RenderText("Text123!")
        //imgUtil.RenderTextToImage("Text123")
        DB.shared.connectDatabase(DBFilePath: dbPathString)
        //imgUtil.RenderTextToImage(Content: "Text123!", Color: NSColor.init(red: 1, green: 0, blue: 0, alpha: 1) , Size: 100)

    }
    
    func ReloadFontTable()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "csv" ) )
                {
                    //DataStore.fontCsvPath = panel.url!.path
                    //DB.shared.RefillFontDBFromCSV()
                    TrackingDataManager.Delete(AppDelegate().persistentContainer.viewContext)

                    let str = CSVManager.shared.ReadAllContentAsString(FromFile: panel.url!.path)
                    let objArray = CSVManager.shared.ParsingCsvStringAsTwoIntArray(FromString: str)
                    var index = 0
                    for obj in objArray{
                        TrackingDataManager.Create(AppDelegate().persistentContainer.viewContext, Int16(obj[0]), Int16(obj[1]))
                        index += 1
                    }
                    
                    print("\(index) of \(objArray.count) items have been filled into DB.")

                }
            }
        }
    }
    
    func ReloadCharacterTable()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "csv" ) )
                {
                    //DataStore.fontCsvPath = panel.url!.path
                    //DB.shared.RefillFontDBFromCSV()
                    CharDataManager.Delete(AppDelegate().persistentContainer.viewContext)

                    let str = CSVManager.shared.ReadAllContentAsString(FromFile: panel.url!.path)
                    let objArray = CSVManager.shared.ParsingCsvStringAsCharObjArray(FromString: str)
                    var index = 0
                    for obj in objArray{
                        CharDataManager.Create(AppDelegate().persistentContainer.viewContext, (obj.char), obj.fontSize, obj.width, obj.height)
                        index += 1
                    }
                    
                    print("\(index) of \(objArray.count) items have been filled into DB.")

                }
            }
        }
    }
    
//    //GRDB
//    func Connect(){
//        let dbQueue = try DatabaseQueue(path: dbPathString)
//
//    }
}
