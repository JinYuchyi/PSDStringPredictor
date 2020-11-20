//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreData

struct ControlPanel: View {
    
    var dbvm = DBViewModel()
    let ternimalScriptMgr = TernimalScriptManager()
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    @ObservedObject var strObjVM = stringObjectViewModel
    //@ObservedObject var loglist: LogListData
    //@ObservedObject var db: DB = DB()
    //@ObservedObject var ocr: OCR = OCR()
    //@ObservedObject var stringObjectList: StringObjectList  = StringObjectList()
    var imageProcess: ImageProcess  = imageProcessViewModel
    var imgUtil: ImageUtil = ImageUtil()
    var pixelProcess = PixelProcess()
    var db = DB()
    var training = MLTraining()
    let imagePropertyVM = imagePropertyViewModel
    //@ObservedObject var data: DataStore
    @Binding var showImage: Bool
    @Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
    let colorModeClassifier = ColorModeClassifier()
    
    var body: some View {
        VStack{
            Button(action: {self.LoadImageBtnPressed()}){
                Text("Load Image")
                .frame(minWidth: 200, maxWidth: .infinity)
            }.padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ReloadStandardTable()}){
                Text("Reload Standard Table")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ReloadCharacterTable()}){
                Text("Reload Size Table")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ReloadFontTable()}){
                Text("Reload Tracking Table")
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
                Text("Create PSD")
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
                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "PNG" || panel.url?.pathExtension == "psd") )
                {
                    let tmp = LoadNSImage(imageUrlPath: panel.url!.path)
                    self.imageProcess.SetTargetNSImage(tmp)
                    self.showImage = true
                    
                    colorModeClassifier.Prediction(fromImage: DataStore.targetImageProcessed)
                    self.imagePropertyVM.SetImageColorMode(modeIndex: DataStore.colorMode)
                }
            }
        }

    }

    func Debug(){

//        let panel = NSOpenPanel()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let result = panel.runModal()
//            if result == .OK{
////                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
////                {
//                    let tempImg = LoadNSImage(imageUrlPath: panel.url!.path)
//                    let cgI = tempImg.ToCGImage()
//                let colorList = pixelProcess.LoadALineColors(FromImage: cgI!, Index: cgI!.width-1, IsForRow: false)
//                    let hasDifColor = pixelProcess.HasDifferentColor(ColorArray: colorList, Threshhold: 0.1)
//                    print(hasDifColor)
//                    for item in colorList {
//                        print(item.ToGrayScale())
//                    }
////                }
//            }
//
//        }
        
        let cmd = "open /Users/ipdesign/Documents/Development/PSDStringPredictor/PSDStringPredictor/AdobeScripts/StringCreator.jsx  -a '/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app'"
        PythonScriptManager.RunScript(str: cmd)
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





