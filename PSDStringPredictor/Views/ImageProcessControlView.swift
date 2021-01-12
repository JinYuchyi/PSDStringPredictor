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
    
    @ObservedObject var controlVM: ControlVM
    @ObservedObject var imageVM: ImageVM
    
    var body: some View {
        

        
        VStack{
//            HStack{
//                ToggleConv()
//            }
            
            HStack{
                Text("Gamma")
                Slider(
                    value: Binding(
                        get: {
                            controlVM.GetGamma()
                        },
                        set: {(newValue) in
                            controlVM.SetGamma(val: newValue)
                            imageVM.FetchInfo()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(imageViewModel.targetNSImage.ToCIImage()?.IsValid() == false)
                Button(action: { ResetGamma() }){
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
                            controlVM.GetExp()
                        },
                        set: {(newValue) in
                            controlVM.SetExp(val: newValue)
                            imageVM.FetchInfo()
                        }
                    ),
                    in: 0...10
                    
                ).disabled(self.imageViewModel.targetNSImage.ToCIImage()?.IsValid() == false)
                Button(action: { ResetExp() }){
                    Text("Reset")
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            //
            
            
        }
    }
    
    func ResetGamma(){
        controlVM.SetGamma(val: 1)
        imageVM.FetchInfo()
    }
    
    func ResetExp(){
        controlVM.SetExp(val: 0)
        imageVM.FetchInfo()
    }

    
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
