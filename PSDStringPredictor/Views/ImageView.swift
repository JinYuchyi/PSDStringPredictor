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
    @ObservedObject var imageViewModel: ImageProcess
    @State var showImg = false
    
    var body: some View{
            ZStack{
                if(showImg == false){
                    Button(action: BtnLoadImage){
                        Text("Load Image")
                    }
                }
                else{
                    Image(nsImage: (imageViewModel.targetImageProcessed.extent.width > 0 ? imageViewModel.targetImageProcessed.ToNSImage() : imageViewModel.targetNSImage) )
                }
        }
    }
    
 
    func BtnLoadImage() {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
                {
                    let tmp = LoadNSImage(imageUrlPath: panel.url!.path)
                    //print("tmp:\(tmp.size)")
                    self.imageViewModel.SetTargetNSImage(tmp)
                   // self.imageViewModel.SetTargetNSImage( LoadNSImage(imageUrlPath: panel.url!.path))
                   // targetImage = targetNSImage.ToCIImage()!
                    
                    //targetImageSize = [(targetImage.extent.width),(targetImage.extent.height)]
                    self.showImg = true
                }
                
            }
        }
        
        //return true
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
