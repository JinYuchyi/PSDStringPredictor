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
    
    var body: some View {
        GeometryReader{geo in
            //            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            //                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            //                    .frame(width: geo.size.width * 0.8, alignment: .center)
            //            })
            //            .frame(width: geo.size.width, alignment: .center)
            VStack(alignment: .center){
                Button(action: {psdsVM.CombineStringsOnePSD(psdId: psdsVM.selectedPsdId)}){
                    Text("Combine To Paragraph")
                        .frame(width: geo.size.width*0.8, alignment: .center)
                }
                
                
                
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
                //                Text("Align Selection").foregroundColor(.gray).frame(width: geo.size.width * 0.8,alignment:.leading)
                                HStack{
                                    Button(action: {}){
                                        Text("􀌀")
                                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    }
                                    Button(action: { }){
                                        Text("􀌁")
                                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    }
                                    Button(action: { }){
                                        Text("􀌂")
                                            .frame(minWidth: geo.size.width*0.21, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                    Button(action: {psdsVM.CreatePSDForOnePSD(_id: psdsVM.selectedPsdId, saveToPath: "")}){
                        Text("One")
                            .frame(minWidth: 165,  maxWidth: .infinity)
                    }
                    .disabled(psdsVM.IndicatorText != "")
                    
                    Button(action: {psdsVM.CreatePSDForAll()}){
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





