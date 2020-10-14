//
//  Csv.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class CSVManager{
    
    static let shared = CSVManager()
    
    func ReadAllContentAsString(FromFile filePath: String) -> String{
        
        if FileManager.default.fileExists(atPath: filePath) {
            print("CSV file found.")
        }else{
            print("CSV file not found.")
        }
        let readHandle = FileHandle.init(forReadingAtPath: filePath)
        let data = readHandle?.readDataToEndOfFile()

        let str = String.init(data: data!, encoding: String.Encoding.utf8)
        return str!
    }
    
    func ParsingCsvStringAsTwoIntArray(FromString str: String) -> [[Int64]]{
        var objArray : [[Int64]] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let b = Int64(itemArray[0])!
            let tmpStr = itemArray[1].replacingOccurrences(of: "\r", with: "")
            let c = Int64(tmpStr)!
            
            objArray.append([b,c])
            
        }
        return objArray
    }
    
    func ParsingCsvStringAsCharObjArray(FromString str: String) -> [CharDataObject]{
        var objArray : [CharDataObject] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let a = itemArray[0]
            let b = Int16(itemArray[1])!
            let c = Int16(itemArray[2])!
            let d = Int16(itemArray[3].replacingOccurrences(of: "\r", with: ""))!
            
            objArray.append(CharDataObject(char: a,fontSize: b,height: c,width: d))
            
        }
        return objArray
    }
}
