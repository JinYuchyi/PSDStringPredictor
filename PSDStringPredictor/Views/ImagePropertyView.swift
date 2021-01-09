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
    @ObservedObject var  psdvm = psdViewModel
    let imageProcessVM = ImageProcess()
    //@State var colorState = -1
    var body: some View {
        List{
            Section(header: Text("Image Properties")){
                
                HStack{
                    Text("Color Mode")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
                    if psdViewModel.psdColorMode[psdViewModel.selectedPSDID] == 2{
                        Text("􀆺")
                            .frame(width: 200, alignment: .topLeading)
                    }else if psdViewModel.psdColorMode[psdViewModel.selectedPSDID] == 1 {
                        Text("􀆮")
                            .frame(width: 200, alignment: .topLeading)
                        
                    }else{}
                }
                HStack{
                    Text("DPI")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
                    
                    Text(String(imageProcessVM.GetImageProperty(keyName: "DPIWidth" , path: psdvm.imageUrlDict[psdViewModel.selectedPSDID]?.path ?? "")))
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
