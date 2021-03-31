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
    @ObservedObject var interactive : InteractiveViewModel
    @ObservedObject var settingsVM: SettingViewModel
    var imgUtil: ImageUtil = ImageUtil.shared
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
    
    var calculationBtns: some View {
        HStack{
            Button(action: {psdsVM.ProcessForOnePsd()}){
                Text("One")
                    .frame(minWidth: 70,  maxWidth: .infinity)
            }
            .disabled(psdsVM.IndicatorText != "")
            
            Button(action: {regionProcessVM.regionBtnPressed(); psdsVM.canProcess = true; interactive.selectionRect = zeroRect}){
                Text("Region")
                    .frame(minWidth: 70,  maxWidth: .infinity)
            }
            .colorMultiply(regionProcessVM.regionButtonActive == true ? Color.green : Color.white)
            .disabled(psdsVM.IndicatorText != "")
            
            Button(action: {psdsVM.ProcessForAll()}){
                Text("Committed")
                    .frame(minWidth: 50,  maxWidth: .infinity)
            }
            .disabled(psdsVM.IndicatorText != "")
            
        }
        .frame( maxWidth: .infinity)
    }
    
    var createPSDButtons: some View  {
        HStack{
            Button(action: {psdsVM.createPSDForOne()}){
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
    }
    
    var alignmentButtons: some View  {
        VStack{
        HStack{
            Button(action: {psdsVM.alignSelection(orientation: "horizontal-left")}){
//                Image("HAlignLeft")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 65, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Set Left")
                    .frame(width: 65, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Button(action: { psdsVM.alignSelection(orientation: "horizontal-center") }){
                Text("Set Center")
                    .frame(width: 65, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Button(action: { psdsVM.alignSelection(orientation: "horizontal-right") }){
                Text("Set Right")
                    .frame(width: 65, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            
//            Button(action: {psdsVM.alignSelection(orientation: "vertical-top") }){
//                Image("VAlignTop")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//
//            }
//
//            Button(action: {psdsVM.alignSelection(orientation: "vertical-center") }){
//                Image("VAlignCenter")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            }
//            Button(action: { psdsVM.alignSelection(orientation: "vertical-bott0m")}){
//                Image("VAlignBottom")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            }
        }
        HStack{
            Button(action: {psdsVM.moveAndAlignToLeft()}, label: {
                Text("|􀄪")
                    .frame(width: 110, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            })
        
            
            Button(action: {psdsVM.moveAndAlignToRight()}, label: {
                Text("􀄫|")
                    .frame(width: 110, height: 15,  alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            })
        }
        }
    }
    
    var body: some View {
        //        padding(.top)

        Text("Operation on Selected").foregroundColor(.gray).frame(width: panelWidth, alignment:.leading).foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.top)
            .frame(width: panelWidth, alignment: .leading)
            .foregroundColor(.gray)
        
        Divider()
        
//        GeometryReader{geo in
            VStack(alignment: .center){
                
                
                Button(action: {psdsVM.deleteSelectedStringObjects()}){
                    Text("Delete Selected Strings")
                        .frame(width: 240)
                }
                
                
                alignmentButtons
                
                Divider()
                
//                Spacer()
                
                Group{
                                    
                    Text("Calculate String Layers")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top)
                        .frame(width: panelWidth, alignment: .leading)
                    
                    Divider()
                    
                    calculationBtns
                    
                    Divider()
                    
                    Text("Create PSD")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top)
                        .frame(width: panelWidth, alignment: .leading)
                    
                    Divider()
                    
                    createPSDButtons
                    
                    Divider()
                }
            }
            
//        }

//        VStack { Divider().background(Color.gray) }.padding(.horizontal)
        
    }
    
//    func Debug(){
//        var symbolPredict =  SymbolsPredict()
//        symbolPredict.Prediction(ciImage: DataStore.selectedNSImage.ToCIImage()!)
//        //        print (symbolPredict.)
//    }
    
}





