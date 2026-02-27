//
//  BlinkCardSerializationUtils.swift
//  blinkcard_flutter
//
//  Created by Milan Parađina on 27.02.2026..
//

import Foundation
import UIKit
import BlinkCard

struct BlinkCardSerializationUtils {
    static func serializeBlinkCardScanningResult(_ result: BlinkCardScanningResult) -> String {
        var resultDict: [String: Any] = [
            "issuingNetwork": result.issuingNetwork,
            "cardAccounts": result.cardAccounts.map( {serializeCardAccountResult($0)} )
        ]
        
        if let iban = result.iban {
            resultDict["iban"] = iban
        }
        
        if let cardholderName = result.cardholderName {
            resultDict["cardholderName"] = cardholderName
        }
        
        resultDict["overallCardLivenessResult"] = result.overallCardLivenessResult.rawValue
        
        if let firstSideResult = result.firstSideResult {
            resultDict["firstSideResult"] = serializeSingleSideScanningResult(firstSideResult)
        }
        
        if let secondSideResult = result.secondSideResult {
            resultDict["secondSideResult"] = serializeSingleSideScanningResult(secondSideResult)
        }
        
        return encodeToJson(resultDict)
    }
    
    static func serializeCardAccountResult(_ cardAccountResult: CardAccountResult) -> [String: Any] {
        var cardAccountDict: [String: Any] = [
            "cardNumber": cardAccountResult.cardNumber,
            "cardNumberValid": cardAccountResult.cardNumberValid
        ]
        
        if let cardNumberPrefix = cardAccountResult.cardNumberPrefix {
            cardAccountDict["cardNumberPrefix"] = cardNumberPrefix
        }
        if let cvv = cardAccountResult.cvv {
            cardAccountDict["cvv"] = cvv
        }
        if let expiryDate = cardAccountResult.expiryDate {
            cardAccountDict["expiryDate"] = serializeDateResult(expiryDate)
        }
        if let fundingType = cardAccountResult.fundingType {
            cardAccountDict["fundingType"] = fundingType
        }
        if let issuerName = cardAccountResult.issuerName {
            cardAccountDict["issuerName"] = issuerName
        }
        if let issuerCountryCode = cardAccountResult.issuerCountryCode {
            cardAccountDict["issuerCountryCode"] = issuerCountryCode
        }
        if let issuerCountry = cardAccountResult.issuerCountry {
            cardAccountDict["issuerCountry"] = issuerCountry
        }
        if let cardCategory = cardAccountResult.cardCategory {
            cardAccountDict["cardCategory"] = cardCategory
        }
        
        return cardAccountDict
    }
    
    static func serializeSingleSideScanningResult(_ singleSideScanningResult: SingleSideScanningResult) -> [String: Any] {
        var singleSideScanningResultDict: [String: Any] = [:]
        
        if let cardImage = singleSideScanningResult.cardImage {
            singleSideScanningResultDict["cardImage"] = serializeCroppedImageResult(cardImage)
        }
        
        singleSideScanningResultDict["cardLivenessCheckResult"] = serializeCardLivenessCheckResult(singleSideScanningResult.cardLivenessCheckResult)
        
        return singleSideScanningResultDict
    }
    
    static func serializeCroppedImageResult(_ croppedImageResult: CroppedImageResult) -> [String: Any] {
        return ["image": encodeImage(croppedImageResult.uiImage)]
    }
    
    static func serializeDateResult(_ dateResult: DateResult) -> [String: Any] {
        var dateResultDict: [String: Any] = [
            "originalString" : dateResult.originalString,
            "filledByDomainKnowledge" : dateResult.filledByDomainKnowledge,
            "successfullyParsed" : dateResult.successfullyParsed
        ]
        if let day = dateResult.day {
            dateResultDict["day"] = day
        }
        if let month = dateResult.month {
            dateResultDict["month"] = month
        }
        if let year = dateResult.year {
            dateResultDict["year"] = year
        }
            
        return dateResultDict
    }
    
    static func serializeCardLivenessCheckResult(_ cardLivenessCheckResult: CardLivenessCheckResult) -> [String: Any] {
        return [
            "screenCheckResult": cardLivenessCheckResult.screenCheckResult.rawValue,
            "photocopyCheckResult": cardLivenessCheckResult.photocopyCheckResult.rawValue,
            "cardHeldInHandCheckResult": cardLivenessCheckResult.cardHeldInHandCheckResult.rawValue,
        ]
    }
    
    static func encodeToJson(_ dict: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let resultForJson = String(data: jsonData, encoding: .utf8)
            return resultForJson ?? ""
        } catch {
            return ""
        }
    }
    static func encodeImage(_ image: UIImage?) -> String? {
        return image?.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
}
