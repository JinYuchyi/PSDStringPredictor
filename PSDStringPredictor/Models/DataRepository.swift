//
//  DataRepository.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 10/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

class DataRepository {
    var psds = PSD()

    private var stringObjectListDict: [Int:[StringObject]] = [:]
    private var charFrameListDict: [Int:[CharFrame]] = [:]
    private var imageUrlDict: [Int: URL] = [:]
    private var stringObjectStatusDict: [Int:[UUID: Int]] = [:] //0 normal, 1 fixed, 2 ignored
    private var updateStringObjectList: [Int:[UUID]] = [:]
    private var StringObjectNameDict: [UUID:String] = [:]
    private var DragOffsetDict: [UUID: CGSize] = [:]
    private var alignmentDict: [UUID:Int] = [:]
    private var stringObjectOutputList: [Int:[StringObject]] = [:]
    private var psdColorMode : [Int:Int] = [:]
    private var thumbnailList: [Int: NSImage] = [:]
    
    //Global
    private var selectedPSDID: Int = 0
    private var selectedIDList: [UUID] = []
    private var stringOverlay: Bool = true
    private var frameOverlay: Bool = true
    private var indicatorTitle: String = ""
    private var warningContent: String = ""
        
    //Constant
    static let fontDecentOffsetScale: CGFloat = 0.6
    static let fontLeadingTable = [[34,41], [28,41], [22,28], [20,25], [17,22], [16,21], [15,20], [13,18], [12,16], [11,13]]
    
    func StringObjectListDictAppend(psdId: Int, stringObject: StringObject){
        if stringObjectListDict[psdId] == nil {
            stringObjectListDict[psdId] = []
        }
        if stringObjectListDict[psdId]!.contains(where: {$0.id == stringObject.id}) == false{
            stringObjectListDict[psdId]!.append(stringObject)
        }
    }
    
    func GetStringObjectFromOnePSD(psdId: Int, objId: UUID)->StringObject?{
        if stringObjectListDict[psdId] == nil  {
            return nil
        }else{
            return stringObjectListDict[psdId]!.FindByID(objId)
        }
    }
}
