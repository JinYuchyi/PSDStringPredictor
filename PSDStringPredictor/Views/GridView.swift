//
//  GridView.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/3/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var psdsVM: PsdsVM
    let gap: CGFloat = 100
    var body: some View {
        GeometryReader { geometry in
                    Path { path in
                        let numberOfHorizontalGridLines = Int(geometry.size.height / gap)
                        let numberOfVerticalGridLines = Int(geometry.size.width / gap)
                        for index in 0...numberOfVerticalGridLines {
                            let vOffset: CGFloat = CGFloat(index) * gap
                            path.move(to: CGPoint(x: vOffset, y: 0))
                            path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                        }
                        for index in 0...numberOfHorizontalGridLines {
                            let hOffset: CGFloat = CGFloat(index) * gap
                            path.move(to: CGPoint(x: 0, y: hOffset))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: hOffset))
                        }
                    }
                    .stroke()
                    .foregroundColor(.red)
                    .blendMode(.difference)
                }

    }
}
//
//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}
