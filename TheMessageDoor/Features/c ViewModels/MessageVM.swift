//
//  MessageListVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Combine
import Foundation

@MainActor
class MessageVM: ObservableObject {

    private var k: Constants = Constants()
    private var rm: ReceiverManager = ReceiverManager()

    @Published private(set) var message: Message? = nil
    @Published var displayMessages: [Message] = []
    @Published var senderMessages: [Message] = []
    @Published var receivedMessages: [Message] = []
    var senderFavorites: [Message] = []
    var senderUnsent: [Message] = []
    var sentUnread: [Message] = []
    var receivedFavorites: [Message] = []
    var receivedUnread: [Message] = []
    var result: [Message] = []
    var preFilteredMessages: [Message] = []

    @Published var searchText: String = ""
    @Published var currentReceiver: Profile? = nil
    @Published var selectedReceiverEmail: String = ""
    @Published var currentReceiverFirstName: String = ""
    @Published var currentReceiverLastName: String = ""
    @Published var currentReceiverEmail: String = ""
    @Published var messageFont: String = ""
    @Published var fontSize: CGFloat = 25

    @Published var userStats: UserStats = UserStats(userId: "")

    @Published var messageDeleted: Bool = false
    @Published var savedSent: Bool = false
    @Published var reloadList: Bool = false
    @Published var currentSenderFavorite: Bool = false
    @Published var currentReceiverFavorite: Bool = false
    @Published var updateMessageSuccessful: Bool = false
    @Published var noOrders: Bool = false
    @Published var initialLoad: Bool = true

    @Published var currentMessage: String = ""
    var emailMessage: Email = Email()
    @Published var receiverList: [String] = []

    @Published var unReadMessages: Int = 0
    @Published var isUnread: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {

        let user = GetCurrentUser.shared.fetchUserDefaults()
        addSubscribers()

        if initialLoad {
            initialLoad = false
        }

    }

    // MARK:     Message List Functions

    func fetchSenderMessages(senderId: String) async {
        print("mlVM getting sender's messages for \(senderId) \n")

        do {
            let sentMessages = try await MessageManager.shared.getMessages(
                senderId: senderId)

            // is this running on the main thread to update teh view?
            self.displayMessages = sentMessages
            self.senderMessages = sentMessages
            
            self.senderFavorites = self.senderMessages.filter({
                $0.senderFavorite == true
            })
            self.senderUnsent = self.senderMessages.filter({
                $0.messageStatus == k.statusSaved
            })
            self.sentUnread = self.senderMessages.filter({
                $0.messageStatus == k.statusSent
            })
            //            print("mlVM: fetched messages: \n \(displayMessages) \n")
            sortMessagesByDate()
        } catch {
            print("Error retrieving messages: \(error)")
        }

    }

    func fetchReceiverMessages(to: String) async {
        print("mVM getting received messages for \(to) \n")
        let receivedMessges = try? await MessageManager.shared
            .getReceiverMessages(to: to)

        self.displayMessages = receivedMessges ?? []
        self.receivedMessages = receivedMessges ?? []

        sortMessagesByDate()
        // Select Favorites
        receivedFavorites = receivedMessages.filter({
            $0.receiverFavorite == true
        })

        // select unRead
        unReadMessages =
            receivedMessages.filter({ $0.messageStatus == k.statusSent }
            ).count

        if unReadMessages > 0 {
            isUnread = true
            receivedUnread = receivedMessages.filter({
                $0.messageStatus != k.statusRead
            })

        } else {
            isUnread = true
            receivedUnread = []
        }
    }

    func sortMessagesByDate() {
        displayMessages.sort { (message1, message2) -> Bool in
            return message1.dateCreated > message2.dateCreated
        }
    }

    func displayMessages(
        messageFilter: Int, myMessages: Int, senderId: String,
        senderEmail: String
    ) async {
        if messageFilter == 0 {
            await fetchSenderMessages(
                senderId: senderId)
        } else {
            await fetchReceiverMessages(
                to: senderEmail)
        }
    }

    func addSubscribers() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            //            .combineLatest($displayMessages)
            .map { (text) -> [Message] in
                guard !text.isEmpty else {
                    return self.displayMessages
                }
                self.preFilteredMessages = self.displayMessages
                let lowercasedText = text.lowercased()

                return self.displayMessages.filter {
                    (message) -> Bool in
                    return message.message.lowercased().contains(lowercasedText)
                }
                //                self.displayMessages = self.result
                //                return self.displayMessages
            }
            .sink { [weak self] (returnedMessages) in
                self?.displayMessages = returnedMessages
            }
            .store(in: &cancellables)
    }
    
    func restoreMessages() {
        displayMessages = preFilteredMessages
    }

    func searchMessages(searchText: String) {
        result = displayMessages.filter({
            $0.message.lowercased().contains(searchText.lowercased())
        })
        displayMessages = result
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

    // MARK:   Message Detail Functions

    func sendSavedMessage(message: Message) {

        let updatedMessage = message.sendSavedMessage()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                savedSent = true
                await fetchSenderMessages(senderId: updatedMessage.senderId)

            } catch {
                print("Could not send message \(error.localizedDescription)")
            }
        }
        // update user statistics

        Task {
            userStats = try await StatManager.instance.getUserStats(
                senderId: updatedMessage.senderId)

            userStats.updateTotalMessagesSent()

            if updatedMessage.senderFavorite {
                userStats.updateTotalMyFavorites()
            }
            try await StatManager.instance.updateStats(stats: userStats)
        }
    }

    func toggleFavorite(message: Message) {
        let updatedMessage = message

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                //                await mVM.fetchSenderMessages(senderId: updatedMessage.senderId)
            } catch {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }
        // update user statistics

        Task {
            userStats = try await StatManager.instance.getUserStats(
                senderId: updatedMessage.senderId)

            if updatedMessage.senderFavorite {
                userStats.updateTotalMyFavorites()
            }
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
        // update user statistics

        Task {
            userStats = try await StatManager.instance.getUserStats(
                senderId: updatedMessage.senderId)

            if updatedMessage.receiverFavorite {
                userStats.updateTotalMyFavorites()
            }
            try await StatManager.instance.updateStats(stats: userStats)
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
                print("message deleted: \(messageDeleted) \n")
                //                await fetchSenderMessages(senderId: thisSender)
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
                print(updatedMessage)
            } catch {
                print("Could not save message \(error.localizedDescription)")
            }
        }
        // update array of messages

    }

    //  MARK:  Message Create Functions

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

        Task {
            await fetchSenderMessages(senderId: senderId)
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
