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
        //let targetImg = ImageStore.loadImage(name: imageProcess.targetImageName) //Load to new image instance
        data.targetImage = imageProcess.LoadCIImage(FileName: "LocSample")!
        data.targetImageSize = [Int64(data.targetImage.extent.width), Int64(data.targetImage.extent.height)]
        //let targetCII = imageProcess.ConvertCGImageToCIImage(inputImage: targetImg)!
//      imageProcess.targetImage = imageProcess.LoadCIImage(FileName: "LocSample")!
        
        //guard let ciImg = CIImage.init?(contentsOf: URL(imageProcess.targetImagePath))
        
        //guard let ciImg = imageProcess.convertCGImageToCIImage(inputImage: image) else { return   }
        if data.targetImage.extent.isEmpty == false{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: data.targetImage )
            stringObjectList.stringObjectListData = stringObjects
            for index in 0..<stringObjects.count{
                
                //stringObjects[index].fontWeight = stringObjects[index].FindBestWeightForString()
                print("All Weights: \(stringObjects[index].id) - \(stringObjects[index].content),\(stringObjects[index].FindBestWeightForString(db)), \(stringObjects[index].position)")
            }
        }
        else{
            print("Load Image failed.")
        }
    }
    
    var body: some View {
        VStack{
            Button(action: HandleDBConnection){
                Text("Connect DB")
            }
            Button(action: CreateStringObjects){
                Text("Predict")
            }
        }
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





