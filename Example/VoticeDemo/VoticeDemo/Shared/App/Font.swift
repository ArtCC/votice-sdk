//
//  Font.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

extension Font {
    static func poppins(_ style: PoppinsFont, size: CGFloat) -> Font {
        Font.custom(style.rawValue, size: size)
    }
}
