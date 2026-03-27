package com.microblink.blinkcard.flutter.serialization

import android.graphics.Bitmap
import android.util.Base64
import com.microblink.blinkcard.core.result.BlinkCardSingleSideScanningResult
import com.microblink.blinkcard.core.result.CardAccountResult
import com.microblink.blinkcard.core.result.CardLivenessCheckResult
import com.microblink.blinkcard.core.result.CroppedImageResult
import com.microblink.blinkcard.core.result.DateResult
import com.microblink.blinkcard.core.session.BlinkCardScanningResult
import org.json.JSONObject
import java.io.ByteArrayOutputStream

object BlinkCardSerializationUtils {
    fun serializeBlinkCardScanningResult(result: BlinkCardScanningResult): String {
        val resultJson: MutableMap<String, Any> = mutableMapOf()

        result.issuingNetwork.let { resultJson["issuingNetwork"] = it }
        result.iban?.let { resultJson["iban"] = it }
        result.cardholderName?.let { resultJson["cardholderName"] = it }
        result.overallCardLivenessResult.let { resultJson["overallCardLivenessResult"] = it.name.lowercase() }
        result.cardAccounts.let {
            resultJson["cardAccounts"] = it.map { cardResult -> serializeCardAccountResult(cardResult) }
        }
        result.firstSideResult?.let { resultJson["firstSideResult"] = serializeSingleSideScanningResult(it) }
        result.secondSideResult?.let { resultJson["secondSideResult"] = serializeSingleSideScanningResult(it) }

        return JSONObject(resultJson).toString()
    }

    private fun serializeCardAccountResult(cardAccountResult: CardAccountResult): Map<String, Any> {
        val resultJson: MutableMap<String, Any> = mutableMapOf(
            "cardNumber" to cardAccountResult.cardNumber,
            "cardNumberValid" to cardAccountResult.cardNumberValid,
        )
        cardAccountResult.cardNumberPrefix?.let { resultJson["cardNumberPrefix"] = it }
        cardAccountResult.cvv?.let { resultJson["cvv"] = it }
        cardAccountResult.expiryDate?.let { resultJson["expiryDate"] = serializeDateResult(it) }
        cardAccountResult.cardCategory?.let { resultJson["cardCategory"] = it }
        cardAccountResult.issuerName?.let { resultJson["issuerName"] = it }
        cardAccountResult.issuerCountryCode?.let { resultJson["issuerCountryCode"] = it }
        cardAccountResult.issuerCountry?.let { resultJson["issuerCountry"] = it }
        cardAccountResult.issuerName?.let { resultJson["issuerName"] = it }
        cardAccountResult.issuerName?.let { resultJson["issuerName"] = it }

        return resultJson
    }

    private fun <T> serializeDateResult(dateResult: DateResult<T>): Map<String, Any> {
        val resultJson: MutableMap<String, Any> = mutableMapOf()

        dateResult.day?.let { resultJson["day"] = it }
        dateResult.month?.let { resultJson["month"] = it }
        dateResult.year?.let { resultJson["year"] = it }
        dateResult.originalString?.let { resultJson["originalString"] = it }
        dateResult.filledByDomainKnowledge.let { resultJson["filledByDomainKnowledge"] = it  }
        dateResult.successfullyParsed.let { resultJson["successfullyParsed"] = it  }

        return resultJson
    }

    private fun serializeSingleSideScanningResult(singleSideResult: BlinkCardSingleSideScanningResult): Map<String, Any> {
        val resultJson: MutableMap<String, Any> = mutableMapOf()
        singleSideResult.cardImage?.let { resultJson["cardImage"] = serializeCroppedImageResult(it) }
        singleSideResult.cardLivenessCheckResult.let {  resultJson["cardLivenessCheckResult"] = serializeCardLivenessCheckResult(it) }
        return resultJson
    }

    private fun serializeCardLivenessCheckResult(cardLivenessCheckResult: CardLivenessCheckResult): Map<String, Any> {
        val resultJson: MutableMap<String, Any> = mutableMapOf()
        cardLivenessCheckResult.photocopyCheckResult.let { resultJson["photocopyCheckResult"] = it.name.lowercase() }
        cardLivenessCheckResult.screenCheckResult.let { resultJson["screenCheckResult"] = it.name.lowercase() }
        cardLivenessCheckResult.cardHeldInHandCheckResult.let { resultJson["cardHeldInHandCheckResult"] = it.name.lowercase() }
        return resultJson
    }

    private fun serializeCroppedImageResult(croppedImageResult: CroppedImageResult): Map<String, String?> {
        return mapOf("image" to encodeBitmap(croppedImageResult.bitmap))
    }

    private fun encodeBitmap(bitmap: Bitmap?): String? {
        return bitmap?.let { bm ->
            val outputStream = ByteArrayOutputStream()
            outputStream.use { stream ->
                bm.compress(Bitmap.CompressFormat.JPEG, 95, stream)
                Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
            }
        }
    }
}