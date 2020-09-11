//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    var id : Int
    var position: [CGFloat]
    var height: CGFloat
    var width: CGFloat
    var fontsize: CGFloat
    var tracking: CGFloat
    var content: String
    
    var body: some View {
        ZStack{
            Rectangle()
            .fill(Color(red: 1, green: 0, blue: 0, opacity: 0.3))
                .frame(width: self.width, height: self.height)
            
            Text(self.content)
                .font(.system(size: self.fontsize, weight: .light, design: .serif))

        }
        .position(x: self.position[0], y: self.position[1])
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
    return 20
}

func SetTracking() -> CGFloat {
    return 20
}

func SetContent() -> String{
    return "Default " +  SetPosition()[0].description  + ", " +  SetPosition()[1].description
}
