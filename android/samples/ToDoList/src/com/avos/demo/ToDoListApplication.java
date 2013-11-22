package com.avos.demo;

import com.avos.avoscloud.*;


import android.app.Application;

public class ToDoListApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();

        // Your application id and Application Key
		AVOSCloud.initialize(this, "gqd0m4ytyttvluk1tnn0unlvmdg8h4gxsa2ga159nwp85fks", "7gd2zom3ht3vx6jkcmaamm1p2pkrn8hdye2pn4qjcwux1hl1");
        AVOSCloud.useAVCloudCN();
		AVUser.enableAutomaticUser();
		AVACL defaultACL = new AVACL();
        defaultACL.setPublicWriteAccess(true);
        defaultACL.setPublicReadAccess(true);
		AVACL.setDefaultACL(defaultACL, true);
	}

}
