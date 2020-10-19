//
//  ImagePropertyViewModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class ImagePropertyViewModel: ObservableObject{
    
    @Published private(set) var colorModeString: String = "No Image"
    
    func FetchImageColorMode(){
        if (DataStore.colorMode == 1){
            colorModeString = "Light Mode"
        }
        else if (DataStore.colorMode == 2){
            colorModeString = "Dark Mode"
        }else{
            colorModeString = "No Image"
        }
    }
    
    func SetImageColorMode(modeIndex: Int) {
        DataStore.colorMode = modeIndex
        self.FetchImageColorMode()
    }
}
