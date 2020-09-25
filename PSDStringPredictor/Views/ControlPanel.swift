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
    var imgUtil: ImageUtil = ImageUtil()
    var pixelProcess = PixelProcess()
    //@ObservedObject var data: DataStore
    @Binding var showImage: Bool


    
    var body: some View {
        VStack{
            Button(action: {self.LoadImageBtnPressed()}){
                Text("Load Image")
                    .frame(minWidth: 200, maxWidth: .infinity)
            }.padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ConnectDB()}){
                Text("Connect Database")
                    .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: {self.ReloadStrTableBtnPressed()}){
                Text("Reload String Table DB")
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

            
            Button(action: {self.Debug()}){
                Text("Debug")
            }
            .frame(width: 500, height: 20, alignment: Alignment.center)
        }
        .frame(height: 200.0)
    }
    
    func LoadImageBtnPressed()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
                {
                    let tmp = NSImage(imageUrlPath: panel.url!.path)
                    self.imageProcess.SetTargetNSImage(tmp)
                    self.showImage = true
                }
            }
        }
    }
    
    func ReloadStrTableBtnPressed()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "csv" ) )
                {
                   //TODO: Reload function
                }
            }
        }
    }
    
    func Debug(){
        let cs = pixelProcess.LoadALineColors(FromImage: imageProcess.targetNSImage.ToCGImage()!, Index: 0,  IsForRow: true)
        for c in cs {
            print(c.ToGrayScale()  )
        }
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





