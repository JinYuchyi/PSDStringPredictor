//
//  ImageResourceView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

func CustomImage(name: String, color: Color = .white) -> some View {
    return VStack {
        Image(name)
            .resizable()
            .renderingMode(.original)
            
            //.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            //.aspectRatio(1, contentMode: .fit) // keep the aspect ratio
    }
    //.frame(width: 32, height: 32) // the image will fit this size
}

struct ImageResourceView_Previews: PreviewProvider {
    static var previews: some View {
        CustomImage(name: "detail-round")
    }
}
