package com.example.avoscloud_demo;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Window;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;
import ar.com.daidalos.afiledialog.FileChooserDialog;
import com.avos.avoscloud.*;

import java.io.Closeable;
import java.io.File;
import java.io.RandomAccessFile;

public class UserDemoActivity extends DemoBaseActivity {

    private void signUpImpl(final String message, final String username, final String password) {
        AVUser.logOut();
        AVUser user = new AVUser();
        user.setUsername(username);
        user.setPassword(password);
        user.signUpInBackground(new SignUpCallback() {
            @Override
            public void done(AVException e) {
                showMessage(message, e, false);
            }
        });
    }

    private void loginImpl(final String message, final String username, final String password) {
        AVUser.logOut();
        AVUser.logInInBackground(username, password, new LogInCallback<AVUser>() {
            @Override
            public void done(AVUser avUser, AVException e) {
                showMessage(message, e, false);
            }
        });
    }

    public void testUserSignUp(final String string) throws Exception {
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
                signUpImpl(string, username, password);
            }
        }).setNegativeButton(R.string.login, new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                String  username = userNameET.getText().toString();
                String password = passwordET.getText().toString();
                loginImpl(string, username, password);
            }
        });
        builder.setView(layout);
        AlertDialog ad = builder.create();
        ad.show();
    }




}
