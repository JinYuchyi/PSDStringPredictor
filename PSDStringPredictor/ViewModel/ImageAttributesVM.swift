//
//  ImageAttributesVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

class ImageAttributesVM : ObservableObject {
    @Published var dpi: Int = 0
    @Published var path: String = ""
    @Published var colorMode: String = ""
    @Published var psdId = DataRepository.shared.GetSelectedPsdId()
    
    func FetchAll(){
        FetchDpi()
        FetchPath()
        FetchColorMode()
    } 
    
    func FetchDpi(){
        //TODO:
    }
    
    func FetchPath(){
        //TODO:
    }
    
    func FetchColorMode(){
        //TODO:
    }
}
