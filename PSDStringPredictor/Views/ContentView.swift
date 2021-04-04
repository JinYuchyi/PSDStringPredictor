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

let zeroUUID: UUID = UUID.init()

struct ContentView: View  {

//    let font = FontUtils.shared
//    let imgUtil = ImageUtil.shared

    @ObservedObject var imageViewModel: ImageProcess
    @ObservedObject var psdsVM: PsdsVM
    @ObservedObject var regionProcessVM: RegionProcessVM = RegionProcessVM()
    @ObservedObject var interactive = InteractiveViewModel()
    @ObservedObject var settingVM : SettingViewModel

//    @State var showImage = false
    @State var showPatchLayer = false
    //@State var showDebugOverlay = true
//    @State private var showPredictString = true
//    @State private var showDebugOverlay = true
//    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    @State var showFakeString: UUID = zeroUUID
    
    //Constant
    var screenSize: NSRect? = NSScreen.main?.visibleFrame
    let leftPanelWidth: CGFloat = 300
    let rightPanelWidth: CGFloat = 300
    
    fileprivate func LeftViewGroup() -> some View {
        
        VStack(alignment: .center){
            //PrograssView(psdsVM: psdsVM)
            psdThumbnailList(psdsVM: psdsVM, interactive: interactive, showPatchLayer: $showPatchLayer)
                .padding(.top)
//                .frame(height: screenSize!.height * 0.9, alignment: .top)
            PsdOperatorView(psdsVM: psdsVM)
                .frame(height: 30, alignment: .bottom)
                .padding()
        }
    }
    
    var MidViewGroup: some View {
        ZStack{
            //            keyEventHandle
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                //                                    GeometryReader{geo in
                
                ZStack{
                    Color.gray.frame(width: psdsVM.fetchSelectedPsd().width * psdsVM.viewScale, height: psdsVM.fetchSelectedPsd().height * psdsVM.viewScale).opacity(0.1)
                    //                    Color.white.frame(width: psdsVM.selectedNSImage.size.width , height: psdsVM.selectedNSImage.size.height ).opacity(0.01)
                    
                    ImageView(psds: psdsVM, regionVM: regionProcessVM, interactive: interactive)
                        .scaleEffect(psdsVM.viewScale)
                    Group{

                        LabelsOnImage(psdsVM: psdsVM, interactive: interactive, showFakeString: $showFakeString)
                            .frame(width: psdsVM.fetchSelectedPsd().width, height: psdsVM.fetchSelectedPsd().height)
                        
//                        CharacterFrameView(psdVM: psdsVM)
//                            .IsHidden(condition: showPatchLayer)
                        
                        StringHighlightView(interactive: interactive, psdsVM: psdsVM, showFakeString: $showFakeString)
                            .frame(width: psdsVM.fetchSelectedPsd().width, height: psdsVM.fetchSelectedPsd().height)
                        
                    }
                    .IsHidden(condition: psdsVM.stringIsOn == true)
                    .scaleEffect(psdsVM.viewScale)
                    
                    
                }
                
            }
            
            GeometryReader{ geo in
                UIOverlayView(psdsVM: psdsVM)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                
                ScaleSliderView(psdsVM: psdsVM)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomTrailing)
                
                //Prograss Bar
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
                            .padding(.horizontal)
                        }
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                    .IsHidden(condition: psdsVM.IndicatorText != "")
                }
                
            }
//            testView()
            //Popup Window
            charDSView(psdsVM: psdsVM)
        }
        
    }
    
    fileprivate func RightViewGroup() -> some View {
        return VStack{
            
            ImageProcessView(psdsVM: psdsVM, panelWidth: rightPanelWidth)
//
            Divider()
//
            StringObjectPropertyView( panelWidth: rightPanelWidth, psdsVM: psdsVM, settingVM: settingVM  )
                .padding()
                .IsHidden(condition: psdsVM.selectedStrIDList.count > 0)
            
            Divider()
            
            Spacer()
            ControlPanel(imageProcessVM: imageViewModel, interactive: interactive, settingsVM: settingVM, psdsVM: psdsVM, regionProcessVM: regionProcessVM, panelWidth: rightPanelWidth)
            
        }
        .frame(width: rightPanelWidth)
        //        .padding()
        //        .ignoresSafeArea()
        //        .border(Color.red, width: 2)
        
    }
    
    
    
    
    
    
    
    var body: some View {
        //
        //        Rectangle()
        //            .frame(width: screenSize?.width, height: screenSize?.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        HStack(alignment: .center, spacing: 0){
            LeftViewGroup()
                .frame(width: leftPanelWidth )
            //.border(Color.red, width: 1)
            Divider()

            MidViewGroup
                .frame(width: screenSize!.width - leftPanelWidth - rightPanelWidth)

            Divider()
            RightViewGroup()
                .frame(width: rightPanelWidth)
            
        }
        .onAppear(perform: {
            //Load tables
            psdsVM.FetchTrackingData(path: Bundle.main.path(forResource: "FontSizeTrackingTable", ofType: "csv")!)
            psdsVM.FetchCharacterTable(path: Bundle.main.path(forResource: "fontSize", ofType: "csv")!)
            psdsVM.FetchBoundTable(path: Bundle.main.path(forResource: "charBounds", ofType: "csv")!)
            DataStore.frontSpaceDict = CSVManager.shared.ParsingCsvFileAsFrontSpace(FilePath: Bundle.main.path(forResource: "frontspace", ofType: "csv")!)
            DataStore.charOffsetInFront = CSVManager.shared.ParsingCsvFileAsCharFrontOffset(FilePath: Bundle.main.path(forResource: "charOffsetInFront", ofType: "csv")!)
        })
        .preferredColorScheme(.dark)
        
        
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










