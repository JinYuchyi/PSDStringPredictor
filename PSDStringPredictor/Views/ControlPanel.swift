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
    //@ObservedObject var stringObjectVM: PSDViewModel = psdViewModel
    //@ObservedObject var strObjVM = psdViewModel
    @ObservedObject var imageProcessVM : ImageProcess
    @ObservedObject var settingsVM: SettingViewModel
    var imgUtil: ImageUtil = ImageUtil()
    //    var pixelProcess = PixelProcess()
    //    var db = DB()
    var training = MLTraining()
    //    let imagePropertyVM = imagePropertyViewModel
    //@Binding var showImage: Bool
    //@Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
    //  let colorModeClassifier = ColorModeClassifier()
    
    //let controlVM = ControlVM()
    @ObservedObject var psdsVM: PsdsVM
    @ObservedObject var regionProcessVM: RegionProcessVM
    
    var panelWidth: CGFloat
    //Constant
    
    var body: some View {
        //        padding(.top)
        Text("Operation on Selected").foregroundColor(.gray).frame(width: panelWidth, alignment:.leading).foregroundColor(.gray)
        Divider()
        
        GeometryReader{geo in
            VStack(alignment: .center){
                
//                Button(action: {psdsVM.CombineStringsOnePSD(psdId: psdsVM.selectedPsdId)}){
//                    Text("Combine To Paragraph")
//                        .frame(width: geo.size.width*0.8, alignment: .center)
//
//                }
                
                
                
                
//                HStack{
//                    Button(action: {psdsVM.SetSelectionToFixed()}){
//                        Text("Ready")
//                            .frame(minWidth: geo.size.width*0.36,  maxWidth: .infinity)
//                            .padding(0)
//
//                    }
//
//                    Button(action: {psdsVM.SetSelectionToIgnored()}){
//                        Text("Ignore")
//                            .frame(minWidth: geo.size.width*0.36,  maxWidth: .infinity)
//                            .padding(0)
//
//                    }
//
//                }

                HStack{
                    Button(action: {psdsVM.alignSelection(orientation: "horizontal-left")}){
                        Image("HAlignLeft")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        //                                        Text("􀌀")
                        //                                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    Button(action: { psdsVM.alignSelection(orientation: "horizontal-center") }){
                        Image("HAlignCenter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    Button(action: { psdsVM.alignSelection(orientation: "horizontal-right") }){
                        Image("HAlignRight")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                
              
                    Button(action: {psdsVM.alignSelection(orientation: "vertical-top") }){
                        Image("VAlignTop")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    }
                    
                    Button(action: {psdsVM.alignSelection(orientation: "vertical-center") }){
                        Image("VAlignCenter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    Button(action: { psdsVM.alignSelection(orientation: "vertical-bott0m")}){
                        Image("VAlignBottom")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
      
                
                Spacer()
                
                Text("Calculate String Layers")
                    .foregroundColor(.gray)
                    .padding(.top)
                    .frame(width: geo.size.width*0.8, alignment: .leading)
                
                HStack{
                    Button(action: {psdsVM.ProcessForOnePsd()}){
                        Text("One")
                            .frame(minWidth: 70,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                    
                    Button(action: {regionProcessVM.regionBtnPressed(); psdsVM.canProcess = true}){
                        Text("Region")
                            .frame(minWidth: 70,  maxWidth: .infinity)
                    }
                    .colorMultiply(regionProcessVM.regionActive == true ? Color.green : Color.white)
                    .disabled(psdsVM.IndicatorText != "")
                    
                    Button(action: {psdsVM.ProcessForAll()}){
                        Text("Committed")
                            .frame(minWidth: 50,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                    
                }
                .frame( maxWidth: .infinity)
                
                Text("Create PSD")
                    .foregroundColor(.gray)
                    //.padding(.top)
                    .frame(width: geo.size.width*0.8, alignment: .leading)
                HStack{
                    Button(action: {psdsVM.CreatePSDForOnePSD(_id: psdsVM.selectedPsdId, saveToPath: "" )}){
                        Text("One")
                            .frame(minWidth: 165,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                    
                    Button(action: {psdsVM.CreatePSDForCommited()}){
                        Text("Committed")
                            .frame(minWidth: 50,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                }
                //.frame( maxWidth: .infinity)
                .padding(.bottom)
                //.padding(.bottom)
                
                
                //                Button(action: {Debug()}){
                //                    Text("Debug")
                //                        .frame(minWidth: 50,  maxWidth: .infinity)
                //                }
            }
            
        }
        
        
    }
    
    func Debug(){
        var symbolPredict =  SymbolsPredict()
        symbolPredict.Prediction(ciImage: psdsVM.selectedNSImage.ToCIImage()!)
        //        print (symbolPredict.)
    }
    
}





