//
//  ContentView.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreImage

struct ContentView: View {
    
    //    @ObservedObject var stringObjectList = StringObjectList()
    //    @ObservedObject var imageProcess: ImageProcess = ImageProcess()
    //    @ObservedObject  var db = DBVideoModel()
    //    @State private var ocr =  OCR()
    //
    //    @EnvironmentObject var data: DataStore
    let data = DataStore()
    let font = FontUtils()
    @ObservedObject var imageViewModel = imageProcessViewModel
    @ObservedObject var stringObjectVM = stringObjectViewModel
    let pixelProcess = PixelProcess()
    let imgUtil = ImageUtil()
    @State var showImage = false
    //@State var showDebugOverlay = true
    @State private var showPredictString = true
    @State private var showDebugOverlay = true
    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    
    //var sta = CSVManager.shared.ParsingCsvFileAsTrackingObjectArray
    
    
    
    fileprivate func LeftViewGroup() -> some View {
        VStack{
            Button(action: {imageProcessViewModel.LoadImageBtnPressed()}){
                Text("Load Image")
                //.frame(minWidth: 250,  maxWidth: .infinity)
            }
            .frame(width: 300, alignment: .center)
            .padding()
            
            Divider()
            
            psdPagesView()
                .frame(width: 300, alignment: .center)
        }
    }
    
    fileprivate func MidViewGroup() -> some View {
        return ZStack{
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                ZStack{
                    ImageView(imageViewModel:imageViewModel)
                    LabelsOnImage( charFrameList: stringObjectVM.charFrameListData)
                        .IsHidden(condition: stringObjectVM.stringOverlay)
                }
            }
            
            //            VStack(alignment: .trailing){
            //                Toggle(isOn: $showPredictString) {
            //                    Text("String Layer").shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0.1, y: -0.1)
            //                }
            //                Toggle(isOn: $showDebugOverlay) {
            //                    Text("Debug Overlay").shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0.1, y: -0.1)
            //                }
            //                .frame(width: 1000, height: 950, alignment: .topTrailing)
            //            }
            IndicatorView()
                .frame(height: 1000, alignment: .center)
            WarningView()
                .frame(height: 1000, alignment: .center)
                
        }
        .frame(width: 1100)
    }
    
    fileprivate func RightViewGroup() -> some View {
        return VStack{
            
            
            
            //Divider()
            
            ImageProcessView(imageViewModel: imageViewModel)
                .padding(.top, 20.0)
            
            Divider()
            
            ImagePropertyView()
                .frame(width: 300, height: 150)
            
            Divider()
            
            StringObjectPropertyView()
                .frame(width: 300)
            
            Divider()
            
            ControlPanel(showImage: $showImage)
            
            //            Button(action: {self.Debug()}){
            //                Text("Debug")
            //            }
            
        }
        
    }
    
    
    var body: some View {
       
            HStack(alignment: .center){
                LeftViewGroup()
                Divider()
                
                MidViewGroup()
                Divider()
                RightViewGroup()
            }

      
    }
    
    func Debug(){
        //        imageViewModel.FetchImage()
        //        let tmpImg = self.imgUtil.AddRectangleMask(BGImage: &(imageViewModel.targetImageProcessed), PositionX: 175, PositionY: 184, Width: 10, Height: 10, MaskColor: CIColor.red)
        //        imageViewModel.SetTargetProcessedImage(tmpImg)
        let rect = CGRect.init(x: 10, y: 10, width: 100, height: 100)
        let testImg = imageViewModel.targetImageProcessed.cropped(to: rect)
        print("\(rect)")
        print("\(testImg.extent)")
    }
    
    
    
    
}



//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ContentView()
//            .frame(width: 1500, height: 1000 )
//    }
//}










