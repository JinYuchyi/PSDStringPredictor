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
        ScrollView(.vertical){
            ZStack{
                //Image(#imageLiteral(resourceName: "locSampleWithGrid.png"))
                Image("locSampleWithGrid")
                Text("Label")
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
            .previewLayout(PreviewLayout.fixed(width: 1000, height: 1000))
    }
}
