//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ControlPanel: View {
    
    var dbvm = DBViewModel()
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    //@ObservedObject var loglist: LogListData
    //@ObservedObject var db: DB = DB()
    //@ObservedObject var ocr: OCR = OCR()
    //@ObservedObject var stringObjectList: StringObjectList  = StringObjectList()
    var imageProcess: ImageProcess  = imageProcessViewModel
    //@ObservedObject var data: DataStore


    
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

            
            Button(action: {self.dbvm.ConnectDB()}){
                Text("Connect Database")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
   
            Button(action: {self.stringObjectVM.PredictStrings()}){
                Text("Predict Strings")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity)
            
            Button(action: {self.stringObjectVM.PredictStrings()}){
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





