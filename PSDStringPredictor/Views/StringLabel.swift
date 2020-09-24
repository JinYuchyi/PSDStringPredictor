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
    @Binding var ShowPredictString: Bool
    
    //let stringLabel = StringLabel()
    
    var body: some View {
        ZStack{
            Rectangle()
                //.fill(Color.red.opacity(0.5))
                .stroke(Color.red, lineWidth: 2)
                .frame(width: self.width, height: self.height)
            
            if ShowPredictString == true {
                Text(self.content)
                .foregroundColor(color)
                .font(.custom("SF Pro Text", size: fontsize))
                .tracking(tracking)
            }
               
        }
        .position(x: position[0] + width/2, y: imageViewModel.GetTargetImageSize()[1] -  position[1] - height/2)

        
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

