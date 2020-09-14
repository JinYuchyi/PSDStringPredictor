//
//  ImageProcessView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 14/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ImageProcessView: View {
    @EnvironmentObject var data: DataStore
    
    var body: some View {
        VStack{
            Slider(value: $data.gammaValue, in: 0...10, label: "Gamma")
                .padding(5.0)
        }
    }
}

struct ImageProcessView_Previews: PreviewProvider {
    static var previews: some View {
        ImageProcessView()
    }
}
