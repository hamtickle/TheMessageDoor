//
//  MessageCreateVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class MessageCreateVM: ObservableObject {

    @Published private(set) var message: Message? = nil
    var pVM: ProfileVM = ProfileVM()
    private var mVM: MessageListVM = MessageListVM()
    private var rm: ReceiverManager = ReceiverManager()
    private var k: Constants = Constants()
    var emailMessage: Email = Email()

    @Published var userStats: UserStats = UserStats(userId: "")

    //    @Published var currentReceiver: Profile? = nil
    @Published var receiverList: [String] = []
    @Published var selectedReceiverEmail: String = ""

    @Published var currentReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""

    @Published var currentMessage: String = ""
    @Published var currentSenderFavorite: Bool = false

    @Published var displayMessages: [Message] = []
    @Published var messageFont: String = ""
    @Published var fontSize: CGFloat = 25

    @Published var updateMessageSuccessful: Bool = false
    @Published var messageDeleted: Bool = false
    @Published var savedSent: Bool = false
    @Published var noOrders: Bool = false

    init() {
    }

    func createMessage(
        from: String, senderId: String, to: String,
        message: String, senderFavorite: Bool, isSent: Bool,
        messageFont: String, messageFontSize: CGFloat, messageStatus: String
    ) {  //     guard let message else { return }
        let updatedMessage = Message(
            messageId: UUID().uuidString, from: from, senderId: senderId,
            to: to, message: message, messageFont: messageFont,
            messageFontSize: messageFontSize,
            senderFavorite: senderFavorite, dateCreated: Date(), isSent: isSent,
            dateSent: Date(), messageStatus: messageStatus,
            messageDateOpened: Date(), receiverFavorite: false,
            receiverDeleted: false, lastUpdated: Date()
        )
        Task {
            try await MessageManager.shared.updateMessage(
                message: updatedMessage)
            updateMessageSuccessful.toggle()
            currentMessage = ""
        }
        
        if isSent {
            emailMessage.createEmail(to: k.emailTester, k: k)
            emailManager.instance.sendEmail(
                email: emailMessage)
        }
        
        // update user statistics

        Task {
            userStats = try await StatManager.instance.getUserStats(
                senderId: senderId)

            userStats.updateTotalMessagesCreated()
            if isSent {
                userStats.updateTotalMessagesSent()
            }
            if senderFavorite {
                userStats.updateTotalMyFavorites()
            }
            try await StatManager.instance.updateStats(stats: userStats)
        }

    }

    func fetchSenderMessages(senderId: String) async {
        await mVM.fetchSenderMessages(senderId: senderId)
    }

    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
    }

    func sendSavedMessage(message: Message) {
        let updatedMessage = message.sendSavedMessage()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                savedSent = true
                await fetchSenderMessages(senderId: message.messageId)
            } catch {
                print("Could not send message \(error.localizedDescription)")
            }
        }
        userStats.updateTotalMessagesSent()
        Task {
            try await StatManager.instance.updateStats(stats: userStats)
        }

    }

    func toggleSenderFavorite(message: Message) {
        let updatedMessage = message.toggleSenderFavorite()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
            } catch {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }

        // update statistics
        userStats.updateTotalMyFavorites()

        Task {
            try await StatManager.instance.updateStats(stats: userStats)
        }

    }

    func toggleReceiverFavorite(message: Message) {
        let updatedMessage = message.toggleReceiverFavorite()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
            } catch {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }

    }

    func receiverDeleteMessage(message: Message) {
        let updatedMessage = message.receiverDeleteMessage()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
            } catch {
                print("Could not delete message \(error.localizedDescription)")
            }
        }

    }

    func senderDeleteMessage(message: Message) {

        Task {
            do {
                let thisSender = message.senderId
                try await MessageManager.shared.deleteMessage(
                    messageId: message.messageId)
                messageDeleted = true
                await fetchSenderMessages(senderId: thisSender)
            } catch {
                print("Could not delete message \(error.localizedDescription)")
                messageDeleted = false
            }
        }

    }

    func saveMessage(message: Message) {

        let updatedMessage = message.saveMessage()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)

            } catch {
                print("Could not delete message \(error.localizedDescription)")
            }
        }

    }

    func getReceivers(senderId: String) async throws {
        receiverList = try await rm.getReceivers(senderId: senderId)

        if receiverList.isEmpty {
            noOrders = true
        } else {
            getReceiverInfo(email: receiverList[0])
        }
    }

    func getReceiverInfo(email: String) {
        var First: String = ""
        var Last: String = ""

        (First, Last) = rm.getReceiverInfo(email: email)

        self.currentReceiverFirstName = First
        self.currentReceiverLastName = Last
        self.currentReceiverEmail = email
    }

}
