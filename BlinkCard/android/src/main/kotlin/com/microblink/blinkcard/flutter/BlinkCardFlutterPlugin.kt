package com.microblink.blinkcard.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.microblink.blinkcard.core.BlinkCardSdk
import com.microblink.blinkcard.core.image.InputImage
import com.microblink.blinkcard.core.ping.PingManager
import com.microblink.blinkcard.core.ping.pinglets.WrapperProductInfo
import com.microblink.blinkcard.core.session.BlinkCardProcessResult
import com.microblink.blinkcard.flutter.serialization.BlinkCardDeserializationUtils
import com.microblink.blinkcard.flutter.serialization.BlinkCardSerializationUtils
import com.microblink.blinkcard.ux.contract.BlinkCardScanActivitySettings
import com.microblink.blinkcard.ux.contract.MbBlinkCardScan
import com.microblink.blinkcard.ux.contract.ScanActivityResultStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlin.time.Duration.Companion.milliseconds

/** BlinkCardFlutterPlugin */
class BlinkCardFlutterPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var flutterResult: Result
    private var flutterPluginActivity: Activity? = null
    private var blinkCardSdk: BlinkCardSdk? = null

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        flutterResult = result
        when(BlinkCardPlatformMethods.fromMethod(call.method)) {
            BlinkCardPlatformMethods.PERFORM_SCAN -> (CoroutineScope(Dispatchers.Main).launch { performScan(call, result) })
            BlinkCardPlatformMethods.PERFORM_DIRECT_API_SCAN -> (CoroutineScope(Dispatchers.Main).launch { performDirectApiScan(call, result) })
            BlinkCardPlatformMethods.LOAD_SDK -> (CoroutineScope(Dispatchers.Main).launch { loadSdk(call, result) })
            BlinkCardPlatformMethods.UNLOAD_SDK -> unloadSdk(call, result)
            else -> result.notImplemented()
        }
    }

    private suspend fun performScan(call: MethodCall, result: Result) {
        try {
            val sdkSettingsRaw = call.argument<Map<String, Any>>(BlinkCardArguments.sdkSettings)
            val sessionSettingsRaw = call.argument<Map<String, Any>>(BlinkCardArguments.sessionSettings)
            val scanningUxSettingsRaw = call.argument<Map<String, Any>>(BlinkCardArguments.scanningUxSettings)

            blinkCardSdk = ensureLoadedSdk(call)

            flutterPluginActivity?.let {
                val intent = MbBlinkCardScan().createIntent(
                    it,
                    BlinkCardScanActivitySettings(
                        sdkSettings = BlinkCardDeserializationUtils.deserializeBlinkCardSdkSettings(sdkSettingsRaw),
                        scanningSessionSettings = BlinkCardDeserializationUtils.deserializeBlinkCardSessionSettings(sessionSettingsRaw),
                        uxSettings = BlinkCardDeserializationUtils.deserializeScanningUxSettings(
                            stepTimeoutDuration = (sessionSettingsRaw?.get("stepTimeTimeoutInterval") as? Int ?: 15000).milliseconds,
                            allowHapticFeedback = scanningUxSettingsRaw?.get("allowHapticFeedback") as? Boolean ?: true),
                        cameraSettings = BlinkCardDeserializationUtils.deserializeCameraSettings(scanningUxSettingsRaw?.get("preferredCameraPosition") as? String ?: "front"),
                        showOnboardingDialog = scanningUxSettingsRaw?.get("showIntroductionAlert") as? Boolean ?: true,
                        showHelpButton = scanningUxSettingsRaw?.get("showHelpButton") as? Boolean ?: true,
                    )
                )

                it.startActivityForResult(intent, BlinkCardArguments.blinkCardRequestCode)
                addFlutterPinglet(it)
            } ?: result.error(BlinkCardArguments.blinkcardError, "Activity not found", null)
        } catch (error: Exception) {
            result.error(BlinkCardArguments.blinkcardError, error.message, null)
        } finally {
            blinkCardSdk = null
        }
    }

    private suspend fun performDirectApiScan(call: MethodCall, result: Result) {
        try {
            val sessionSettingsRaw = call.argument<Map<String, Any>>(BlinkCardArguments.sessionSettings)
            val firstSideImage = call.argument<String>(BlinkCardArguments.firstSideImage)
            val secondSideImage = call.argument<String>(BlinkCardArguments.secondSideImage)
            blinkCardSdk = ensureLoadedSdk(call)

            blinkCardSdk?.let {
                flutterPluginActivity?.let { activity -> addFlutterPinglet(context = activity.applicationContext) }

                val session = it.createScanningSession(BlinkCardDeserializationUtils.deserializeBlinkCardSessionSettings(sessionSettingsRaw, true))
                var result: kotlin.Result<BlinkCardProcessResult>? = null

                firstSideImage?.let { base64Image ->
                    BlinkCardDeserializationUtils.base64ToBitmap(base64Image)?.let { bm ->
                        result = session.process(InputImage.createFromBitmap(bm))
                    }
                }

                secondSideImage?.let { base64Image ->
                    BlinkCardDeserializationUtils.base64ToBitmap(base64Image)?.let { bm ->
                        result = session.process(InputImage.createFromBitmap(bm))
                    }
                }

                if (result?.isSuccess == true) {
                    val scanningResult = session.getResult()
                    flutterResult.success(BlinkCardSerializationUtils.serializeBlinkCardScanningResult(scanningResult))
                } else {
                    flutterResult.error(BlinkCardArguments.blinkcardError, "The result is empty", null)
                }


            }?: result.error(BlinkCardArguments.blinkcardError, BlinkCardFlutterError.InitializationError("The BlinkCard SDK is not initialized. Call the loadSdk() method to pre-load the SDK first, or try running the performDirectApiScan() method with a valid internet connection.").message, null)
        } catch (error: Exception) {
            result.error(BlinkCardArguments.blinkcardError, error.message, null)
        } finally {
            closeSdk()
        }
    }

    private suspend fun loadSdk(call: MethodCall, result: Result) {
        try {
            ensureLoadedSdk(call)
            result.success(true)
        } catch (error: Exception) {
            blinkCardSdk = null
            result.error(BlinkCardArguments.blinkcardError, error.message, null)
        }
    }

    private fun unloadSdk(call: MethodCall, result: Result) {
        try {
            val deleteCachedResources = call.argument<Boolean>("deleteCachedResources")
            deleteCachedResources?.let {
                if (it) BlinkCardSdk.sdkInstance?.closeAndDeleteCachedAssets()
                else BlinkCardSdk.sdkInstance?.close()
            }
            result.success(true)
        } catch (e: Exception) {
            result.error(BlinkCardArguments.blinkcardError, e.message, null)
        }
    }

    private suspend fun ensureLoadedSdk(call: MethodCall): BlinkCardSdk? {
        blinkCardSdk?.let { return it }

        val sdkSettingsRaw = call.argument<Map<String, Any>>(BlinkCardArguments.sdkSettings)
        val sdkSettings = BlinkCardDeserializationUtils.deserializeBlinkCardSdkSettings(sdkSettingsRaw)

        flutterPluginActivity?.let {
            val maybeInstance = BlinkCardSdk.initializeSdk(it, sdkSettings)
            when {
                maybeInstance.isSuccess -> {
                    blinkCardSdk = maybeInstance.getOrNull()
                    return blinkCardSdk
                }
                maybeInstance.isFailure -> {
                    blinkCardSdk = null
                    throw maybeInstance.exceptionOrNull() ?: BlinkCardFlutterError.InitializationError("SDK initialization error")
                }
            }
        }
        return null
    }

    private fun addFlutterPinglet(context: Context) {
        PingManager
            .getInstance(context)
            .add(WrapperProductInfo(wrapperProduct = WrapperProductInfo.WrapperProduct.CROSSPLATFORMFLUTTER), 0)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, BlinkCardArguments.packageName)
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterPluginActivity = binding.activity
        binding.addActivityResultListener { requestCode, resultCode, data ->
            onActivityResult(requestCode, resultCode, data)
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() { flutterPluginActivity = null }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { flutterPluginActivity = binding.activity }
    override fun onDetachedFromActivity() { flutterPluginActivity = null }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = channel.setMethodCallHandler(null)

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == BlinkCardArguments.blinkCardRequestCode) {
            val blinkCardResult = MbBlinkCardScan().parseResult(resultCode, data)
            when (blinkCardResult.status) {

                ScanActivityResultStatus.Scanned -> {
                    blinkCardResult.result?.let {
                        val result = BlinkCardSerializationUtils.serializeBlinkCardScanningResult(it)
                        flutterResult.success(result)
                        closeSdk()
                    }?: flutterResult.error(BlinkCardArguments.blinkcardError, "BlinkCard result is empty", null)
                }

                ScanActivityResultStatus.Canceled -> {
                    flutterResult.error(BlinkCardArguments.blinkcardError, BlinkCardFlutterError.Cancelled().message, null)
                    closeSdk()
                }

                ScanActivityResultStatus.ErrorSdkInit -> {
                    flutterResult.error(BlinkCardArguments.blinkcardError, BlinkCardFlutterError.InitializationError("The SDK could not be initialized").message, null)
                    closeSdk()
                }
            }
        }
        return true
    }

    private fun closeSdk() {
        BlinkCardSdk.sdkInstance?.close()
        blinkCardSdk = null
    }
}
