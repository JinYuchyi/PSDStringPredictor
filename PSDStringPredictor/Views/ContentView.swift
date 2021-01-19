//
//  ContentView.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreImage
import AppKit

struct ContentView: View  {
    
    //    @ObservedObject var stringObjectList = StringObjectList()
    //    @ObservedObject var imageProcess: ImageProcess = ImageProcess()
    //    @ObservedObject  var db = DBVideoModel()
    //    @State private var ocr =  OCR()
    //
    //    @EnvironmentObject var data: DataStore
    let data = DataStore()
    let font = FontUtils()
    @ObservedObject var imageViewModel = imageProcessViewModel
    @ObservedObject var stringObjectVM = psdViewModel
    @ObservedObject var psdsVM: PsdsVM
    @ObservedObject var imgVM: ImageVM
    //@ObservedObject var controlVM: ControlVM = ControlVM()
    let pixelProcess = PixelProcess()
    let imgUtil = ImageUtil()
    let keyEventHandle = KeyEventHandling()
    @State var showImage = false
    @State var showPatchLayer = false
    //@State var showDebugOverlay = true
    @State private var showPredictString = true
    @State private var showDebugOverlay = true
    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    @State var viewScale: CGFloat = 1
    
    
    fileprivate func LeftViewGroup() -> some View {
       // VStack{
//            Button(action: {imageProcessViewModel.LoadImageBtnPressed()}){
//                Text("Load Image")
//                //.frame(minWidth: 250,  maxWidth: .infinity)
//            }e
//            .frame(width: 300, alignment: .center)
//            .padding()
//
//            Divider()
            
//            psdPagesView()
//                .frame(width: 300, alignment: .center)
        //}
        VStack(alignment: .center){
            PrograssView(psdsVM: psdsVM)
            psdThumbnailList(psdsVM: psdsVM)
                .frame(height: 1000, alignment: .center)
            PsdOperatorView(psdsVM: psdsVM)
                .padding()
        }
        
        //.frame(width: 300, alignment: .center)
    }
    
    fileprivate func MidViewGroup() -> some View {
        return ZStack{
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                ZStack{
                    ImageView(psds: psdsVM)

                    LabelsOnImage(psdsVM: psdsVM)

                    CharacterFrameView(psdVM: psdsVM)
                        .IsHidden(condition: showPatchLayer)
                    
                    HighlightView(psdsVM: psdsVM)
                }
                //.scaleEffect(viewScale)
                //.frame(width: 1100 * viewScale)

            }
            
            GeometryReader{ geo in
                UIOverlayView(showPatchLayer: $showPatchLayer)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
//                ScaleSliderView(scale: $viewScale)
//                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomTrailing)
            }
            
//            IndicatorView( psdsVM: psdsVM)
//                .frame(width: 1100, height: 1000, alignment: .center)
            WarningView()
                //.frame(width: 1100, height: 1000, alignment: .center)
                
        }
        
        //.frame(width: 1100)
    }
    
    fileprivate func RightViewGroup() -> some View {
        return VStack{

            //Divider()
            
            ImageProcessView(psdsVM: psdsVM)
                //.padding(.top, 20.0)
            
            Divider()
            
            ImagePropertyView(psdvm: psdsVM)
                .frame(height: 100)

                //.frame(width: 300, height: 150)
            
            Divider()
            
            StringObjectPropertyView( psdsVM: psdsVM)
                //.frame(width: 300)
            
            Divider()
            
            ControlPanel(psdsVM: psdsVM)

            
        }
        
    }
    
    
    var body: some View {
       
            HStack(alignment: .center){
                LeftViewGroup()
                    .frame(width: 300)
                    //.border(Color.red, width: 1)
                Divider()
                
                MidViewGroup()
                    .frame(width: 1200)
                    //.border(Color.red, width: 1)
                Divider()
                RightViewGroup()
                    .frame(width: 300)
                    //.border(Color.red, width: 1)
            }
            .background(keyEventHandle)

      
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










