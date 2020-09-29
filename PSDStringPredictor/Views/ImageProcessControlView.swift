//
//  ImageProcessView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 14/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ImageProcessView: View {
    //@EnvironmentObject var data: DataStore
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @State private  var gammaValue: Float = 0.75
    
    
    var body: some View {
        VStack{
            Slider(
                value: Binding(
                    get: {
                        self.gammaValue
                    },
                    set: {(newValue) in
                        self.gammaValue = newValue
                        let tmp = ChangeGamma(self.imageViewModel.GetTargetCIImage(), CGFloat(newValue))!
                        self.imageViewModel.SetTargetProcessedImage(tmp)
                }
                ),
                in: 0...10
            
            )

            
            
        }
    }
}

//struct ImageProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageProcessView()
//    }
//}
