//
//  pathView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 23/2/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct pathView: View {
    var myPath: CGPath
    
    var body: some View {
 
            Color.red.border(Color.red, width: 1)
            
//            // glyph path is inverted, so flip vertically
//            let flipY = CGAffineTransform(scaleX: 1, y: -1.0)
//
//            // glyph path may be offset on the x coord, and by the height (because it's flipped)
//            let translate = CGAffineTransform(translationX: -myPath.boundingBox.origin.x, y: myPath.boundingBox.size.height + myPath.boundingBox.origin.y)
//
//            // apply the transforms
////            pth.apply(flipY)
////            pth.apply(translate)
//
//            // stroke the path
//        myPath.boundingBoxOfPath
            
            // print the modified path for debug / reference
            
            
       
        
    }
}


//struct pathView_Previews: PreviewProvider {
//    static var previews: some View {
//        pathView()
//    }
//}
