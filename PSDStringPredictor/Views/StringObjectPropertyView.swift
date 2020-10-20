//
//  StringObjectPropertyView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectPropertyView: View {
    
    @ObservedObject var stringObjectVM = stringObjectViewModel
    
    var body: some View {
        VStack{
            Text("Content:")
            Text("\(stringObjectVM.selectedStringObject.content)")
            Text("Components Images:")
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(stringObjectVM.selectedCharImageListObjectList, id:\.id){ item in
                        Image(nsImage: item.image.ToNSImage())
                            .resizable()
                            .frame(width: item.image.extent.width * 2, height: item.image.extent.height * 2)
                    }
                }
            }
            .frame(width: 300)
            //            HStack{
            //                List(stringObjectVM.selectedStringObject.charImageList){ item in
            //                    Image(item)
            //                }
            //            }
            
        }
    }
}

struct StringObjectPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectPropertyView()
    }
}
