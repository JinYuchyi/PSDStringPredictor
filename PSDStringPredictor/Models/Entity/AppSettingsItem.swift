//
//  Settings.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

struct AppSettingsItem : Codable {
    
    var Debug: Bool = false
    var DPICheck: Bool = true
    var PSPath: String = "/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app"
//    func encode(with coder: NSCoder) {
//        coder.encode(ShowDebugInfo, forKey: "ShowDebugInfo")
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init()
//    }
    
    
    

    
    
}
