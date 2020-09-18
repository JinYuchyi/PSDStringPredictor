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
        //print(objStrArray[1])
        for index in 0..<objStrArray.count{
            let itemArray = objStrArray[index].components(separatedBy: ",")
            let newobj = StrObj(char: itemArray[0], width: Int64(itemArray[1])!, height: Int64(itemArray[2])!, weight: Int64(itemArray[3])!)
            objArray.append(newobj)
            //Test
            
        }
        //In here, the order is correct
        return objArray
    }
    

}
