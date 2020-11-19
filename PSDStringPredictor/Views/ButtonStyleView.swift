//
//  ButtonStyleView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct RoundButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 20, height: 20)
            .foregroundColor(Color.white)
            //.background(Color.red)
            .clipShape(Circle())
    }
}
