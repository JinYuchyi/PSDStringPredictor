//
//  StringObjectListData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class StringObjectList: ObservableObject{
    @Published var stringObjectListData: [StringObject]  = [
    ]
    
    func Count() -> Int{
        return stringObjectListData.count
    }
    
    func AddElement(NewElement element: StringObject){
        stringObjectListData.append(element)
    }
    
    func Clean(){
        stringObjectListData.removeAll()
    }
    
}
