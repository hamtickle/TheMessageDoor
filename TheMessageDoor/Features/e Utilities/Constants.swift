//
//  Constants.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/22/25.
//

import Foundation

@MainActor
public struct Constants {
    public static let bundleIdentifier = "com.grahamtickell.TheMessageDoor"
    
    let appFont = "Arial"
    let appFontSize: CGFloat = 12
    let appSignature = "no signature on file"
    let appProfileURL = "no profile URL on file"
    
    // Orders
    let typeMonthly: String = "Monthly"
    let typeComp : String = "Comp"
    let statusActive: String = "Active"
    let statusExpired: String = "Expired"
    
    // Messages
    let statusSaved: String = "UnSent"
    let statusSent: String = "Sent"
    let statusRead: String = "Read"
  
    // Dates
    let oldDate = Date() - 365*24*60*60*50
    
    // UserDefaults Key
    let user = "user"
    
}
