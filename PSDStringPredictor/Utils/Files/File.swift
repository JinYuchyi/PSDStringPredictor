//
//  File.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

func SaveStringToFile(str: String, path: String){
    //let path = "myfile.txt"

    // Set the contents
    //let contents = "Here are my file's contents"

    do {
        // Write contents to file
        try str.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
}

func FileAtPathExist(PathString path: String) -> Bool{
    let fileExists = FileManager.default.fileExists(atPath: path)
    return fileExists
}

func GetDocumentsPath() -> String{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
    return documentsDirectory.path
}

