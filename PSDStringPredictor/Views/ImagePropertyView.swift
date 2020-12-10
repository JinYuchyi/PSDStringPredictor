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
    let imageProcessVM = ImageProcess()
    //@State var colorState = -1
    var body: some View {
        List{
            Section(header: Text("Image Properties")){
                
                HStack{
                    Text("Color Mode")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
                    if imagePropertyVM.colorModeString == "Dark Mode"{
                        Text("􀆺")
                            .frame(width: 200, alignment: .topLeading)
                    }else if imagePropertyVM.colorModeString == "Light Mode" {
                        Text("􀆮")
                            .frame(width: 200, alignment: .topLeading)
                    }else{}
                        
                        
                }
                HStack{
                    Text("DPI")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
                    
                    Text(String(imageProcessVM.GetImageProperty(keyName: "DPIWidth" , path: DataStore.imagePath)))
                        .frame(width: 200, alignment: .topLeading)
                }
                
                HStack{
                    HStack{
                        Text("Path")
                            .frame(width:80, alignment: .topLeading)
                            .foregroundColor(Color.gray)
                        Text(DataStore.imagePath)
                            .frame(alignment: .topLeading)
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
