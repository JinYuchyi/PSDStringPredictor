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
    
    @State var selectedStringObject: StringObject = StringObject.init()
    
    let data = DataStore()
    let font = FontUtils()
    @ObservedObject var imageViewModel: ImageProcess
    @ObservedObject var psdsVM: PsdsVM
    @ObservedObject var regionProcessVM: RegionProcessVM = RegionProcessVM()
    @ObservedObject var interactive = InteractiveViewModel()
    @ObservedObject var settingVM : SettingViewModel
    
    @State var width: CGFloat = 0
    //    @ObservedObject var imgVM: ImageVM
    
    //    let pixelProcess = PixelProcess()
    let imgUtil = ImageUtil()
    let keyEventHandle = KeyEventHandling()
    
    @State var showImage = false
    @State var showPatchLayer = false
    //@State var showDebugOverlay = true
    @State private var showPredictString = true
    @State private var showDebugOverlay = true
    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    @State var showFakeString: Bool = false
    
    fileprivate func LeftViewGroup() -> some View {
        
        VStack(alignment: .center){
            //PrograssView(psdsVM: psdsVM)
            psdThumbnailList(psdsVM: psdsVM, showPatchLayer: $showPatchLayer)
                .frame(height: 1000, alignment: .center)
            PsdOperatorView(psdsVM: psdsVM)
                .padding()
        }
        
    }
    
    var MidViewGroup: some View {
        ZStack{
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                //                                    GeometryReader{geo in
                
                ZStack{
                    Color.white.frame(width: psdsVM.selectedNSImage.size.width * psdsVM.viewScale, height: psdsVM.selectedNSImage.size.height * psdsVM.viewScale).opacity(0.01)
                    
                    ImageView(psds: psdsVM, regionVM: regionProcessVM, interactive: interactive)
                        .scaleEffect(psdsVM.viewScale)
  
                    Group{
                        
                        LabelsOnImage(psdsVM: psdsVM, showFakeString: $showFakeString)
                            .frame(width: psdsVM.selectedNSImage.size.width, height: psdsVM.selectedNSImage.size.height)

                        CharacterFrameView(psdVM: psdsVM)
                            .IsHidden(condition: showPatchLayer)
                        
                        StringHighlightView(psdsVM: psdsVM, showFakeString: $showFakeString)
                            .frame(width: psdsVM.selectedNSImage.size.width, height: psdsVM.selectedNSImage.size.height)
                        
                    }
                    .IsHidden(condition: psdsVM.stringIsOn == true)
                    .scaleEffect(psdsVM.viewScale)

                }

            }

            GeometryReader{ geo in
                UIOverlayView(showPatchLayer: $showPatchLayer)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                
                ScaleSliderView(psdsVM: psdsVM)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomTrailing)

                if #available(OSX 11.0, *) {
                    VStack(spacing: 0){
                        Text(psdsVM.IndicatorText)
                            .background(Color.black.opacity(0.3))
                        HStack{
                            
                            ProgressView(value: psdsVM.prograssScale)
                            Button(action: {abortProcess()}, label: {
                                Text("Abort")
                            })
                            .background(Color.black.opacity(0.5))
                        }
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                }
                
            }
            
        }

    }
    
    fileprivate func RightViewGroup() -> some View {
        return VStack{

            ImageProcessView(psdsVM: psdsVM)
            
            Divider()
            
            StringObjectPropertyView( psdsVM: psdsVM )
            
            Divider()
            
            Spacer()
            ControlPanel(imageProcessVM: imageViewModel, settingsVM: settingVM, psdsVM: psdsVM, regionProcessVM: regionProcessVM)
            
            
        }
        
    }
    
    
    var body: some View {
        
        HStack(alignment: .center){
            LeftViewGroup()
                .frame(width: 300)
            //.border(Color.red, width: 1)
            Divider()
            
            MidViewGroup
                .frame(width: 1200)

            Divider()
            RightViewGroup()
                .frame(width: 300)
            
            //.border(Color.red, width: 1)
        }
        .onAppear(perform: {
            //Load tables
            psdsVM.FetchTrackingData(path: Bundle.main.path(forResource: "FontSizeTrackingTable", ofType: "csv")!)
            //psdsVM.FetchStandardTable(path: Bundle.main.path(forResource: "fontSize", ofType: "csv")!)
            psdsVM.FetchCharacterTable(path: Bundle.main.path(forResource: "fontSize", ofType: "csv")!)
            psdsVM.FetchBoundTable(path: Bundle.main.path(forResource: "charBounds", ofType: "csv")!)
        })
        .preferredColorScheme(.dark)
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
    
    func abortProcess(){
        psdsVM.canProcess = false
    }
    
    
    
    
}



//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ContentView()
//            .frame(width: 1500, height: 1000 )
//    }
//}










