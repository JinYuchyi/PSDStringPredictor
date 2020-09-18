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

    
//    func HandleDBConnection(){
//        //data.targetImageName = "LocSample"
//        //loglist.PushMsg("Hi, This is the new log", LogObject.Category.normal)
//        db.connectDatabase()
//
//        //db.TableCharacterCreate()
//        //db.ReFillDBFromCSV()
//    }
    

    

    

    
    var body: some View {
        VStack{
            Button(action: db.connectDatabase()){
                Text("Connect Database")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: stringObjectList.CreateStringObjects(data.targetImageProcessed)){
                Text("Predict Strings")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity)
            
            Button(action: stringObjectList.CreateStringObjects(data.targetImageProcessed)){
                Text("Modify PSD")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity)

            
//            Button(action: CreateTrackingData){
//                Text("Create Tracking Data")
//            }
//            .frame(width: 500, height: 20, alignment: Alignment.center)
        }
        .frame(height: 200.0)
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





