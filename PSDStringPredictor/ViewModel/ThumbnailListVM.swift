//
//  ThumbnailListVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class ThumbnailListVM: ObservableObject{
    
//    @Published var thumbnailDict: [Int:NSImage] = [:]
//    @Published var commitedList: [Int:Bool] = [:]
//    @Published var pathList: [Int:String] = [:]
    @Published var psdObjectList: [PSDObject] = []
    
    func FetchPsdObjectList(){
        psdObjectList = DataRepository.shared.GetPsdObjectList()
    }
    
    //MARK: Intents
    func ThumbnailClicked(psdId: Int){
        //TODO
    }
    
    

}
