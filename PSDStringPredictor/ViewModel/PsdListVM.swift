//
//  ThumbnailListVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class PsdListVM: ObservableObject{
    
//    @Published var thumbnailDict: [Int:NSImage] = [:]
//    @Published var commitedList: [Int:Bool] = [:]
//    @Published var pathList: [Int:String] = [:]
    @Published var psdObjectList: [PSDObject] = []
    
    func Refresh(){
        FetchPsdObjectList()
    }
    
    func FetchPsdObjectList(){
        psdObjectList = DataRepository.shared.GetPsdObjectList()
    }
    
    //MARK: Intents
    func LoadImage(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = ["png", "PNG", "psd", "PSD"]
        
        if (panel.runModal() ==  NSApplication.ModalResponse.OK) {
            // Results contains an array with all the selected paths
            let results = panel.urls
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            for result in results {
                let hasSame = DataRepository.shared.GetPsdObjectList().contains(where: {$0.imageURL == result})
                if hasSame == false {
                    DataRepository.shared.AppendPsdObjectList(url: result)
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        Refresh()
        

    }
    
    func ThumbnailClicked(psdId: Int){
        DataRepository.shared.SetSelectedPsdId(newId: psdId)
        guard let psdObj = DataRepository.shared.GetPsdObject(psdId: psdId) else {
            return
        }
        let nsImg = LoadNSImage(imageUrlPath: psdObj.imageURL.path)
        DataRepository.shared.SetSelectedNSImage(image: nsImg)
         
    }
    
    

}
