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
    @ObservedObject var imageProcessVM = imageProcessViewModel
    var imgUtil: ImageUtil = ImageUtil()
    var pixelProcess = PixelProcess()
    var db = DB()
    var training = MLTraining()
    let imagePropertyVM = imagePropertyViewModel
    @Binding var showImage: Bool
    @Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
    let colorModeClassifier = ColorModeClassifier()
    
    var body: some View {
        
        
        
        VStack{
            
            
            
            Text("Caculate String Layers")
                .foregroundColor(.gray)
                .padding(.top)
                .frame(width: 300, alignment: .leading)
            
            HStack{
                Button(action: {self.stringObjectVM.PredictStrings()}){
                    Text("Single Page")
                        .frame(minWidth: 200,  maxWidth: .infinity)
                }
                Button(action: {self.stringObjectVM.PredictStrings()}){
                    Text("All")
                        .frame(minWidth: 40,  maxWidth: .infinity)
                }
            }
            .frame( maxWidth: .infinity)
            
            Text("Create PSD")
                .foregroundColor(.gray)
                .padding(.top)
                .frame(width: 300, alignment: .leading)
            HStack{
                Button(action: {self.stringObjectVM.CreatePSD()}){
                    Text("Single Page")
                        .frame(minWidth: 200,  maxWidth: .infinity)
                    
                }
                Button(action: {self.stringObjectVM.CreatePSD()}){
                    Text("All")
                        .frame(minWidth: 40,  maxWidth: .infinity)
                    
                }
            }
            .frame( maxWidth: .infinity)
            .padding(.bottom)
            .padding(.bottom)
            
            Button(action: {self.Debug()}){
                Text("Test")
                    .frame(minWidth: 200,  maxWidth: .infinity)
                
            }
        }
        .padding()
        
    }
    
    
    
    
    func Debug(){
        for c in DataStore.colorLightModeList{
            let color = NSColor(red: c[0]/255, green: c[1]/255, blue: c[2]/255, alpha: 1)
            print("\(color.getHSV())")
            
        }
        //        pixelProcess.FindStrongestColor(img: imageProcessVM.targetCIImage)
        //        imageProcessVM.FetchImage()
        //        let tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(imageProcessVM.targetImageProcessed), PositionX: 175, PositionY: 184, Width: 3, Height: 3, MaskColor: .red)
        //        imageProcessVM.SetTargetProcessedImage(tmpImg)
    }
    
}





