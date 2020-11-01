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
            Text("Size: \(stringObjectVM.selectedStringObject.fontSize)")
            Text("Tracking: \(stringObjectVM.selectedStringObject.tracking)")
            Text("Weight: \(stringObjectVM.selectedStringObject.fontWeight.ToString())")
            Text("Components Images:")
            
            ScrollView ( .horizontal, showsIndicators: true) {
                
                HStack {
                    
                    ForEach(0..<stringObjectVM.selectedStringObject.charImageList.count, id: \.self){ index in
                        
                        VStack{
                            Image(nsImage: stringObjectVM.selectedStringObject.charImageList[index].ToNSImage())
                                .frame(height: 100)
                            
                            TextField(String(stringObjectVM.selectedStringObject.charArray[index]), text: $stringField)
                            Text("W\(Int(stringObjectVM.selectedStringObject.charRects[index].width))H\(Int(stringObjectVM.selectedStringObject.charRects[index].height.rounded()))")
                            Text(String(stringObjectVM.selectedStringObject.charFontWeightList[index].ToString()))
                            Text(String(stringObjectVM.selectedStringObject.charSizeList[index].description))
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
