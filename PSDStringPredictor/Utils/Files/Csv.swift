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
    
    private func ReadAllContentAsString(FromFile filePath: String) -> String{
        
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
    
    private func ParsingCsvStringAsTrackingObjectArray(FromString str: String) -> [TrackingDataObject]{
        var objArray : [TrackingDataObject] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let b = Int16(itemArray[0])!
            let tmpStr = itemArray[1].replacingOccurrences(of: "\r", with: "")
            let c = Int16(tmpStr)!
            
            objArray.append(TrackingDataObject(fontSize: b, fontTracking: c))
            
        }
        return objArray
    }
    
    private func ParsingCsvStringAsCharObjArray(FromString str: String) -> [CharDataObject]{
        var objArray : [CharDataObject] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let a = itemArray[0]
            let b = Int16(itemArray[1])!
            let c = Int16(itemArray[2])!
            let d = Int16(itemArray[3].replacingOccurrences(of: "\r", with: ""))!
            
            objArray.append(CharDataObject(char: a,fontSize: d,height: c,width: b))
            
        }
        return objArray
    }
    
    private func ParsingCsvStringAsFontStandardArray(FromString str: String) -> [FontStandardObject]{
        var objArray : [FontStandardObject] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            
            let a = itemArray[0]
            let b = itemArray[1]
            let c = itemArray[2]
            let d = Int16(itemArray[3])!
            let e = Int16(itemArray[4].replacingOccurrences(of: "\r", with: ""))!
            
            objArray.append(FontStandardObject(os: a, style: FontStyleType.init(rawValue: b)!, weight: FontWeightType.init(rawValue: c)!, fontSize: d, lineHeight: e))
            
        }
        return objArray
    }
    
    func ParsingCsvFileAsTrackingObjectArray(FilePath path: String) -> [TrackingDataObject] {
        let str = ReadAllContentAsString(FromFile: path)
        return ParsingCsvStringAsTrackingObjectArray(FromString: str)
    }
    
    func ParsingCsvFileAsCharObjArray(FilePath path: String) -> [CharDataObject] {
        let str = ReadAllContentAsString(FromFile: path)
        return ParsingCsvStringAsCharObjArray(FromString: str)
    }
    
    func ParsingCsvFileAsFontStandardArray(FilePath path: String) -> [FontStandardObject] {
        let str = ReadAllContentAsString(FromFile: path)
        return ParsingCsvStringAsFontStandardArray(FromString: str)
    }
}
