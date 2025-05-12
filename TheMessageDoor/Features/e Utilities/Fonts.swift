//
//  Fonts.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/9/25.
//

import Foundation

final class Fonts: ObservableObject {
    @Published var fontSize: CGFloat = 25
    @Published var fonts: [String] =
    [
        "Arial",
        "Copperplate",
        "Chalkduster",
        "Noteworthy",
        "SignPainter",
        "Snell Roundhand",
        "Times New Roman",
        "Zapfino"
    ]
    
    @Published var fontSizes: [CGFloat] =
    [
     25,25,25,25,35,35,25,15
    ]
    
    func getFontSize(font: String) -> CGFloat {
        var fontSize: CGFloat = 25
        if font != "" {
            let index = fonts.firstIndex(of: font)!
            self.fontSize = fontSizes[index]
        } else {
            self.fontSize = 25
        }
        fontSize = self.fontSize
        return fontSize
    }
}
