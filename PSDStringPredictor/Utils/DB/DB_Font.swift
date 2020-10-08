//
//  DB_Font.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SQLite

func TableFontCreate() {
    do { // 创建表TABLE_LAMP
        try DataStore.dbConnection.run(Table("table_font").create { table in
            table.column(Expression<Int64>("id"), primaryKey: .autoincrement) // 主键自加且不为空
            table.column(Expression<Int64>("size"))
            table.column(Expression<Int64>("tracking"))
        })
        print("Create Table table_font Success!")
    } catch {
        print("Create Table table_font Failed：\(error)")
    }
}
