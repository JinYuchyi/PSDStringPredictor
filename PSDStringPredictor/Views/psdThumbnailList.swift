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
        List(psdvm.psds.PSDObjects, id:\.id) { psd in
            PsdThumbnail(name: psd.imageURL.path, thumb: psd.thumbnail)
        }
    }
}

struct psdThumbnailList_Previews: PreviewProvider {
    static var previews: some View {
        psdThumbnailList()
    }
}
