package com.avos.avoscloud.PushDemo;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSONObject;
import com.avos.avoscloud.*;

public class PushDemo extends Activity {
  /**
   * Called when the activity is first created.
   */

  View customPushButton;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    PushService.setDefaultPushCallback(this, PushDemo.class);
    PushService.subscribe(this, "public", PushDemo.class);
    PushService.subscribe(this, "private", Callback1.class);
    PushService.subscribe(this, "protected", Callback2.class);

    final Context context = this;

    final TextView t = (TextView) this.findViewById(R.id.mylabel);
    t.setText("id: " + AVInstallation.getCurrentInstallation().getInstallationId());
    AVInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {
      @Override
      public void done(AVException e) {
        PushService.unsubscribe(context, "protected");
        AVInstallation.getCurrentInstallation().saveInBackground();
      }
    });
    customPushButton = this.findViewById(R.id.customPush);
    customPushButton.setOnClickListener(new View.OnClickListener() {

      @Override
      public void onClick(View v) {
        AVPush push = new AVPush();

        AVQuery<AVInstallation> query = AVInstallation.getQuery();
        query.whereEqualTo("installationId", AVInstallation.getCurrentInstallation()
            .getInstallationId());
        push.setQuery(query);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("action", "com.pushdemo.action");
        jsonObject.put("alert", "Here is the Custom Push Message");

        push.setData(jsonObject);
        push.setPushToAndroid(true);
        push.sendInBackground(new SendCallback() {
          @Override
          public void done(AVException e) {
            Toast.makeText(getApplicationContext(), "send successfully", Toast.LENGTH_SHORT);
          }
        });
      }
    });
  }
}
