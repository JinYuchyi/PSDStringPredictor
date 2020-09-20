//
//  DBModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SQLite

let TABLE_CHARACTER = Table("table_character")
let TABLE_CHARACTER_ID = Expression<Int64>("character_id")
let TABLE_CHARACTER_CHAR = Expression<String>("character_char")
let TABLE_CHARACTER_WIDTH = Expression<Int64>("character_width")
let TABLE_CHARACTER_HEIGHT = Expression<Int64>("character_height")
let TABLE_CHARACTER_WIGHT = Expression<Int64>("character_weight")

struct DB{
    //let dbPath = "/Users/ipdesign/Library/Containers/jin.PSDStringPredictor/Data/db.sqlite3"
    let csvPath = "CharacterData.csv"
    

    
    //var db: Connection!
    
//    init(DBFilePath path: String){
//        db = connectDatabase(DBFilePath: path)
//    }
    
    func connectDatabase(DBFilePath path: String) {
        //var tmpDb: Connection!
        //let sqlFilePath = path
        if FileManager.default.fileExists(atPath: path) {
            print("DB file found.")
        }
        else{
            print("Cannot find the DB file.")
        }
        
        do{
            dbConnection = try Connection(path)
            print(dbConnection.description)
        }
        catch{
            print("Connection Failed: \(error)")
        }
        
    }
    
        func TableCharacterCreate() -> Void {
            do { // 创建表TABLE_LAMP
                try dbConnection.run(TABLE_CHARACTER.create { table in
                    table.column(TABLE_CHARACTER_ID, primaryKey: .autoincrement) // 主键自加且不为空
                    table.column(TABLE_CHARACTER_CHAR)
                    table.column(TABLE_CHARACTER_WIDTH)
                    table.column(TABLE_CHARACTER_HEIGHT)
                    table.column(TABLE_CHARACTER_WIGHT)
                })
                print("Create Table Success!")
            } catch {
                print("Create Table Failed：\(error)")
            }
        }
        
        //Check if has duplicate item in DB
        func CheckIfDuplicated(char: String, width: Int64, height: Int64, weight: Int64) -> Bool{
            //let query = TABLE_CHARACTER.select(TABLE_CHARACTER_CHAR, TABLE_CHARACTER_WIDTH,TABLE_CHARACTER_HEIGHT,TABLE_CHARACTER_WIGHT)           // SELECT "email" FROM "users"
            let query = TABLE_CHARACTER.filter(TABLE_CHARACTER_CHAR == char && TABLE_CHARACTER_WIDTH == width && TABLE_CHARACTER_HEIGHT == height && TABLE_CHARACTER_WIGHT == weight)     // WHERE "name" IS NOT NULL
                .select(TABLE_CHARACTER_CHAR)
            //print("Checking same row: \(Array(arrayLiteral: query).count)")
            var num: Int = 0
            do{
                let obj = try dbConnection.prepare(query)
                num = Array(obj).count
            }
            catch{}
            if(num > 0){
                //print("\(char)-\(width)-\(height)-\(weight) duplicated, will skip")
                return true
            }else{ return false }
            
        }
        
        func CheckIfNoneLetterOrNumber(_ char: String) -> Bool{
            if (char.first?.isLetter == true || char.first?.isNumber == true){
                return false
            }
            return true
        }
        
        // 插入
        func TableCharacterInsertItem(char: String, width: Int64, height: Int64, weight: Int64) -> Void {

            let duplicated = CheckIfDuplicated(char: char, width: width, height: height, weight: weight)
            if(duplicated == false && CheckIfNoneLetterOrNumber(char) == false){
                let insert = TABLE_CHARACTER.insert(TABLE_CHARACTER_CHAR <- char, TABLE_CHARACTER_WIDTH <- width, TABLE_CHARACTER_HEIGHT <- height, TABLE_CHARACTER_WIGHT <- weight)
                do {
                    let rowid = try dbConnection.run(insert)
                    //print("Insert Data Success! id: \(rowid)")
                } catch {
                    print("Insert Data Failed: \(error)")
                }
            }
            else{
                print("We already have the same data in database. so the insert session will be just ignored.")
            }
        }
        
        //Run SQL
        func RunSQL(cmdStr: String)  {
            try! dbConnection.execute(cmdStr)
        }
        
        
    //    // 遍历
        func PrintAllItemsInCharacterTable() -> Void {
            
            do{
                let all = Array(try dbConnection.prepare(TABLE_CHARACTER))
            print("We have \(all.count) items in database.")
                for item in (try! dbConnection.prepare(TABLE_CHARACTER)) {
                print("CHARACRER:\n id: \(item[TABLE_CHARACTER_ID]), char: \(item[TABLE_CHARACTER_CHAR]), width: \(item[TABLE_CHARACTER_WIDTH]), height: \(item[TABLE_CHARACTER_HEIGHT]), weight: \(item[TABLE_CHARACTER_WIGHT])")
            }
                
            }catch{}
        }
        
        func PrintAllItemsInCharacterTable(limit lmt: Int) -> Void {
            var count: Int = 0
            do{
                let all = Array(try dbConnection.prepare(TABLE_CHARACTER))
            print("We have \(all.count) items in database.")
                for item in (try! dbConnection.prepare(TABLE_CHARACTER)) {
                //print("CHARACRER:\n id: \(item[TABLE_CHARACTER_ID]), char: \(item[TABLE_CHARACTER_CHAR]), width: \(item[TABLE_CHARACTER_WIDTH]), height: \(item[TABLE_CHARACTER_HEIGHT]), weight: \(item[TABLE_CHARACTER_WIGHT])")
                count+=1
                if(count > lmt){
                    return
                }
            }
                
            }catch{}
        }
        
        //Clean DB
        func RemoveAll(){
            //let item = TABLE_CHARACTER.filter(TABLE_CHARACTER_ID == *)
            //let items = try! db.prepare("SELECT * FROM TABLE_CHARACTER")
            do{
                try dbConnection.run(TABLE_CHARACTER.delete())
            print("Cleanning database...")

            }catch{
                print("Clean the DB failed! \(error)")
            }

        }
        
        func AddStrObjArrayToDB() -> Int{
            //RemoveAll()
            var index:Int = 0
            let readText = ReadTextFromFile()
            let str = readText.ReadAllContentAsString(FromFile: csvPath)
            let objArray = readText.ConvertToObjectArray(FromString: str)
            for obj in objArray{
                TableCharacterInsertItem(char:obj.char, width:obj.width, height:obj.height, weight: obj.weight)
                index += 1
            }
            return index
        }
        
        func FindWeightTest() {
            var num:Int = 0
            let query = TABLE_CHARACTER.filter(TABLE_CHARACTER_CHAR == "9" && TABLE_CHARACTER_WIDTH == 24 && TABLE_CHARACTER_HEIGHT == 34 )//
            .select(TABLE_CHARACTER_CHAR, TABLE_CHARACTER_WIDTH, TABLE_CHARACTER_HEIGHT,TABLE_CHARACTER_WIGHT)
                do{
                    let objs = try dbConnection.prepare(query)
                    for obj in objs{
                        num+=1
                    //num = Array(obj).count
                    //print("test num: \(num)")
                    print("num: \(num): \(obj[TABLE_CHARACTER_CHAR]), \(obj[TABLE_CHARACTER_WIDTH]), \(obj[TABLE_CHARACTER_HEIGHT])")
                    }
                }
            catch{}
        }
        
        func FindWeight1(_ char: String, _ width: Int64, _ height: Int64) -> Int64{
            var objArray: [Row] = []
            var result: Int64 = 0
            
            if(dbConnection == nil){
                print("DB equals null.")
                return 0
            }
                    
            let query = TABLE_CHARACTER.filter(TABLE_CHARACTER_CHAR == char && TABLE_CHARACTER_WIDTH == width && TABLE_CHARACTER_HEIGHT == height).select(TABLE_CHARACTER_CHAR,TABLE_CHARACTER_WIDTH,TABLE_CHARACTER_HEIGHT,TABLE_CHARACTER_WIGHT)
            do{
                let objs = try dbConnection.prepare(query)
                objArray = Array(objs)
                result = Int64(objArray.count)
                print("The result:\(result)")
            }
            catch{}
            
            return result

        }
        
        func ReFillDBFromCSV(){
            RemoveAll()
            print("Refilling data...")
            var num = AddStrObjArrayToDB()
            print("Refilling data finished, \(num) items have been added into DB.")
        }
        
    //    func FindWeight(_ char: String, _ width: Int64, _ height: Int64) -> Int64{
    //        var objArray: [Row] = []
    //        var result: Int64 = 0
    //
    //        if(data.db == nil){
    //            print("DB equals null.")
    //            return 0
    //        }
    //
    //        let query = TABLE_CHARACTER.filter(TABLE_CHARACTER_CHAR == char && TABLE_CHARACTER_WIDTH == width && TABLE_CHARACTER_HEIGHT == height).select(TABLE_CHARACTER_CHAR,TABLE_CHARACTER_WIDTH,TABLE_CHARACTER_HEIGHT,TABLE_CHARACTER_WIGHT)
    //        do{
    //            let objs = try data.db.prepare(query)
    //            objArray = Array(objs)
    //            result = Int64(objArray.count)
    //            //for obj in objArray{
    //            //num = Array(obj).count
    //            //print("test num: \(num)")
    //            //print("\(obj[TABLE_CHARACTER_CHAR]), \(obj[TABLE_CHARACTER_WIDTH]), \(obj[TABLE_CHARACTER_HEIGHT])")
    //            //}
    //        }
    //        catch{}
    //
    //
    //        func Predict() -> Int64 {
    //            Int64(PredictFontSize(character: char, width: Double(width), height: Double(height)))
    //        }
    //
    //        func FindIt() -> Int64{
    //            let strObj = objArray[0][TABLE_CHARACTER_WIGHT]
    //            result = strObj
    //            return strObj
    //        }
    //
    //        return result == 0 ? Predict() : FindIt()
    //
    //    }

    static func QueryFor(dbConnection: Connection!, char: String, width: Int64, height: Int64) -> [Row]{
            var objArray = [Row]()
            let query = TABLE_CHARACTER.filter(TABLE_CHARACTER_CHAR == char && TABLE_CHARACTER_WIDTH == width && TABLE_CHARACTER_HEIGHT == height).select(TABLE_CHARACTER_CHAR,TABLE_CHARACTER_WIDTH,TABLE_CHARACTER_HEIGHT,TABLE_CHARACTER_WIGHT)
            do{
                let objs = try dbConnection.prepare(query)
                objArray = Array(objs)
            }
            catch{}
            
            return objArray
        }
}
