package com.example.avoscloud_demo;

import android.os.Bundle;
import android.view.Window;
import android.widget.ArrayAdapter;
import com.avos.avoscloud.*;
import junit.framework.Assert;

import java.lang.reflect.Method;
import java.util.*;

public class ObjectDemoActivity extends DemoBaseActivity {


    // create an object and query it.
    public void testObjectRead(final String string) throws AVException {
        final String key = "array";
        final String objectTable = "ObjectDemoTableRead";
        final AVObject myObject = new AVObject(objectTable);
        for(int i = 0; i < 5; ++i) {
            myObject.add(key, i);
        }
        myObject.saveInBackground(new SaveCallback() {
            @Override
            public void done(AVException avException) {
                    AVQuery<AVObject> query = AVQuery.getQuery(objectTable);
                    query.getInBackground(myObject.getObjectId(), new GetCallback<AVObject>() {
                        @Override
                        public void done(AVObject result, AVException e) {
                            List < Number > array = result.getList(key);
                            Assert.assertTrue(array.size() == 5);
                            if (array.size() != 5) {
                                showMessage(string, new AVException(AVException.OTHER_CAUSE, "incorrect result"), false);
                            } else {
                                showMessage(string, null, false);
                            }
                            setProgressBarIndeterminateVisibility(false);
                        }
                    });
            }});
    }

    public void testObjectCreate(final String string) throws AVException {

        final String objectTable = "ObjectDemoTableCreate";
        final String key = "score";
        AVObject gameScore = new AVObject(objectTable);
        final int targetValue = new Random().nextInt();
        gameScore.put(key, targetValue);
        int value = gameScore.getInt(key);
        Assert.assertTrue(value == targetValue);

        final String targetString = "Sean Plott";
        gameScore.put("playerName", targetString);
        String stringValue = gameScore.getString("playerName");
        Assert.assertTrue(stringValue == targetString);

        gameScore.saveInBackground(new SaveCallback() {
            @Override
            public void done(AVException e) {
                showMessage(string, e, false);

            }
        });
    }

    // update an object
    public void testObjectUpdate(final String string) {
        final String key = "update";
        final String objectTable = "ObjectDemoTableUpdate";
        final AVObject myObject = new AVObject(objectTable);
        final String value = "anotherValue";
        myObject.put(key, "myValue");

        myObject.saveInBackground(new SaveCallback() {
            @Override
            public void done(AVException avException) {
                myObject.put(key, value);
                myObject.saveInBackground(new SaveCallback() {
                    @Override
                    public void done(AVException e) {
                        AVQuery<AVObject> query = AVQuery.getQuery(objectTable);
                        query.getInBackground(myObject.getObjectId(), new GetCallback<AVObject>() {
                            @Override
                            public void done(AVObject result, AVException e) {
                                String stringValue = (String)result.get(key);
                                Assert.assertEquals(stringValue, value);
                                if (!value.equals(stringValue)) {
                                    showMessage(string, new AVException(AVException.OTHER_CAUSE, "incorrect result"), false);
                                } else {
                                    showMessage(string, null, false);
                                }
                            }
                        });
                    }
                });
            }
        });
    }

    public void testObjectDelete(final String string) {
        final String objectTable = "ObjectDemoTableDelete";
        final AVObject myObject = new AVObject(objectTable);
        myObject.saveInBackground(new SaveCallback() {
            @Override
            public void done(AVException avException) {
                myObject.deleteInBackground(new DeleteCallback() {
                    @Override
                    public void done(AVException e) {
                        AVQuery<AVObject> query = AVQuery.getQuery(objectTable);
                        query.getInBackground(myObject.getObjectId(), new GetCallback<AVObject>() {
                        @Override
                        public void done(AVObject result, AVException e) {
                            Assert.assertTrue(result == null);
                            if (result != null) {
                                showMessage(string, new AVException(AVException.OTHER_CAUSE, "delete failed"), false);
                            } else {
                                showMessage(string, null, false);
                            }
                        }
                    });
                    }
                });
            };
        });
    }
}
