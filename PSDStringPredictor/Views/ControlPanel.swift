//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ControlPanel: View {
    //@ObservedObject var loglist: LogListData
    @ObservedObject var db: DBUtils
    @Binding var ocr: OCRUtils
    @ObservedObject var stringObjectList: StringObjectList
    var imageProcess: ImageProcess  = ImageProcess()
    @EnvironmentObject var data: DataStore
    //var fontSizeML : FontSizeML = FontSizeML()
    //let tempImagePath = "LocSample"

    
    func HandleDBConnection(){
        data.targetImageName = "LocSample"
        //loglist.PushMsg("Hi, This is the new log", LogObject.Category.normal)
        db.connectDatabase()
        
        //db.TableCharacterCreate()
        //db.ReFillDBFromCSV()
    }
    
    func CreateStringObjects(){
        
        //Load image for test
        //let nsImg = LoadNSImage(imageUrlPath: "/Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/Resources/LocSample.png")
        //data.targetNSImage = nsImg
        data.targetImage = imageProcess.LoadCIImage(FileName: "LocSample")!
        if data.targetImageProcessed.extent.width > 0{
        }else{
            data.targetImageProcessed = data.targetImage
        }
        data.targetImageSize = [Int64(data.targetImageProcessed.extent.width), Int64(data.targetImageProcessed.extent.height)]
        //let targetCII = imageProcess.ConvertCGImageToCIImage(inputImage: targetImg)!
//      imageProcess.targetImage = imageProcess.LoadCIImage(FileName: "LocSample")!
        
        //guard let ciImg = CIImage.init?(contentsOf: URL(imageProcess.targetImagePath))
        
        //guard let ciImg = imageProcess.convertCGImageToCIImage(inputImage: image) else { return   }
        if data.targetImage.extent.width > 0{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: data.targetImageProcessed )
            stringObjectList.stringObjectListData = stringObjects
//            for index in 0..<stringObjects.count{
//                
//                print("All Weights: \(stringObjects[index].id) - \(stringObjects[index].content),\(stringObjects[index].FindBestWeightForString(db)), \(stringObjects[index].position)")
//            }
        }
        else{
            print("Load Image failed.")
        }
    }
    
    func CreateTrackingData(){
        var contentStr: String = ""
        let allFilePath: [String] = getAllFilePath("/Users/ipdesign/Downloads/TrackingDataSet")!
        for var i in 0...allFilePath.count - 1 {
            if allFilePath[i].GetSuffix() == "png"{
                let img = LoadNSImage(imageUrlPath: allFilePath[i])
                let stringObjects = ocr.CreateAllStringObjects(FromCIImage: img.ToCIImage()! )
                for var j in 0...stringObjects[0].charArray.count-2 {
                    if(String(stringObjects[0].charArray[j]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j+1]).FixError().isEnglishLowerCase() && String(stringObjects[0].charArray[j]).FixError() != String(stringObjects[0].charArray[j+1]).FixError()){
                        contentStr += String(stringObjects[0].charArray[j]).FixError() + ","
                        contentStr += String(stringObjects[0].charArray[j+1]).FixError() + ","
                        contentStr += allFilePath[i].GetFontSizeString() + ","
                        contentStr += allFilePath[i].GetTrackingString() + ","
                        contentStr += abs(stringObjects[0].charRects[j].midX - stringObjects[0].charRects[j + 1].midX).description + ","
                        contentStr += "\n"
                    }
                 
                }
            }
        }
        //Save Content
        SaveStringToFile(str: contentStr, path: "/Users/ipdesign/Downloads/TrackingDataSet/TrackingData.txt")
    }
    

    
    var body: some View {
        VStack{
            Button(action: HandleDBConnection){
                Text("Connect DB")
            }
            Button(action: CreateStringObjects){
                Text("Predict")
            }
            Button(action: CreateTrackingData){
                Text("Create Tracking Data")
            }
        }
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





