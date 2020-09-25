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
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @Binding var showImage: Bool
    
    var body: some View{
            ZStack{
                //Show button before we have image loaded
                
                if(showImage == false){
//                    Button(action: {self.control.LoadImageBtnPressed()}){
//                        Text("Load Image")
//                    }
                    
                }
                //Show Image if we have loaded image
                else{
                    ZStack{
                        Image(nsImage: imageViewModel.targetImageProcessed.ToNSImage())

                    }
                }
        }
    }
    
 
//    func BtnLoadImage() {
//        let panel = NSOpenPanel()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let result = panel.runModal()
//            if result == .OK{
//                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
//                {
//                    let tmp = LoadNSImage(imageUrlPath: panel.url!.path)
//                    self.imageViewModel.SetTargetNSImage(tmp)
//                    print("After select: \(self.imageViewModel.targetImageProcessed.extent.width)")
//                    self.showImg = true
//                    
//
//                }
//                
//            }
//        }
//        
//        //return true
//    }
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
