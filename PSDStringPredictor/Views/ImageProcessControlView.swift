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
    @State private  var gammaValue: CGFloat = 1
    //@State private  var sharpenValue: CGFloat = 0.4
    @State private  var exposureValue: CGFloat = 0
    
    var body: some View {
        VStack{
            
            HStack{
                Text("Gamma")
                Slider(
                    value: Binding(
                        get: {
                            self.gammaValue
                        },
                        set: {(newValue) in
                            self.gammaValue = newValue
                            self.SetFilter()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(self.imageViewModel.GetTargetCIImage().IsValid() == false)
                Button(action: { self.gammaValue = 1; self.SetFilter() }){
                    Text("Reset")
                    //.padding(.horizontal, 40.0)
                    //.frame(minWidth: 200, maxWidth: .infinity)

                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack{
                Text("Exposure")
                Slider(
                    value: Binding(
                        get: {
                            self.exposureValue
                        },
                        set: {(newValue) in
                            self.exposureValue = newValue
                            //let tmp = ChangeExposure(self.imageViewModel.GetTargetCIImage(), CGFloat(newValue))!
                            //self.imageViewModel.SetTargetProcessedImage(tmp)
                            self.SetFilter()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(self.imageViewModel.GetTargetCIImage().IsValid() == false)
                Button(action: { self.exposureValue = 0; self.SetFilter() }){
                    Text("Reset")
                    //.padding(.horizontal, 40.0)
                    //.frame(minWidth: 200, maxWidth: .infinity)

                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
//            HStack{
//                Text("Sharpen")
//                Slider(
//                    value: Binding(
//                        get: {
//                            self.sharpenValue
//                        },
//                        set: {(newValue) in
//                            self.sharpenValue = newValue
//                            //let tmp = ChangeSharpen(self.imageViewModel.GetTargetCIImage(), CGFloat(newValue))!
//                            //self.imageViewModel.SetTargetProcessedImage(tmp)
//                            var tmp = ChangeGamma(self.imageViewModel.GetTargetCIImage(), CGFloat(gammaValue))!
//                            tmp = ChangeExposure(tmp, CGFloat(exposureValue))!
//                            tmp = ChangeSharpen(tmp, CGFloat(sharpenValue))!
//
//                            self.imageViewModel.SetTargetProcessedImage(tmp)
//                        }
//                    ),
//                    in: 0...10
//
//                )
//                Button(action: { sharpenValue = 0.5 }){
//                    Text("Reset")
//
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, -4)
            
            
        }
    }
    
    func SetFilter(){
        if (self.imageViewModel.GetTargetCIImage().IsValid()){
            var tmp = ChangeGamma(self.imageViewModel.GetTargetCIImage(), CGFloat(gammaValue))!
            tmp = ChangeExposure(tmp, CGFloat(exposureValue))!
            //tmp = ChangeSharpen(tmp, CGFloat(sharpenValue))!
            self.imageViewModel.SetTargetProcessedImage(tmp)
        }
    }
}

//struct ImageProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageProcessView()
//    }
//}
