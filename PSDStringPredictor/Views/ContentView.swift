//
//  ContentView.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

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
    
    @State var showImage = false
    //@State var showDebugOverlay = true
    @State private var showPredictString = true
    @State private var showDebugOverlay = true
    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    
    //var sta = CSVManager.shared.ParsingCsvFileAsTrackingObjectArray
    
    
    
    
    fileprivate func LeftViewGroup() -> some View {
        return VStack{
            //Text(String(self.stringObjectViewModel.countNum))
            ImagePropertyView()
            ControlPanel(showImage: $showImage)
                .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            ImageProcessView(imageViewModel: imageViewModel)
                .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            
            StringObjectListView()
                .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
    }
    
    fileprivate func MidViewGroup() -> some View {
        return ZStack{
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                ZStack{
                    ImageView(imageViewModel:imageViewModel, showImage: $showImage)
                    //.gesture(drag)
                    
                    LabelsOnImage()
                        //.blendMode(.difference)
                        .IsHidden(condition: showPredictString)
                    CharacterFrameListView(frameList: stringObjectVM.charFrameListData, imageViewModel: imageViewModel)
                        .IsHidden(condition: showDebugOverlay)
                }
                
            }
            
            VStack(alignment: .trailing){
                Toggle(isOn: $showPredictString) {
                    Text("String Layer").shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0.1, y: -0.1)
                }
                Toggle(isOn: $showDebugOverlay) {
                    Text("Debug Overlay").shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0.1, y: -0.1)
                }
                .frame(width: 1000, height: 950, alignment: .topTrailing)
            }
        }
        .frame(width: 1100)
    }
    
    fileprivate func RightViewGroup() -> some View {
        StringObjectPropertyView()
            .frame(width: 300)
    }
    
    var body: some View {
        HStack(alignment: .top){
            LeftViewGroup()
            MidViewGroup()
            RightViewGroup()
        }
    }
    
    
    
}



//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ContentView()
//            .frame(width: 1500, height: 1000 )
//    }
//}










