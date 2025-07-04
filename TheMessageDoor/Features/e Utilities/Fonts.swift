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

//enum Fonts: Hashable {
//    case arial
//    case copperplate
//    case chalkduster
//    case noteworthy
//    case signpainter
//    case snellRoundhand
//    case timesNewRoman
//    case zapfino
//    
//    var title: String {
//        switch self {
//        case .arial: return "Arial"
//        case .copperplate: return "Copperplate"
//        case .chalkduster: return "Chalkduster"
//        case .noteworthy: return "Noteworthy"
//        case .signpainter: return "SignPainter"
//        case .snellRoundhand: return "Snell Roundhand"
//        case .timesNewRoman: return "Times New Roman"
//        case .zapfino: return "Zapfino"
//        }
//    }
//    
//    var fontSize: CGFloat {
//        switch self {
//        case .arial: return 25
//        case .copperplate: return 25
//        case .chalkduster: return 25
//        case .noteworthy: return 25
//        case .signpainter: return 35
//        case .snellRoundhand: return 35
//        case .timesNewRoman: return 25
//        case .zapfino: return 15
//        }
//    }
//}
