//
//  FileMessageCell.swift
//  
//
//  Created by Iurii Kotikhin on 26.07.2023.
//

import UIKit

/// A subclass of `MessageContentCell` used to display text messages.
open class FileMessageCell: MessageContentCell {

    // MARK: - Properties

    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }

    /// The label used to display the message's text.
    open var messageLabel = MessageLabel()

    // MARK: - Methods

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.textInsets = attributes.messageLabelInsets
            messageLabel.messageLabelFont = attributes.messageLabelFont
            messageLabel.frame = messageContainerView.bounds
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(messageLabel)
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            let textMessageKind = message.kind.textMessageKind
            switch textMessageKind {
            case .file(let item):
                guard let shortName = item.url?.lastPathComponent else { return }
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                if shortName == "file_29.svg" {
                    messageLabel.text = "know know know know know know know knowknow know knowfile_29.svg"
                } else {
                    messageLabel.text = shortName
                }
                messageLabel.textColor = textColor
                if let font = messageLabel.messageLabelFont {
                    messageLabel.font = font
                }
//            case .attributedText(let text):
//                messageLabel.attributedText = text
            default:
                break
            }
        }
    }

    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return messageLabel.handleGesture(touchPoint)
    }

}
