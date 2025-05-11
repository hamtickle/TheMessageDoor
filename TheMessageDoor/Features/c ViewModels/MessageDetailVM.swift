//
//  MessageDetailVM.swift
//  TheMessageDoor
//
//  Created by Graham Tickell on 4/20/25.
//

import Foundation

@MainActor
class MessageDetailVM: ObservableObject {

    @Published private(set) var message: Message? = nil
    private var mVM: MessageListVM = MessageListVM()
    @Published var currentReceiver: Profile? = nil
    @Published var selectedReceiverEmail: String = ""
    @Published var currentSenderFavorite: Bool = false
    @Published var currentReceiverFavorite: Bool = false

    @Published var isNewMessage: Bool = false

    @Published var messageFont: String = ""

    @Published var updateMessageSuccessful: Bool = false
    @Published var messageDeleted: Bool = false
    @Published var savedSent: Bool = false

    init() {
    }

    func sendSavedMessage(message: Message) {
        var updatedMessage = message.sendSavedMessage()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                savedSent = true
                try? await mVM.fetchSenderMessages(senderId: updatedMessage.senderId)
                
            } catch {
                print("Could not send message \(error.localizedDescription)")
            }
        }
    }

    func toggleSenderFavorite(message: Message) {
        var updatedMessage = message.toggleSenderFavorite()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                try? await mVM.fetchSenderMessages(senderId: updatedMessage.senderId)
            } catch {
                print("Could not toggle favorite \(error.localizedDescription)")
            }
        }

    }

    func toggleReceiverFavorite(message: Message) {
        let updatedMessage = message.toggleReceiverFavorite()

        Task {
            do {
                _ = try await MessageManager.shared.updateMessage(
                    message: updatedMessage)
                mVM.reloadList = true
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
                print("message deleted: \(messageDeleted)")
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

    }

}
