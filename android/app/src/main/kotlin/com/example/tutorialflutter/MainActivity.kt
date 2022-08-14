package com.example.tutorialflutter

import io.flutter.embedding.android.FlutterActivity

import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.widget.Toast
// import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterMain

class MainActivity: FlutterActivity() {
	private val CHANNEL = "com.example.tutorialflutter"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
	override fun onCreate(savedInstanceState: Bundle?) {
    //override fun onCreate (@NonNull flutterEngine: FlutterEngine) {
		super.onCreate(savedInstanceState)
    	//GeneratedPluginRegistrant.registerWith(this)
		// GeneratedPluginRegistrant.registerWith(flutterEngine)

		MethodChannel(flutterEngine!!.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler { call, result ->
    	//MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      		if (call.method == "callSendStringFun") {
      			showHelloFromFlutter(call.argument("arg"))
      			val temp = sendString()
          		result.success(temp)
      		} else {
        		result.notImplemented()
      		}
    	}
  	}

  	private fun sendString(): String {
    	val stringToSend: String = "Hello from Kotlin"
    	return stringToSend
  	}

  	private fun showHelloFromFlutter(argFromFlutter : String?){
  		Toast.makeText(this, argFromFlutter, Toast.LENGTH_SHORT).show()
  	}
}