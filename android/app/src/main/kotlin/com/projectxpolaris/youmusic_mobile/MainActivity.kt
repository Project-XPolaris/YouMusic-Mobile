package com.projectxpolaris.youmusic_mobile

import android.graphics.Color
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.apply {
            javaClass.declaredFields
                    .firstOrNull { it.name == "mSemiTransparentBarColor" }
                    ?.apply { isAccessible = true }
                    ?.setInt(this, Color.TRANSPARENT)
        }
    }
}
