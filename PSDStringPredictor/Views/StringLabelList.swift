//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImage: View {
    //@ObservedObject var stringObjectList: StringObjectList
    @ObservedObject var imageProcess: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM : StringObjectViewModel = stringObjectViewModel
//    @Binding var showPredictString: Bool
//    @Binding var showDebugOverlay: Bool
    
    
    var body: some View {
        
        ForEach(stringObjectVM.stringObjectListData, id:\.id){ item in
            
            StringLabel(stringLabel: item)
                
//            StringLabel(
//                position: item.position,
//                height: item.height,
//                width: item.width,
//                fontsize: item.fontSize,
//                tracking: item.tracking,
//                content: item.content,
//                color: item.color,
//                imageViewModel: self.imageProcess,
//                ShowPredictString: self.$ShowPredictString
//            )

        }
        //Text(String(stringObjectViewModel.charFrameListData.count))
    }
    

}



//struct LabelsOnImage_Previews: PreviewProvider {
//    static var previews: some View {
//        LabelsOnImage()
//    }
//}



//func GetLabelsList() -> [StringLabel]  {
//    var StringLabels: [StringLabel] = []
//    for i in 0...10 {
//        var l = StringLabel()
//        StringLabels.append(l)
//    }
//    //return StringLabels
//    return StringLabels
//}

//func ToPSDLocation(Location location: [CGFloat]) ->[CGFloat]{
//    
//}

//struct StringLabelList_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
