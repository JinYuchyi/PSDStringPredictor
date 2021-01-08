//
//  PsdThumbnail.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct PsdThumbnail: View {
    var name: String
    var thumb: NSImage
    
    
    var body: some View {
        Image(nsImage: thumb)
    }
}

//struct PsdThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//        PsdThumbnail()
//    }
//}
