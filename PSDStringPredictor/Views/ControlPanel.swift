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
    @ObservedObject var imageProcess: ImageProcess
    
    //var fontSizeML : FontSizeML = FontSizeML()
    //let tempImagePath = "LocSample"

    
    func HandleDBConnection(){
        imageProcess.targetImageName = "LocSample"
        //loglist.PushMsg("Hi, This is the new log", LogObject.Category.normal)
        db.connectDatabase()
        var shareData = ShareData()
        
        //db.TableCharacterCreate()
        //db.ReFillDBFromCSV()
    }
    
    func CreateStringObjects(){
        
        //Load image for test
        let targetImg = ImageStore.loadImage(name: imageProcess.targetImageName)
        imageProcess.targetImageSize = [targetImg.width, targetImg.height]
        let targetCII = imageProcess.ConvertCGImageToCIImage(inputImage: targetImg)!
//      imageProcess.targetImage = imageProcess.LoadCIImage(FileName: "LocSample")!
        
        //guard let ciImg = CIImage.init?(contentsOf: URL(imageProcess.targetImagePath))
        
        //guard let ciImg = imageProcess.convertCGImageToCIImage(inputImage: image) else { return   }
        if targetCII.extent.isEmpty == false{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: targetCII)
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





