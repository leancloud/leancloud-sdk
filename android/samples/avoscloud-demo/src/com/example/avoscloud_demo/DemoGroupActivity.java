package com.example.avoscloud_demo;

import android.app.Activity;
import android.app.Dialog;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import com.avos.avoscloud.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DemoGroupActivity extends ListActivity {

    static final Map<String, String> demoMap = new HashMap<String, String>();

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        setupAVOSCloud(false);
        setupButtonHandlers();
        setupGroupAdapter();
    }

    private void setupAVOSCloud(boolean config) {
        if (!config) {
            AVOSCloud.initialize(getApplication(),
                    "gqd0m4ytyttvluk1tnn0unlvmdg8h4gxsa2ga159nwp85fks",
                    "7gd2zom3ht3vx6jkcmaamm1p2pkrn8hdye2pn4qjcwux1hl1");
            return;
        }
        final Dialog dialog = new Dialog(this);
        dialog.setContentView(R.layout.cloud);
        dialog.setTitle("Setup AVOS Cloud");

        // set the custom dialog components - text, image and button
        Button dialogButton = (Button) dialog.findViewById(R.id.btn_ok);
        dialogButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
                EditText appId = (EditText) dialog.findViewById(R.id.textViewAppId);
                EditText clientKey = (EditText) dialog.findViewById(R.id.textViewClientKey);
                AVOSCloud.initialize(getApplication(),
                        appId.getText().toString(),
                        clientKey.getText().toString());
            }
        });
        dialog.show();
    }

    private void setupButtonHandlers() {
        Button button = (Button) findViewById(R.id.btn_config);
        if (button != null) {
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    setupAVOSCloud(true);
                }
            });
        }
    }

    public void setupGroupAdapter() {
        List<String> array = myDemoArray();
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter(this,
                android.R.layout.simple_list_item_1,
                array);
        setListAdapter(adapter);
    }

    private List<String> myDemoArray() {
        List<String> array = new ArrayList<String>(this.myDemoMap().keySet());
        return array;
    }

    private Map<String, String> myDemoMap() {
        if (demoMap.isEmpty()) {
            demoMap.put("ObjectDemoActivity", "com.example.avoscloud_demo.ObjectDemoActivity");
            demoMap.put("UserDemoActivity", "com.example.avoscloud_demo.UserDemoActivity");
            demoMap.put("FileDemoActivity", "com.example.avoscloud_demo.FileDemoActivity");
            demoMap.put("SubclassDemoActivity", "com.example.avoscloud_demo.SubclassDemoActivity");
            demoMap.put("QueryDemoActivity", "com.example.avoscloud_demo.QueryDemoActivity");
        }
        return demoMap;
    }

    private void startActivityByName(final String className) {
        try {
            Intent intent = new Intent(this, Class.forName(className));
            startActivity(intent);
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

    protected void onListItemClick(android.widget.ListView l, android.view.View v, int position, long id) {
        List<String> array = myDemoArray();
        String name = array.get(position);
        String value = myDemoMap().get(name);
        startActivityByName(value);
    }
}
