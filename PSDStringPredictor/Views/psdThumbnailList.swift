//
//  psdThumbnailList.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct psdThumbnailList: View {
    @ObservedObject var psdvm = psdViewModel
    var body: some View {
        GeometryReader{geo in
            List(psdvm.psds.PSDObjects, id:\.id) { psd in
                VStack{
                    PsdThumbnail(id: psd.id, name: psd.imageURL.lastPathComponent, thumb: psd.thumbnail)
                    .frame(width: geo.size.width, height: CGFloat(sizeOfThumbnail), alignment: .center)
                Divider()
                }
            }
        }
        
    }
}

struct psdThumbnailList_Previews: PreviewProvider {
    static var previews: some View {
        psdThumbnailList()
    }
}
