//
//  HogErrors.swift
//  iHog
//
//  Created by Jay Wilson on 1/19/22.
//

import Foundation

public enum OSCErrors: String, Error {
    case FailedToCreateMessage = "Message was not created"
    case UDPFailedToSend = "UDP didn't send message"
    case TCPFailedToSend = "TCP didn't send message"
    case UDPClientNotConnect
    case TCPClientNotConnect
    case UDPServerNotSet
    case UDPServerNotConnect
    case TCPServerNotConnect
}
