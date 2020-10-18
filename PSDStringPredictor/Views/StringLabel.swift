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
    
    var stringLabel: StringLabelObject
    

    func OnTap(){
        print()
    }
    
    var body: some View {
        ZStack {
            
            //Rect of original position
            Rectangle()
            .fill(Color.red.opacity(1))
            .frame(width: 10, height: 10)
            .position(x: stringLabel.position[0] , y: imageViewModel.GetTargetImageSize()[1] - stringLabel.position[1] )
                .onTapGesture {
                    print("\(self.imageViewModel.GetTargetImageSize()[1] - self.stringLabel.position[1] )")
            }

            Rectangle()
            .stroke(Color.red, lineWidth: 2)
            .frame(width: stringLabel.width, height: stringLabel.height)
            .position(x: stringLabel.position[0] + stringLabel.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.position[1] - stringLabel.height/2  )

            
            if ShowPredictString == true {
                //Base on font size, define the font
                if stringLabel.fontsize < 60 {
                    Text(stringLabel.content)
                    //.foregroundColor(stringLabel.color)
                    //.font(.custom("SF Pro Text", size: stringLabel.fontsize))
                    //.tracking(stringLabel.tracking)
                        .font(.system(size: stringLabel.fontsize))
                    .position(x: stringLabel.position[0] + stringLabel.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.position[1] - stringLabel.height/2  )

                }
                else{
                    Text(stringLabel.content)
                    //.foregroundColor(stringLabel.color)
                    //.font(.custom("SF Pro Text", size: stringLabel.fontsize))
                    //.tracking(stringLabel.tracking)
                        .font(.system(size: stringLabel.fontsize))
                    .position(x: stringLabel.position[0] + stringLabel.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.position[1] - stringLabel.height/2  )

                }
                
            }

               
        }

        //.position(x: stringLabel.position[0] + stringLabel.width/2, y: imageViewModel.GetTargetImageSize()[1] -  stringLabel.position[1] - stringLabel.height/2)

//        func CGPositionToSwiftPosition(From pos: [Int]) -> [Int] {
//            let newX = stringLabel.position[0] + stringLabel.width/2
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

