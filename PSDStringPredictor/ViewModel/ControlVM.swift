//
//  ImageProcessVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

class ControlVM : ObservableObject {
    
//    @Published var gamma : CGFloat = DataRepository.shared.GetGamma(psdId: DataRepository.shared.GetSelectedPsdId())
//    @Published var exp : CGFloat = DataRepository.shared.GetExp(psdId: DataRepository.shared.GetSelectedPsdId())
    
    
    
    func CombineStrObjects(selectedIdList: [UUID]){
        
    }
    
    func FixSelectedObjects(selectedIdList: [UUID]){}
    
    func IgnoreSelectedObjects(selectedIdList: [UUID]){}
    
    func ProcessForOne(){
        let img = DataRepository.shared.GetProcessedImage(psdId: DataRepository.shared.GetSelectedPsdId())
        if img.extent.width > 0 {
            DataRepository.shared.FetchStringObjects(image: img)
            //print(DataRepository.shared.GetStringObjectsForOnePsd(psdId: DataRepository.shared.GetSelectedPsdId()).count)
        }
    }
    
    func CreatePsdForOne(){}
    
    func SetGamma(val: CGFloat){
        //gamma = val
        DataRepository.shared.SetGamma(psdId: DataRepository.shared.GetSelectedPsdId(), value: val)
        DataRepository.shared.UpdateProcessedImage(psdId: DataRepository.shared.GetSelectedPsdId())
        //print(DataRepository.shared.GetGamma(psdId: DataRepository.shared.GetSelectedPsdId()))
    }
    
    func GetGamma() -> CGFloat {
        DataRepository.shared.GetGamma(psdId: DataRepository.shared.GetSelectedPsdId())
    }
    
    func SetExp(val: CGFloat){
        //exp = val
        DataRepository.shared.SetExp(psdId: DataRepository.shared.GetSelectedPsdId(), value: val)
        DataRepository.shared.UpdateProcessedImage(psdId: DataRepository.shared.GetSelectedPsdId())
    }
    
    func GetExp() -> CGFloat{
        DataRepository.shared.GetExp(psdId: DataRepository.shared.GetSelectedPsdId())
    }
}
