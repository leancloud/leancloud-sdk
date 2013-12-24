package com.example.avoscloud_demo;

import android.os.AsyncTask;
import com.avos.avoscloud.*;
import junit.framework.Assert;

import java.util.List;

public class QueryDemoActivity extends DemoBaseActivity {

    static private final String BASIC_QUERY = "basic";

    private class QueryTask extends AsyncTask<String, Void, Void> {
        volatile private String message = null;
        volatile private Exception exception = null;
        @Override
        protected Void doInBackground(String ... params) {
            message = params[0];
            try {
                if (BASIC_QUERY.equals(message)) {
                    QueryDemoActivity.this.objectQueryImpl();
                }
            } catch (Exception e) {
                exception = e;
                exception.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            QueryDemoActivity.this.showMessage(message, exception, false);
        }

        @Override
        protected void onPreExecute() {

        }

        @Override
        protected void onProgressUpdate(Void... values) {
        }
    }


    private void objectQueryImpl() throws Exception {
        AVObject person1 = AVObject.create("Person");
        person1.put("gender", "Female");
        person1.put("name", "Cake");
        person1.save();

        AVObject person2 = AVObject.create("Person");
        person2.put("gender", "Male");
        person2.put("name", "Man");
        person2.save();

        AVObject something = AVObject.create("Something");
        something.put("belongTo", "Cake");
        something.put("city", "ChangDe");
        something.save();

        AVObject another = AVObject.create("Something");
        another.put("belongTo", "Man");
        another.put("city", "Beijing");
        another.save();

        AVQuery q1 = AVQuery.getQuery("Person");
        q1.whereEqualTo("gender", "Female");

        AVQuery q2 = AVQuery.getQuery("Something");
        q2.whereMatchesKeyInQuery("belongTo", "name", q1);
        List<AVObject> objects = q2.find();
        Assert.assertTrue(objects.size() > 0);
        for (AVObject obj : objects) {
            Assert.assertTrue(obj.getString("belongTo").equals("Cake"));
        }

        AVQuery q3 = AVQuery.getQuery("Something");
        q3.whereDoesNotMatchKeyInQuery("belongTo", "name", q1);
        List<AVObject> list = q3.find();
        Assert.assertTrue(list.size() > 0);
        for (AVObject obj : list) {
            Assert.assertFalse(obj.getString("belongTo").equals("Cake"));
        }
    }

    // create an object and query it.
    public void testObjectQuery(final String string) throws AVException {
        QueryTask task = new QueryTask();
        task.execute(BASIC_QUERY, string);
    }

}
