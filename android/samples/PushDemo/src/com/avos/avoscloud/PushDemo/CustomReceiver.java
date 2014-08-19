package com.avos.avoscloud.PushDemo;

import org.json.JSONObject;

import com.avos.avoscloud.AVOSCloud;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;

public class CustomReceiver extends BroadcastReceiver {

  @Override
  public void onReceive(Context context, Intent intent) {
    try {
      if (intent.getAction().equals("com.pushdemo.action")) {
        JSONObject json = new JSONObject(intent.getExtras().getString("com.avos.avoscloud.Data"));
        final String message = json.getString("alert");
        Intent resultIntent = new Intent(AVOSCloud.applicationContext, PushDemo.class);
        PendingIntent pendingIntent =
            PendingIntent.getActivity(AVOSCloud.applicationContext, 0, resultIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationCompat.Builder mBuilder =
            new NotificationCompat.Builder(AVOSCloud.applicationContext)
                .setSmallIcon(R.drawable.notification)
                .setContentTitle(
                    AVOSCloud.applicationContext.getResources().getString(R.string.app_name))
                .setContentText(message);
        mBuilder.setContentIntent(pendingIntent);
        mBuilder.setAutoCancel(true);

        int mNotificationId = 10086;
        NotificationManager mNotifyMgr =
            (NotificationManager) AVOSCloud.applicationContext
                .getSystemService(
                Context.NOTIFICATION_SERVICE);
        mNotifyMgr.notify(mNotificationId, mBuilder.build());
      }
    } catch (Exception e) {

    }
  }
}
