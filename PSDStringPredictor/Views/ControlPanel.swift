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
    
    //var dbvm = DBViewModel()
    let ternimalScriptMgr = TernimalScriptManager()
    @ObservedObject var stringObjectVM: PSDViewModel = psdViewModel
    @ObservedObject var strObjVM = psdViewModel
    @ObservedObject var imageProcessVM = imageProcessViewModel
    @ObservedObject var settingsVM = settingViewModel
    var imgUtil: ImageUtil = ImageUtil()
    var pixelProcess = PixelProcess()
//    var db = DB()
    var training = MLTraining()
    let imagePropertyVM = imagePropertyViewModel
    @Binding var showImage: Bool
    @Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
    let colorModeClassifier = ColorModeClassifier()
    
    var body: some View {

        VStack{
            
            Button(action: {stringObjectVM.CombineStrings()}){
                Text("Combine To Paragraph")
                    .frame(minWidth: 270,  maxWidth: .infinity)
            }
            //HStack{

                Button(action: {stringObjectVM.SetSelectionToFixed()}){
                    Text("Mark Strings as Ready")
                        .frame(minWidth: 270,  maxWidth: .infinity)
                    
                }
                
                Button(action: {stringObjectVM.SetSelectionToIgnored()}){
                    Text("Mark Strings as Ignore")
                        .frame(minWidth: 270,  maxWidth: .infinity)
                }
            //}

            Divider()
            
            Text("Calculate String Layers")
                .foregroundColor(.gray)
                .padding(.top)
                .frame(width: 300, alignment: .leading)
            
            HStack{
                Button(action: {self.stringObjectVM.ProcessOnePSD()}){
                    Text("Current File")
                        .frame(minWidth: 200,  maxWidth: .infinity)
                }
                //.disabled(!self.stringObjectVM.OKForProcess)
                
                Button(action: {self.stringObjectVM.ProcessOnePSD()}){
                    Text("All")
                        .frame(minWidth: 40,  maxWidth: .infinity)
                }
                .disabled(true)
                
            }
            .frame( maxWidth: .infinity)
            
            Text("Create PSD")
                .foregroundColor(.gray)
                .padding(.top)
                .frame(width: 300, alignment: .leading)
            HStack{
                Button(action: {self.stringObjectVM.CreatePSD()}){
                    Text("Current File")
                        .frame(minWidth: 200,  maxWidth: .infinity)
                }
                //.disabled(!self.stringObjectVM.OKForProcess)
                
                Button(action: {self.stringObjectVM.CreatePSD()}){
                    Text("All")
                        .frame(minWidth: 40,  maxWidth: .infinity)
                }
                .disabled(true)
            }
            .frame( maxWidth: .infinity)
            .padding(.bottom)
            .padding(.bottom)
            
//            Button(action: {self.Debug()}){
//                Text("Test")
//                    .frame(minWidth: 200,  maxWidth: .infinity)
//
//            }
        }
        .padding()
        
    }

    func Debug(){
        //stringObjectVM.CombineStrings()
//        let url = URL.init(fileURLWithPath: "/Users/ipdesign/Downloads/PLK_LocoIthildin_TransporterRRU_MRH_O1_201201/Source/ITC_All_TransporterAppHelp_1_2-11/en/OTT/GlobalArt/options_button.psd")
//        var imageData: NSData =  NSData.init()
//        do{
//        try imageData = NSData.init(contentsOf: url)
//        }catch{}
//        guard let imageSource = CGImageSourceCreateWithData(imageData, nil),
//                    let metaData = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
//                    let dpi = metaData["DPIWidth"] as? Int else {
//                        return
//                }
//
//         print(dpi)
       
//        let properties: [String: Any] = imageProcessVM.targetCIImage.properties
//        print(imageProcessVM.targetCIImage.extent)
//        let exif = properties["{Exif}"] as! [String: Any]
//        print(exif)
        //stringObjectVM.indicatorTitle = "Heyhey"
        //imageProcessVM.indicatorTitle = "ttest"
        //imageProcessVM.indicatorTitle += "ttest"
        //        pixelProcess.FindStrongestColor(img: imageProcessVM.targetCIImage)
        //        imageProcessVM.FetchImage()
        //        let tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(imageProcessVM.targetImageProcessed), PositionX: 175, PositionY: 184, Width: 3, Height: 3, MaskColor: .red)
        //        imageProcessVM.SetTargetProcessedImage(tmpImg)
    }
    
}





