//
//  EmailModel.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 5/17/25.
//

import Foundation

struct Email: Encodable {
    
    var to: String
    var message: emailMessage
    
    init(
    ) {
        self.to = ""
        self.message = TheMessageDoor.emailMessage(subject: "", text: "")
    }
    
    mutating func createEmail(to: String, k: Constants) {
        self.to = to
        self.message.subject = k.emailSubject
        self.message.text = k.emailText
//        self.message.html = k.emailHTML
        self.message.id = UUID().uuidString
    }
    
}

struct emailMessage: Encodable {
    
    var id: String
    var subject: String
    var text: String
//    var html: String
    
    init (
    subject: String,
    text: String
//    html: String
    ) {
        
        self.subject = subject
        self.text = text
//        self.html = html
        self.id = UUID().uuidString
    }
}
