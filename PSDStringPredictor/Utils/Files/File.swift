//
//  File.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 15/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import CoreImage

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

func TempPath()-> String{
    var tmpFolder = NSTemporaryDirectory()
    let folderName = "StringLayersGenerator/"
    tmpFolder = tmpFolder + folderName
    if FileManager.default.fileExists(atPath: tmpFolder) == false {
        //Create path
        try! FileManager.default.createDirectory(atPath: tmpFolder, withIntermediateDirectories: true)
    }
    return tmpFolder
}

func DuplicateFileToTempPath(at srcURL: URL) ->String {
    print("Temp Folder: \(TempPath())")
    let tempURL = URL.init(string: TempPath())
    let dstURL = URL.init(fileURLWithPath: tempURL!.appendingPathComponent(srcURL.lastPathComponent).path)
    do {
        if FileManager.default.fileExists(atPath: dstURL.path) {
            try FileManager.default.removeItem(at: dstURL)
        }
        try FileManager.default.copyItem(at: srcURL, to: dstURL)
    } catch (let error) {
        print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
        return ""
    }
    return dstURL.path
}

func MakeImagesInTempFolder(imagePathList: [String]){
    let js = JSManager.shared
    let tempFolderPath = TempPath()
    let variable = """
        paths = \(imagePathList)
        tmpPath = \(tempFolderPath)

    """
    let targetPyPath = Bundle.main.resourcePath! +  "/psdToPngInTempFolder.py"
    let pythonContent = js.ReadJSToString(jsPath: targetPyPath)
    let pyStr = variable.appending(pythonContent)
    
    do {
        let path = Bundle.main.resourcePath! + "run.py"
        let url = URL.init(fileURLWithPath: path)
        try pyStr.write(to: url, atomically: false, encoding: .utf8)
    }
    catch {
        return
    }
    
    let cmd = "python3 " + Bundle.main.resourcePath! + "run.py"
    PythonScriptManager.RunScript(str: cmd)
}

func saveCharDataset(img: CIImage, str: String) {
    let charDatasetFolder = "/Users/ipdesign/Box/MyShare/DataSet/charColorDataset/"
    let mainUrl = URL.init(string: charDatasetFolder)!
    
    // Check if the main folder is reachable
    do {
        let b: Bool
        try b = mainUrl.checkResourceIsReachable()
        if b == false {
            return
        }
    }catch{}
    
    if str.count == 2 && Array(str)[0].isLowercase == true && (Array(str)[1] == "l" || Array(str)[1] == "d") {
        let _char = String(Array(str)[0])
        let _cmode = String(Array(str)[1])
        let subFolder = charDatasetFolder + _char + "/" + _char + _cmode + "/"
        
        var num : Int = 0
        try? num = FileManager.default.contentsOfDirectory(atPath: subFolder).count
        
        
        let _fileName = _char + "_" + _cmode + "_" + String(num + 1) + ".png"

        img.ToPNG(url: URL.init(fileURLWithPath: subFolder + _fileName))
        print("Image saved to \(subFolder + _fileName)")
    }else {
        print("The parameter does not fit for the criteria. The first letter represents which character, and the second letter should be 'l' or 'r' which represent the color mode.")
    }
}

