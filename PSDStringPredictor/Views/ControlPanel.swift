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
    @Binding var db: DBUtils
    @Binding var ocr: OCRUtils
    @ObservedObject var stringObjectList: StringObjectList
    
    let tempImagePath = "LocSample"
    
    var imageProcess = ImageProcess()
    
    func HandleDBConnection(){
        //loglist.PushMsg("Hi, This is the new log", LogObject.Category.normal)
        db.connectDatabase()
        //db.TableCharacterCreate()
        //db.ReFillDBFromCSV()
    }
    
    func CreateStringObjects(){
        let cgImg: CGImage = ImageStore.loadImage(name: tempImagePath)
        guard let ciImg = imageProcess.convertCGImageToCIImage(inputImage: cgImg) else { return   }
        if ciImg.extent.isEmpty == false{
            let stringObjects = ocr.CreateAllStringObjects(FromCIImage: ciImg)
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





