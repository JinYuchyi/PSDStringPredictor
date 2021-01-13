//
//  ImageProcessVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

class ControlVM  {
    
//    @Published var gamma : CGFloat = DataRepository.shared.GetGamma(psdId: DataRepository.shared.GetSelectedPsdId())
//    @Published var exp : CGFloat = DataRepository.shared.GetExp(psdId: DataRepository.shared.GetSelectedPsdId())
    
    //@Published var selectedPsdId: Int = 0
    
    func CombineStrObjects(selectedIdList: [UUID]){
        
    }
    
    func FixSelectedObjects(selectedIdList: [UUID]){}
    
    func IgnoreSelectedObjects(selectedIdList: [UUID]){}
    

    
    func CreatePsdForOne(){}
    
//    func SetGamma(val: CGFloat){
//        //gamma = val
//        PsdsUtil.shared.SetGamma(psdId: PsdsUtil.shared.GetSelectedPsdId(), value: val)
//        PsdsUtil.shared.UpdateProcessedImage(psdId: PsdsUtil.shared.GetSelectedPsdId())
//        //print(DataRepository.shared.GetGamma(psdId: DataRepository.shared.GetSelectedPsdId()))
//    }
//
//    func GetGamma() -> CGFloat {
//        PsdsUtil.shared.GetGamma(psdId: PsdsUtil.shared.GetSelectedPsdId())
//    }
//
//    func SetExp(val: CGFloat){
//        //exp = val
//        PsdsUtil.shared.SetExp(psdId: PsdsUtil.shared.GetSelectedPsdId(), value: val)
//        PsdsUtil.shared.UpdateProcessedImage(psdId: PsdsUtil.shared.GetSelectedPsdId())
//    }
//
//    func GetExp() -> CGFloat{
//        PsdsUtil.shared.GetExp(psdId: PsdsUtil.shared.GetSelectedPsdId())
//    }
    
    
}
