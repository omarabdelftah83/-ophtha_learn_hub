package com.anmka.mentalskillacademy

import io.flutter.embedding.android.FlutterActivity
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.engine.FlutterEngine




class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)


    }
}











