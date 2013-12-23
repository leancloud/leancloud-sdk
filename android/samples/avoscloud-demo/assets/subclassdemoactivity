package com.example.avoscloud_demo;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Window;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;
import ar.com.daidalos.afiledialog.FileChooserDialog;
import com.avos.avoscloud.*;
import junit.framework.Assert;

import java.io.File;
import java.io.RandomAccessFile;

import static junit.framework.Assert.assertFalse;

public class SubclassDemoActivity  extends  DemoBaseActivity {
    static final private String SIGNUP_TAG = "signup";
    static final private String LOGIN_TAG = "login";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SubObject.registerSubclass(SubObject.class);
    }

    private class SubuserTask extends AsyncTask<String, Void, Void> {
        volatile private String message = null;
        volatile private Exception exception = null;
        @Override
        protected Void doInBackground(String ... params) {
            message = params[0];
            try {
                if (params[1] == SIGNUP_TAG) {
                    subuserSignUpImpl(params[2], params[3]);
                } else if (params[1] == LOGIN_TAG) {
                    subuserLoginImpl(params[2], params[3]);
                }
            } catch (Exception e) {
                exception = e;
                exception.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            SubclassDemoActivity.this.showMessage(message, exception, false);
        }

        @Override
        protected void onPreExecute() {

        }

        @Override
        protected void onProgressUpdate(Void... values) {
        }
    }

    private class SubObjectTask extends AsyncTask<String, Void, Void> {
        volatile private String message = null;
        volatile private Exception exception = null;
        @Override
        protected Void doInBackground(String ... params) {
            message = params[0];
            try {
                SubObject armor = new SubObject();
                String displayName = "avos cloud subclass object.";
                armor.setDisplayName(displayName);
                armor.setBroken(false);
                armor.save();
                Assert.assertFalse(armor.getObjectId().isEmpty());

                AVQuery<SubObject> query = AVObject.getQuery(SubObject.class);
                SubObject result = query.get(armor.getObjectId());
                Assert.assertTrue(result instanceof SubObject);
                String value = result.getDisplayName();
                Assert.assertEquals(value, displayName);
            } catch (Exception e) {
                exception = e;
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            SubclassDemoActivity.this.showMessage(message, exception, false);
        }

        @Override
        protected void onPreExecute() {

        }

        @Override
        protected void onProgressUpdate(Void... values) {
        }
    }

    private void subuserSignUpImpl(final String username, final String password) throws Exception {
        SubObject armor = new  SubObject();
        armor.setDisplayName("avos cloud demo object.");
        armor.setBroken(false);
        armor.save();
        Assert.assertFalse(armor.getObjectId().isEmpty());

        SubUser subUser = new SubUser();
        String nickName = "testSignupSubUser";
        subUser.setUsername(username);
        subUser.setPassword(password);
        subUser.setNickName(nickName);
        subUser.setArmor(armor);
        subUser.signUp();
        Assert.assertFalse(subUser.getObjectId().isEmpty());
        Assert.assertFalse(subUser.getSessionToken().isEmpty());

        SubUser cloudUser = AVUser.logIn(username, password, SubUser.class);
        Assert.assertTrue(cloudUser.getSessionToken() != null);
        Assert.assertEquals(cloudUser.getObjectId(), subUser.getObjectId());
        Assert.assertEquals(cloudUser.getSessionToken(), subUser.getSessionToken());
        Assert.assertEquals(username, cloudUser.getUsername());
        Assert.assertEquals(nickName, cloudUser.getNickName());
        Assert.assertNotNull(cloudUser.getArmor());
        AVUser currentUser = AVUser.getCurrentUser();
        Assert.assertTrue(currentUser instanceof SubUser);
    }

    private void subuserLoginImpl(final String username, final String password) throws Exception {
        SubUser.logIn(username, password);
        AVUser currentUser = AVUser.getCurrentUser();
        Assert.assertTrue(currentUser instanceof SubUser);
    }

    private void runLoginTask(final String string, final String username, final String password) {
        SubuserTask task = new SubuserTask();
        task.execute(string, LOGIN_TAG, username, password);
    }

    private void runSignUpTask(final String string, final String username, final String password) {
        SubuserTask task = new SubuserTask();
        task.execute(string, SIGNUP_TAG, username, password);
    }

    private void runSubObjectTask(final String string) {
        SubObjectTask task = new SubObjectTask();
        task.execute(string);
    }

    public void testSubUserSignup(final String string) throws AVException {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        LayoutInflater inflater = LayoutInflater.from(this);
        LinearLayout layout = (LinearLayout)inflater.inflate(R.layout.login_dialog, null );

        final EditText userNameET = (EditText)layout.findViewById(R.id.usernameInput);
        final EditText passwordET = (EditText)layout.findViewById(R.id.passwordInput);

        builder.setTitle("sign up").setPositiveButton(R.string.signup, new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                // TODO Auto-generated method stub
                String  username = userNameET.getText().toString();
                String password = passwordET.getText().toString();
                runSignUpTask(string, username, password);
            }
        }).setNegativeButton(R.string.login, new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                String  username = userNameET.getText().toString();
                String password = passwordET.getText().toString();
                runLoginTask(string, username, password);
            }
        });
        builder.setView(layout);
        AlertDialog ad = builder.create();
        ad.show();
    }

    public void testSubObject(final String string) throws Exception {
        runSubObjectTask(string);
    }
}
