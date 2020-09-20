//
//  DBViewModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class DBViewModel: ObservableObject{
    var dbModel = DB()
    @Published private var dbPathString = "db.sqlite3"
    
    func ConnectDB()  {
        dbModel.connectDatabase(DBFilePath: dbPathString)
    }
}
