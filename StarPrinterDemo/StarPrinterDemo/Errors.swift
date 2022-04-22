//
//  Errors.swift
//  CellarPass Table App
//
//  Created by Cristian Miehs on 4/26/17.
//  Copyright © 2017 CellarPass. All rights reserved.
//

enum GlobalError : Error
{
    case authenticationError(message : String)
    case defaultError(message : String)
    case twilioLookUpError(message: String)
    case notImplementedError
//    case serverError(errorInfo: ErrorInfo?)
//    case bookingError(errorType : ErrorInfoType, message1: NSAttributedString, message2: NSAttributedString)
//    case backPressed(popupType: PopupType)
    case userStepCancelled
    case missingData(message: String)
    case cancelPressed
    case conditionsNotMet
    case incorrectInventoryModeError
    case preAssignServerAndTableError(message: String)
}

enum UpdateSessionError : Error
{
    case defaultError(message : String)
//    case tableStatesChanged(tables : [Table])
}
