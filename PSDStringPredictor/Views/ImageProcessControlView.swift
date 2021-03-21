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
    //@ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    //@State private  var gammaValue: CGFloat = 1
    //@State private  var exposureValue: CGFloat = 0
    //@State var isConvolution: Bool = false
    
//    @ObservedObject var controlVM: ControlVM
//    @ObservedObject var imageVM: ImageVM
    @ObservedObject var psdsVM: PsdsVM
    let panelWidth: CGFloat
    var body: some View {
        

        
        VStack{
//            HStack{
//                ToggleConv()
//            }
            Text("Image Enhance")
                .padding(.horizontal)
                .padding(.top)
                .frame(width: panelWidth, alignment: .leading)
                .foregroundColor(Color.gray)
            
            Divider()
            
            HStack{
                Text("Gamma")
                    .foregroundColor(Color.gray)
                Slider(
                    value: Binding(
                        get: {
                            (psdsVM.gammaDict[psdsVM.selectedPsdId] ?? 1)
                        },
                        set: {(newValue) in
                            psdsVM.gammaDict[psdsVM.selectedPsdId] = newValue
                            psdsVM.UpdateProcessedImage(psdId: psdsVM.selectedPsdId)
                        }
                    ),
                    in: 0...10
                    
                ).disabled( psdsVM.selectedPsdId == -1)
                Button(action: { ResetGamma() }){
                    Text("Reset")
                }
            }
            .padding(.horizontal)
//            .padding(.top)
            
            HStack{
                Text("Exposure")
                    .foregroundColor(Color.gray)
                Slider(
                    value: Binding(
                        get: {
                            (psdsVM.expDict[psdsVM.selectedPsdId] ?? 0)
                        },
                        set: {(newValue) in
                            psdsVM.expDict[psdsVM.selectedPsdId] = newValue
                            psdsVM.UpdateProcessedImage(psdId: psdsVM.selectedPsdId)
                        }
                    ),
                    in: 0...10
                    
                ).disabled(psdsVM.selectedPsdId == -1)
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
        psdsVM.gammaDict[psdsVM.selectedPsdId] = 1
        psdsVM.UpdateProcessedImage(psdId: psdsVM.selectedPsdId)
    }
    
    func ResetExp(){
        psdsVM.expDict[psdsVM.selectedPsdId] = 0
        psdsVM.UpdateProcessedImage(psdId: psdsVM.selectedPsdId)
    }

    
//    func SetFilter(){
//        imageViewModel.SetFilter()
//    }
    
//    func ToggleConv() -> some View{
//        let bind = Binding<Bool>(
//            get:{self.isConvolution},
//            set:{self.isConvolution = $0
//                SetFilter()
//            }
//          )
//        return Toggle(isOn: bind, label: {
//            Text("Sharpen Edge")
//
//                })
//        .frame(width: 300, alignment: .leading)
//    }
}

//struct ImageProcessView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageProcessView()
//    }
//}
