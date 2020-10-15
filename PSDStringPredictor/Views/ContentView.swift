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
    @State private var ShowPredictString = true
    @State var isDragging = false
    @State private var clickPositionOnImage = CGSize.zero
    
    //var sta = CSVManager.shared.ParsingCsvFileAsTrackingObjectArray
    
    

    
    var body: some View {
        HStack(alignment: .top){
//            Button(action: {
//                self.loglist.CleanMsg()
//            }) {
//                Text("Test")
//            }
            //StringObjectListView(stringObject: StringObjectsData)
            VStack{
                //Text(String(self.stringObjectViewModel.countNum))
                ControlPanel(showImage: $showImage)
                    .padding(.top, 20.0)
                    .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                ImageProcessView(imageViewModel: imageViewModel)
                    .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)

                StringObjectListView()
                    .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)

//                LogListView(logList: loglist)
//                    .frame(width:400, height: 300.0)
            }
     
            //.frame(width: 400.0)
            ZStack{
                           
                ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                    ZStack{
                        ImageView(imageViewModel:imageViewModel, showImage: $showImage)
                            //.gesture(drag)
                        LabelsOnImage(ShowPredictString: $ShowPredictString)
                        .blendMode(.difference)
                        CharacterFrameListView(frameList: stringObjectVM.charFrameListData, imageViewModel: imageViewModel)
                        
//                        Rectangle()
//                            .fill(Color.red.opacity(0.2))
//                            .frame(width: font.GetFontInfo(Font: "SF Pro Display", Content: "Flooyfird", Size: 60).size.width, height: font.GetFontInfo(Font: "SF Pro Display", Content: "Flooyfird", Size: 60).size.height)
//                            .position(x: 50 , y: 100 )
//                            .onTapGesture {
//                        }
//                        
//                        Text("Flooy fird")
//                            .foregroundColor(Color.red)
//                            .font(.custom("SF Pro Display", size: 60))
//                            .tracking(1.0)
//                            .position(x: 50, y: 100)
                    }
                    
                }
                
                VStack{
                    Toggle(isOn: $ShowPredictString) {
                        Text("String Layer").shadow(color: Color.black.opacity(0.6), radius: 0.2, x: 0.1, y: -0.1)
                    }
                    .frame(width: 1000, height: 950, alignment: .topTrailing)
                }
                
            
            }
            .frame(width: 1100)
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










