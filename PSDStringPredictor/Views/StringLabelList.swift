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
    @ObservedObject var imageProcess: ImageProcess
    //@EnvironmentObject var data: DataStore
    @ObservedObject var stringObjectViewModel : StringObjectViewModel
    @Binding var ShowPredictString: Bool
    
    //let data: DataStore = DataStore()
    var body: some View {
        
        ForEach(stringObjectViewModel.stringObjectListData, id:\.id){ item in
            StringLabel(
                
                position: item.position,
                height: item.height,
                width: item.width,
                fontsize: item.fontSize,
                tracking: item.tracking,
                content: item.content,
                color: item.color,
                imageViewModel: self.imageProcess,
                ShowPredictString: self.$ShowPredictString
            )
            //.position(x: item.position[0] + item.width/2, y: CGFloat(self.data.targetImageSize[1]) -  item.position[1] - item.height/2)

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
