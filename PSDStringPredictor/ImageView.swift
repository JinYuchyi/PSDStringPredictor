//
//  ImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI


struct ImageView: View {
var imageProcess: ImageProcess
@EnvironmentObject var data: DataStore

    var body: some View{
            ZStack{
                //imageProcess.GetImage(name: "LocSample")
                //Image(data.targetImage.cgImage)
                Image(nsImage: data.targetImage.ToNSImage())
                //imageProcess.GetImage(name: data.targetImageName)
                //Text("Label")
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
