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
    @State var stringField: String = ""
    
    var body: some View {
        VStack{
            Text("Content:")
            Text("\(stringObjectVM.selectedStringObject.content)")
            Text("Components Images:")
            ScrollView ( .horizontal, showsIndicators: true) {
                HStack {
                    ForEach(stringObjectVM.selectedCharImageListObjectList, id:\.id){ item in
                        VStack{
                            Image(nsImage: item.image.ToNSImage())
                                .frame(height: 100)
                                
                            TextField(item.char, text: $stringField)
                            Text(String(item.weight))
                            Text(String(item.size))
                        }
                    }
                }
                .fixedSize()
            }
            //
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
