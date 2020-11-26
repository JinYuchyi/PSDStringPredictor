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
        List{
            Section(header: Text("Image Properties")){
                
                HStack{
                    Text("ColorMode")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
                    Text("\(imagePropertyVM.colorModeString)")
                        .frame(width: 200, alignment: .topLeading)
                    
                    //Text(imagePropertyVM.colorModeString)
                }
                HStack{
                    HStack{
                        Text("Path")
                            .frame(width:80, alignment: .topLeading)
                            .foregroundColor(Color.gray)
                        Text(DataStore.imagePath)
                            .frame(width: 200, alignment: .topLeading)
                    }
                }
            }
        }
    
    }
}

struct ImagePropertyView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePropertyView()
    }
}
