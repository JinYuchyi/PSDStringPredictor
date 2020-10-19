//
//  ViewExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI

extension View{
    func IsHidden( condition: Bool)-> some View{
        if (condition == false) {
            return AnyView(self.hidden())
        }else{
            return AnyView(self)
        }
    }
}
