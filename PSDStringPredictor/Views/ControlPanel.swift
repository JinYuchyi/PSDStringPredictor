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
    //@Binding var showImage: Bool
    //@Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
  //  let colorModeClassifier = ColorModeClassifier()
    
    //let controlVM = ControlVM()
    let psdsVM: PsdsVM
    
    var body: some View {
        GeometryReader{geo in
//            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//                    .frame(width: geo.size.width * 0.8, alignment: .center)
//            })
//            .frame(width: geo.size.width, alignment: .center)
            VStack(alignment: .center){
                Button(action: {stringObjectVM.CombineStringsOnePSD(psdId: stringObjectVM.selectedPSDID)}){
                    Text("Combine To Paragraph")
                        .frame(width: geo.size.width*0.8, alignment: .center)
                }

//                Text("Align Selection").foregroundColor(.gray).frame(width: geo.size.width * 0.8,alignment:.leading)
//                HStack{
//                    Button(action: {stringObjectVM.CombineStringsOnePSD(psdId: stringObjectVM.selectedPSDID)}){
//                        Text("Left")
//                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    }
//                    Button(action: {stringObjectVM.CombineStringsOnePSD(psdId: stringObjectVM.selectedPSDID)}){
//                        Text("Center")
//                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    }
//                    Button(action: {stringObjectVM.CombineStringsOnePSD(psdId: stringObjectVM.selectedPSDID)}){
//                        Text("Right")
//                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    }
//                }

                //HStack{
                Text("Set Selection Status").foregroundColor(.gray).frame(width: geo.size.width * 0.8,alignment:.leading)
                HStack{
                    Button(action: {psdsVM.SetSelectionToFixed()}){
                            Text("Ready")
                                .frame(minWidth: geo.size.width*0.36,  maxWidth: .infinity)

                        }

                    Button(action: {psdsVM.SetSelectionToIgnored()}){
                            Text("Ignore")
                                .frame(minWidth: geo.size.width*0.36,  maxWidth: .infinity)
                        }
                }

                //}

                //Divider()

                Spacer()
                
                Text("Calculate String Layers")
                    .foregroundColor(.gray)
                    .padding(.top)
                    .frame(width: geo.size.width*0.8, alignment: .leading)

                HStack{
                    Button(action: {psdsVM.ProcessForOnePsd()}){
                        Text("Current File")
                            .frame(minWidth: 110,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")

                    Button(action: {psdsVM.ProcessForAll()}){
                        Text("All Commited Files")
                            .frame(minWidth: 110,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")

                }
                .frame( maxWidth: .infinity)

                Text("Create PSD")
                    .foregroundColor(.gray)
                    //.padding(.top)
                    .frame(width: geo.size.width*0.8, alignment: .leading)
                HStack{
                    Button(action: {psdsVM.CreatePSDForOnePSD(_id: psdsVM.selectedPsdId, saveToPath: "")}){
                        Text("Current File")
                            .frame(minWidth: 110,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")

                    Button(action: {psdsVM.CreatePSDForAll()}){
                        Text("All Commited Files")
                            .frame(minWidth: 110,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                }
                //.frame( maxWidth: .infinity)
                .padding(.bottom)
                //.padding(.bottom)

            }

        }
        
        
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





