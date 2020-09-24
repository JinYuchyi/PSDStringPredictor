//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    var id : UUID = UUID()
    var position: [CGFloat]
    var height: CGFloat
    var width: CGFloat
    var fontsize: CGFloat = SetFontSize()
    var tracking: CGFloat
    var content: String
    var color: Color
    
    //@EnvironmentObject var data: DataStore
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @Binding var ShowPredictString: Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                //.fill(Color.red.opacity(0.5))
                .stroke(Color.red, lineWidth: 2)
                .frame(width: self.width, height: self.height)
            
            if ShowPredictString == true {
                Text(self.content)
                    //.font(.system(size: self.fontsize, weight: .light, design: .serif))
                .foregroundColor(color)
                .font(.custom("SF Pro Text", size: fontsize))
                .tracking(tracking)
//                .overlay(
//                     GeometryReader {
//                        geometry in
//                        Text(geometry.frame(in: .global).debugDescription)
//                            .background(Color.yellow)
//                        //Text(geometry.frame(in: .global).size)
//                    }
//                )
            }
   
            
            //print("width: \(width), height: \(height)")

        }
        .position(x: position[0] + width/2, y: imageViewModel.GetTargetImageSize()[1] -  position[1] - height/2)

        
    }
}

//struct StringLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        StringLabel(
//            id: SetID(),
//            position: SetPosition(),
//            height: SetHeight(),
//            width: SetWidth(),
//            fontsize: SetFontSize(),
//            tracking: SetTracking(),
//            content: SetContent()
//        )
//    }
//}

//func SetID() -> Int {
//    return stringObjectsData.
//}

func SetPosition() -> [CGFloat] {
    //let x = Int.random(in: 0..<100)
    //let y = Int.random(in: 0..<100)
    return [200, 200]
}

func SetHeight() -> CGFloat {
    return 20
}

func SetWidth() -> CGFloat {
    return 20
}

func SetFontSize() -> CGFloat {
    return 50
}

func SetTracking() -> CGFloat {
    return 20
}

func SetContent() -> String{
    return "Default " +  SetPosition()[0].description  + ", " +  SetPosition()[1].description
}

//struct StringLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        StringLabel(id:1, position:[0,0], height: 10, width: 10, fontsize: 20, tracking: 50, content: "Weather")
//    }
//}
