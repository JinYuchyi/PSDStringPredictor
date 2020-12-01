//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImage: View {
    @ObservedObject var imageProcess: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM : StringObjectViewModel = stringObjectViewModel
    
    
    var body: some View {
        
        ForEach(stringObjectVM.updateStringObjectList, id:\.id){ item in
            
            StringLabel(stringLabel: item)

        }
    }
    

}

