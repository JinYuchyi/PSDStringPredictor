//
//  ImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ImageView: View {

    var body: some View{
        
            ZStack{
                //Image("locSampleWithGrid")
                GetImage(name: "locSampleWithGrid")
                //Text("Label")
            }
        
    }
}

//struct GetShowContent: View{
//    var body: some View{
//
//    }
//}

func GetImage(name: String) -> Image{
    var image: Image {
        ImageStore.shared.image(name: name)
    }
    return image
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
            .previewLayout(PreviewLayout.fixed(width: 1000, height: 1000))
    }
}
