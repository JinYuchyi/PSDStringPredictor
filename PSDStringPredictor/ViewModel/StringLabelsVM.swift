//
//  StringLabelsVM.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation

class StringLabelsVM: ObservableObject {
    //let dataResp = DataRepository()
    @Published var stringObjectList: [StringObject] = []
    @Published var positionList: [CGPoint] = []
    //@Published var statusList: [Int] = []
    
    func FetchStringObjectList(){
        stringObjectList = DataRepository.shared.GetStringObjectsForOnePsd(psdId: DataRepository.shared.GetSelectedPsdId())
    }
    
    func FetchPositionList(){
        var result = [CGPoint]()
        for obj in stringObjectList{
            let x = obj.stringRect.origin.x + obj.stringRect.width/2
            let y = DataRepository.shared.GetSelectedNSImage().size.height - obj.stringRect.origin.y - obj.stringRect.height / 2
            result.append(CGPoint(x: x, y: y))
        }
        positionList = result
    }
    
    //MARK: Intensions
    func StringClicked(objId: UUID){
        print("StringClicked")
    }
    
    func alignmentClicked(objId: UUID){
        print("alignmentClicked")
    }
    
    func FixClicked(objId: UUID){
        print("FixClicked")
    }
    
    func IgnoreClicked(objId: UUID){
        print("IgnoreClicked")
    }
    
}
