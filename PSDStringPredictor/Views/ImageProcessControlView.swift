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
    //@State private  var gammaValue: CGFloat = 1
    //@State private  var exposureValue: CGFloat = 0
    @State var isConvolution: Bool = false
    

    
    var body: some View {
        

        
        VStack{
            HStack{
                ToggleConv()
            }
            
            HStack{
                Text("Gamma")
                Slider(
                    value: Binding(
                        get: {
                            imageViewModel.gammaValue
                        },
                        set: {(newValue) in
                            imageViewModel.gammaValue = newValue
                            self.SetFilter()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(self.imageViewModel.GetTargetCIImage().IsValid() == false)
                Button(action: { imageViewModel.gammaValue = 1; self.SetFilter() }){
                    Text("Reset")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack{
                Text("Exposure")
                Slider(
                    value: Binding(
                        get: {
                            imageViewModel.exposureValue
                        },
                        set: {(newValue) in
                            imageViewModel.exposureValue = newValue
                            self.SetFilter()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(self.imageViewModel.GetTargetCIImage().IsValid() == false)
                Button(action: { imageViewModel.exposureValue = 0; self.SetFilter() }){
                    Text("Reset")
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            //
            
            
        }
    }
    
//    func SetFilter(){
//        if (self.imageViewModel.targetImageMasked.IsValid()){
//            var tmp = ChangeGamma(self.imageViewModel.targetImageMasked, CGFloat(gammaValue))!
//            tmp = ChangeExposure(tmp, CGFloat(exposureValue))!
//            if isConvolution == true{
//                tmp = SetConv(tmp)!
//            }
//            
//            self.imageViewModel.SetTargetProcessedImage(tmp)
//        }
//    }
    
    func SetFilter(){
        imageViewModel.SetFilter()
    }
    
    func ToggleConv() -> some View{
        let bind = Binding<Bool>(
            get:{self.isConvolution},
            set:{self.isConvolution = $0
                SetFilter()
            }
          )
        return Toggle(isOn: bind, label: {
            Text("Sharpen Edge")
            
                })
        .frame(width: 300, alignment: .leading)
    }
}

//struct ImageProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageProcessView()
//    }
//}
