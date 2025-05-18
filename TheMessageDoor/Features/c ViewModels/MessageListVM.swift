//
//  MessageListVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class MessageListVM: ObservableObject {

    private var k: Constants = Constants()
    //    @ObservableObject var currentUser: GetCurrentUser
    @Published private(set) var message: Message? = nil

    @Published var reloadList: Bool = false

    @Published var displayMessages: [Message] = []

    init() {

    }

    func fetchSenderMessages(senderId: String) async {
        print("mlVM getting sender's messages for \(senderId) \n")

        do {
            let displayMessages = try await MessageManager.shared.getMessages(
                senderId: senderId)

            self.displayMessages = displayMessages
//            print("mlVM: fetched messages: \n \(displayMessages) \n")
            sortMessagesByDate()
        } catch {
            print("Error retrieving messages: \(error)")
        }

    }

    func fetchReceiverMessages(to: String) async {
        print("mVM getting received messages for \(to) \n")
        let displayMessges = try? await MessageManager.shared
            .getReceiverMessages(to: to)

        self.displayMessages = displayMessges ?? []
        sortMessagesByDate()

        //        buildSenderStats()
    }

    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
    }

    func getUserID() -> String {
        guard
            let data = UserDefaults.standard.data(forKey: "userId"),
            case let userId = try? JSONDecoder().decode(String.self, from: data)
        else { return "" }
        return userId!
    }

    func updateMessageArray(message: Message) {
        // find index of message in displayMessage array
        print(
            "\n Start looking for message in message Array \(message.messageId)"
        )
        print(displayMessages)
        if let messageIndex = displayMessages.firstIndex(where: {
            $0.messageId == message.messageId
        }) {
            displayMessages[messageIndex] = message
            print("displayMessages updated")
        }

    }

}
