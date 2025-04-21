//
//  ReceiverManager.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class ReceiverManager: ObservableObject {
    
    @Published var receiverList: [String] = []
 
    func getReceivers(senderId: String) async throws{
        let result = try await OrderManager.shared.getReceivers(senderId: senderId)
        
        // remove duplicates from receiverlist
        receiverList = result.unique()
        sortReceivers()
        print (receiverList)
    }
    
    func sortReceivers() {
        receiverList.sort { (email1, email2) -> Bool in
            return email1 < email2
        }
    }
    
}
