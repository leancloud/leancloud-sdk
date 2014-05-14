package com.avos.demo;

import com.avos.avoscloud.*;

import android.app.Application;

public class ToDoListApplication extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    // 初始化应用 Id 和 应用 Key，您可以在应用设置菜单里找到这些信息
    AVOSCloud.initialize(this, "70l90kzm53nplnu013ala0j8wipr594d36m5zuz94ukvmh5s",
        "lamrsuheyiaqcx4o7m3jaz4awaeukerit1mucnjwk7ibokfv");
    // 启用崩溃错误报告
    AVAnalytics.enableCrashReport(getApplicationContext(), true);
    // 注册子类
    AVObject.registerSubclass(Todo.class);
  }

}
