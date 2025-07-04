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
    
    // App Control
    let allowSignatures = false
    let showIds = false
    
    // defaults
    let appFont = "Arial"
    let appFontSize: CGFloat = 12
    let appSignature = "no signature on file"
    let appProfileURL = "no profile URL on file"
    
    // Orders
    let newRecipient: String = "New Recipient"
    let typeMonthly: String = "Monthly"
    let type30Day: String = "30 days"
    let typeAnnual: String = "Annual"
    let typeComp : String = "Comp"
    let statusActive: String = "Active"
    let statusExpired: String = "Expired"
    let blankOrderType: OrderType = OrderType(
        orderTypeId: "", type: "Select Order Type",
        price: 0.0,
        description:
            "Please select an order type from the options available.",
        minDuration: 0)
    
    // Messages
    let statusSaved: String = "UnSent"
    let statusSent: String = "Sent"
    let statusRead: String = "Read"
  
    // Dates
    let oldDate = Date() - 365*24*60*60*50
    
    // UserDefaults Key
    let user = "user"
    
    //emails
    let emailSubject = "You have a new message on your MessageDoor"
    let emailText = "Hello, this is a new message from TheMessageDoor"
    let emailHTML = "no html for you"
    let emailTester = "7ickell@gmail.com"
    
    // Messages
    let chooseFont = "Choose the font you want for your messages."
    let messageSent = "THIS MESSAGE HAS BEEN SENT"
    let messageSentToYou = "THIS MESSAGE WAS SENT TO YOU"
    
    // Alerts
    let profileUpdated = "Your profile was updated successfully!"
    let profileIncomplete = "Your profile is incomplete. \n Please complete it before continuing."
    let noMessages = "You have not created any messages yet."
    let noOrders = "You do not have any ACTIVE orders.  \n Please create an order so you can send messages."
    let messageSaved = "Your message has been saved."
    let messageDeleted = "Your message has been deleted."
    let messageSent2 = "Your message has been sent."
    let orderCreated = "Your order has been created. \n Thank You."
    let orderDuplicate =  "You have an active order for this Person. \n Please use the existing order."
    
}
