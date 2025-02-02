//
//  Enumerated.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

enum Alert {
    case none, success, failed, server, network, invalidInput, duplicate, json, data, noLogin, wrongCode, moreSendCode, area, noDriver, ban
}

enum Gender: Int {
    case male, female
}

enum MarkerType: String {
    case car, fromLocation, toLocation, secendLocation
}

enum OptionService {
    case none, secendPlace, goAndBack, stopWay
}

enum PaymentMethod {
    case bank, cash
}

enum InTravel {
    case driverAccepted, startTravel, cancelTravel, driverInLocation, callRequest, travelInfoReceived, finishedTaxi
}

enum Support {
    case travel, app, other
}
