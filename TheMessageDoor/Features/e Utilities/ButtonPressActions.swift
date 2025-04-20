//
//  ButtonPressActions.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/19/25.
//

import Foundation
import SwiftUI

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged ({ _ in
                        self.onPress()
                    })
                    .onEnded ({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
   func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
       modifier(ButtonPress(onPress: {onPress()}, onRelease: {onRelease()} ))
    }
}
