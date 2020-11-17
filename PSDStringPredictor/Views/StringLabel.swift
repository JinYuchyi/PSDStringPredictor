//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    //    var id : UUID = UUID()
    //    var position: [CGFloat]
    //    var height: CGFloat
    //    var width: CGFloat
    //    var fontsize: CGFloat = 50//SetFontSize()
    //    var tracking: CGFloat
    //    var content: String
    //    var color: Color
    
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    //    @Binding var showPredictString: Bool
    //    @Binding var showDebugOverlay: Bool
    @State var width: CGFloat = 0
    
    var stringLabel: StringObject
    
    
    func makeView(_ geometry: GeometryProxy) -> some View {
            print(geometry.size.width, geometry.size.height)

        DispatchQueue.main.async { self.width = geometry.size.width }

            return Text("Test")
                    .frame(width: geometry.size.width)
        }
    
    func InfoBtnTapped(){
        stringObjectVM.UpdateSelectedStringObject(selectedStringObject: self.stringLabel)
        stringLabel.PredictTracking()
        print(stringLabel.charSizeList)
    }
    
    var body: some View {

        ZStack {
//            GeometryReader { geometry in
//                self.makeView(geometry)
//                //return EmptyView()
//            }
            //Rect of original position
            Rectangle()
                .fill(Color.red.opacity(1))
                .frame(width: 4, height: 4)
                .position(x: stringLabel.stringRect.origin.x , y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y )
            //                .onTapGesture {
            //                    print("\(self.imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y)")
            //                }
            
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            
            Rectangle()
                .stroke(Color.red, lineWidth: 1)
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )


            if stringLabel.fontSize < 20 {
                Text(stringLabel.content)
                    //.foregroundColor(stringLabel.color)
                    //.font(.custom("SF Pro Text", size: stringLabel.fontSize))
                    //.tracking(stringLabel.tracking)
                    .font(.system(size: stringLabel.fontSize, weight: stringLabel.fontWeight))
                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
            }
            else{
                Text(stringLabel.content)
                    //.foregroundColor(stringLabel.color)
                
                    //"SF Pro Display"
                    
                    .font(.custom(stringLabel.CalcFontFullName(), size: stringLabel.fontSize))
                    .tracking(stringLabel.tracking)
                    //.font(.system(size: stringLabel.fontSize, weight: stringLabel.fontWeight))
                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
            }
            
            //Button for show detail
            Button(action: {self.InfoBtnTapped()}){
                Text("􀍢")
                    //.background(Color.black)
                    .foregroundColor(Color.white)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
            }
            .position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY   )
            
            
        }
        
        //.position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] -  stringLabel.position[1] - stringLabel.height/2)
        
        //        func CGPositionToSwiftPosition(From pos: [Int]) -> [Int] {
        //            let newX = stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2
        //            let newY = imageViewModel.GetTargetImageSize()[1] -  stringLabel.position[1] - stringLabel.height/2
        //            return  [newX, newY]
        //        }
        
        
    }
}
//
//func SetPosition() -> [CGFloat] {
//    //let x = Int.random(in: 0..<100)
//    //let y = Int.random(in: 0..<100)
//    return [200, 200]
//}
//
//func SetHeight() -> CGFloat {
//    return 20
//}
//
//func SetWidth() -> CGFloat {
//    return 20
//}
//
//func SetFontSize() -> CGFloat {
//    return 50
//}
//
//func SetTracking() -> CGFloat {
//    return 20
//}
//
//func SetContent() -> String{
//    return "Default " +  SetPosition()[0].description  + ", " +  SetPosition()[1].description
//}

