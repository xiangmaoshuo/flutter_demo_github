package com.example.flutter_demo;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

// 如果flutter要和native通信，也是通过MethodChannel/EventChannel等实现的，此时两端都要写代码
// 参考：https://www.jianshu.com/p/d9eeb15b3fa0
public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
