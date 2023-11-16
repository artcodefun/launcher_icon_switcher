package com.example.launcher_icon_switcher

import android.app.Activity
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_DISABLED
import android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED
import androidx.core.content.ContextCompat.startActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** LauncherIconSwitcherPlugin */
class LauncherIconSwitcherPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private lateinit var icons: List<String>
    private lateinit var defaultIcon: String
    private var isInitialized: Boolean = false

    companion object {
        const val noActivityError = "NO_ACTIVITY"
        const val noActivityErrorDescription = "No Activity was found"
        const val noIconsError = "NO_ICONS"
        const val noIconsErrorDescription = "No icons were provided"
        const val notInitializedError = "NOT_INITIALIZED"
        const val notInitializedErrorDescription = "Plugin was not initialized properly"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "launcher_icon_switcher")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                icons = call.argument<List<String>>("icons")!!
                defaultIcon = call.argument<String>("defaultIcon")!!
                if (icons.isEmpty()) return result.error(
                    noIconsError, noIconsErrorDescription, null
                )

                isInitialized = true
                result.success(null)
            }
            "getCurrentIcon" -> {
                if (!isInitialized) return result.error(
                    notInitializedError, notInitializedErrorDescription, null
                )

                if (activity == null) return result.error(
                    noActivityError, noActivityErrorDescription, null
                )

                val ctx = activity!!.applicationContext
                val pm = ctx.packageManager
                val packageName = ctx.packageName
                for (i in icons) {
                    val state =
                        pm.getComponentEnabledSetting(ComponentName(packageName, "$packageName.$i"))

                    if (state == COMPONENT_ENABLED_STATE_ENABLED) return result.success(i)
                }

                result.success(defaultIcon)
            }
            "setIcon" -> {
                if (!isInitialized) return result.error(
                    notInitializedError, notInitializedErrorDescription, null
                )

                if (activity == null) return result.error(
                    noActivityError, noActivityErrorDescription, null
                )

                val targetIcon: String = call.argument<String>("icon")!!
                val shouldKeepAlive: Boolean = call.argument<Boolean>("shouldKeepAlive") ?: false

                val ctx = activity!!.applicationContext
                val pm = ctx.packageManager
                val packageName = ctx.packageName

                for (i in icons) {
                    pm.setComponentEnabledSetting(
                        ComponentName(packageName, "$packageName.$i"),
                        if (i == targetIcon) COMPONENT_ENABLED_STATE_ENABLED else COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }

                if (shouldKeepAlive) {
                    val intent = Intent()
                    intent.setClassName(
                        packageName!!,
                        ComponentName(packageName, "$packageName.$targetIcon").className
                    )
                    intent.action = Intent.ACTION_MAIN
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TASK
                    activity!!.finish()
                    startActivity(activity!!.applicationContext, intent, null)
                }

                return result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

}
