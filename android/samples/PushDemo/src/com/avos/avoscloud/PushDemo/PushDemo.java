package com.avos.avoscloud.PushDemo;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import com.avos.avoscloud.*;

public class PushDemo extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        PushService.setDefaultPushCallback(this, PushDemo.class);
        PushService.subscribe(this, "Giants", PushDemo.class);
        PushService.subscribe(this, "Boy", Callback1.class);
        PushService.subscribe(this, "Girl", Callback2.class);
        final TextView t = (TextView)this.findViewById(R.id.mylabel);
        t.setText(ParseInstallation.getCurrentInstallation().getInstallationId());
        ParseInstallation.getCurrentInstallation().saveInBackground();

    }


}
