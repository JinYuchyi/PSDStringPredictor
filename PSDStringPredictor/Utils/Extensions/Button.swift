//
//  Button.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 30/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
import SwiftUI
struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.blue : Color.gray)
    }
}
