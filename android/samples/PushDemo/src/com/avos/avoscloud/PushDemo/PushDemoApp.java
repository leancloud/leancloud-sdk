package com.avos.avoscloud.PushDemo;

import android.app.Application;
import com.avos.avoscloud.Parse;

/**
 * Created with IntelliJ IDEA.
 * User: tangxiaomin
 * Date: 4/19/13
 * Time: 12:57 PM
 */
public class PushDemoApp extends Application {
    private static final String LOGTAG = PushDemoApp.class.getName();
    @Override
    public void onCreate() {
        super.onCreate();


        Parse.useAVCloudCN();
        Parse.initialize(this, YOUR_APP_ID, YOUR_APP_KEY);
    }
}
