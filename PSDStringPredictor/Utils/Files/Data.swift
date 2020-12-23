import Foundation
import CoreLocation
import SwiftUI

//let stringObjectsData: [StringObject] = load("StringObjectsData.json")


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}



class ReadTextFromFile{
    
    struct StrObj {
        var char: String
        var width: Int64
        var height: Int64
        var weight: Int64
        
    }

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
    
    func ConvertToObjectArray(FromString str: String) -> [StrObj]{
        var objArray: [StrObj] = []
        let objStrArray = str.components(separatedBy: "\n")
        for index in 1..<objStrArray.count{
            //print("index: \(index)")
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let a = itemArray[0]
            let b = Int64(itemArray[1])!
            let c = Int64(itemArray[2])!
            let d = Int64(itemArray[3].replacingOccurrences(of: "\r", with: ""))!
            let newobj = StrObj(char: a, width: b, height: c, weight: d)
            objArray.append(newobj)
            
        }
        return objArray
    }
    
    func ParseFontDataString(FromString str: String) -> [[Int]]{
        var _array = [[Int]]()
        let objArray = str.components(separatedBy: "\n")
        for index in 1..<objArray.count{
            let itemArray = objArray[index].components(separatedBy: ",")
            let a = Int(itemArray[0])!
            let b = Int(itemArray[1])!
            let tmp = [a,b]
            _array.append(tmp)
        }
        return _array
    }
    

}
