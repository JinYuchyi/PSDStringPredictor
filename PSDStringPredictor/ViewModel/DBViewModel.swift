//
//  DBViewModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class DBViewModel: ObservableObject{
    var dbModel = DB()
    let imgUtil = ImageUtil()
    @Published private var dbPathString = "db.sqlite3"
    
    func ConnectDB()  {
        //imgUtil.RenderText("Text123!")
        //imgUtil.RenderTextToImage("Text123")
        dbModel.connectDatabase(DBFilePath: dbPathString)
        //imgUtil.RenderTextToImage(Content: "Text123!", Color: NSColor.init(red: 1, green: 0, blue: 0, alpha: 1) , Size: 100)

    }
}
