//
//  ImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI


struct ImageView: View {
//var imageProcess: ImageProcess
//@EnvironmentObject var data: DataStore
    let imgUtil = ImageUtil()
    let control = Controller()
    //let imgProcess = ImageProcess()
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
//    @Binding var showImage: Bool
    
    var body: some View{
            ZStack{
                //Show button before we have image loaded
                
                if(imageProcessViewModel.showImage == false){
//                    Button(action: {self.control.LoadImageBtnPressed()}){
//                        Text("Load Image")
//                    }
                    
                }
                //Show Image if we have loaded image
                else{
                    ZStack{
                        Image(nsImage: imageViewModel.targetImageProcessed.ToNSImage())
                        SelectionOverlayView()
//                        VStack{
//                            Text("Tracking1")
//                                .font(.custom("SFProText-Regular", size: 67))
//                                .tracking(-0.26)
//                            Text("Tracking1")
//                                .font(.custom("SFProText-Regular", size: 67))
//                                .tracking(0)
//                        }
                    }
                }
        }
    }

}

//struct GetShowContent: View{
//    var body: some View{
//
//    }
//}


//
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView(imageProcess: <#ImageProcess#>)
//            .previewLayout(PreviewLayout.fixed(width: 1000, height: 1000))
//    }
//}
