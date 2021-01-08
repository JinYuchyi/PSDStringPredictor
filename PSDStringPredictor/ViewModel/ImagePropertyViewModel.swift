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
        if (psdViewModel.psdColorMode[psdViewModel.selectedPSDID]  == 1){
            colorModeString = "Light Mode"
        }
        else if (psdViewModel.psdColorMode[psdViewModel.selectedPSDID]  == 2){
            colorModeString = "Dark Mode"
        }else{
            colorModeString = "No Image"
        }
    }
    
    func SetImageColorMode(modeIndex: Int) {
        psdViewModel.psdColorMode[psdViewModel.selectedPSDID]  = modeIndex
        self.FetchImageColorMode()
    }
}
