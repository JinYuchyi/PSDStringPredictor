//
//  ImagePropertyView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ImagePropertyView: View {
    @ObservedObject var imagePropertyVM = imagePropertyViewModel
    //@State var colorState = -1
    var body: some View {
        Text(imagePropertyVM.colorModeString)
    
    }
}

struct ImagePropertyView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePropertyView()
    }
}
