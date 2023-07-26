/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import UIKit

open class MediaMessageSizeCalculator: MessageSizeCalculator {

    open override func messageContainerSize(for message: MessageType) -> CGSize {
        
        let maxWidth = messageContainerMaxWidth(for: message)
        let sizeForMediaItem = { (maxWidth: CGFloat, item: MediaItem) -> CGSize in
            if maxWidth < item.size.width {
                // Maintain the ratio if width is too great
                let height = maxWidth * item.size.height / item.size.width
                print("April133",  CGSize(width: maxWidth, height: height))
                return CGSize(width: maxWidth, height: height)
            }
            return item.size
        }
        switch message.kind {
        case .photo(let item):
            guard let url = item.url else { return item.size}
            if url.pathExtension == "jpg" || url.pathExtension == "pdf" || url.pathExtension == "png" || url.pathExtension == "jpeg" {
                var width: Double = 0
                var height: Double = 0
                var multiplicator = item.size.height / item.size.width
                switch multiplicator {
                case 0..<1:
                    width = UIScreen.main.bounds.width * 0.75
                case 1:
                    width = UIScreen.main.bounds.width * 0.75
                default:
                    width = UIScreen.main.bounds.width * 0.45
                }
                height = width * item.size.height / item.size.width
                print("April13",  CGSize(width: width, height: height))
                return CGSize(width: width, height: height)
            } else {
                return sizeForMediaItem(maxWidth, item)
            }
        case .video(let item):
            return sizeForMediaItem(maxWidth, item)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
    }
}
