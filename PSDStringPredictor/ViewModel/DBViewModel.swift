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
                    DataStore.fontCsvPath = panel.url!.path
                    DB.shared.RefillFontDBFromCSV()
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
                    DataStore.csvPath = panel.url!.path
                    DB.shared.RefillDBFromCSV()
                }
            }
        }
    }
    
    //GRDB
    func Connect(){
        let dbQueue = try DatabaseQueue(path: dbPathString)

    }
}
