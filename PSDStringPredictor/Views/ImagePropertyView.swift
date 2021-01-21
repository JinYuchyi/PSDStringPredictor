//
//  ImagePropertyView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ImagePropertyView: View {
//    @ObservedObject var imagePropertyVM = imagePropertyViewModel
    @ObservedObject var  psdvm: PsdsVM
//    let imageProcessVM = ImageProcess()
    
    //@ObservedObject var imageVM : ImageVM
    //@State var colorState = -1
    var body: some View {
        List{
            Section(header: Text("Image Properties")){
                
                HStack{
                    Text("Color Mode")
                        .frame(width:80, alignment: .topLeading)
                        .foregroundColor(Color.gray)
//                    psdvm.GetSelectedPsd()?.colorMode
                    Text(psdvm.GetSelectedPsd()?.colorMode == .dark ? "􀆺" : "􀆮" )
                }
//                HStack{
//                    Text("DPI")
//                        .frame(width:80, alignment: .topLeading)
//                        .foregroundColor(Color.gray)
//
//                    Text( psdvm.GetSelectedPsd()?.dpi.toString() ?? "" )
//                        .frame(width: 200, alignment: .topLeading)
//                }
                
                HStack{
                    HStack{
                        Text("Path")
                            .frame(width:80, alignment: .topLeading)
                            .foregroundColor(Color.gray)
                        ScrollView(.horizontal){
                            Text(psdvm.GetSelectedPsd()?.imageURL.path ?? "")
                            .frame(alignment: .topLeading)
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                }
            }
        }
    
    }
}

//struct ImagePropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePropertyView()
//    }
//}
