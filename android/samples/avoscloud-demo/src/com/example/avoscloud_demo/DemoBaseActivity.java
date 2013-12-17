package com.example.avoscloud_demo;

import android.app.Activity;
import android.app.ListActivity;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Toast;
import com.avos.avoscloud.AVException;

import java.io.Closeable;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: zhuzeng
 * Date: 12/13/13
 * Time: 10:59 AM
 * To change this template use File | Settings | File Templates.
 */
public class DemoBaseActivity  extends ListActivity {

    private List<String> codeSnippetList = new ArrayList<String>();

    public List<String> myTestList() {
        if (codeSnippetList.isEmpty()) {
            codeSnippetList.addAll(methodsWithPrefix("test"));
        }
        return codeSnippetList;
    }

    public void setupAdapter() {
        List<String> array = myTestList();
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter(this,
                android.R.layout.simple_list_item_1,
                array);
        setListAdapter(adapter);
    }

    public void showMessage(final String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    public void showMessage(final String text, Exception e, boolean busy) {
        if (e == null) {
            showMessage(text + " finished.");
        } else {
            showMessage(e.toString());
        }
        if (!busy) {
            setProgressBarIndeterminateVisibility(false);
        }
    }

    public List<String> methodsWithPrefix(final String prefix) {
        List<String> methods = new ArrayList<String>();
        try {
            Class c = this.getClass();
            Method m[] = c.getDeclaredMethods();
            for (int i = 0; i < m.length; i++) {
                if (m[i].getName().startsWith(prefix)) {
                    methods.add(m[i].getName());
                }
            }
        }
        catch (Throwable e) {
            e.printStackTrace();
        }
        return methods;
    }

    public static Method getMethodSafely(Class<?> cls, String name,  Class<?>... parameterTypes)
    {
        try {
            if (cls == null) {
                return null;
            }
            return cls.getMethod(name, parameterTypes);
        }
        catch (Exception exception) {
            exception.printStackTrace();
        }
        return null;
    }

    public static void invokeMethod(Object receiver, Method method, Object... args) throws Exception
    {
        if (method == null) {
            throw  new NullPointerException();
        }

        try {
            method.invoke(receiver, args);
        }
        catch (Exception exception) {
            exception.printStackTrace();
            throw exception;
        }
    }

    protected void onListItemClick(android.widget.ListView l, android.view.View v, int position, long id) {
        List<String> array = myTestList();
        String name = array.get(position);
        Method method = getMethodSafely(this.getClass(), name, String.class);
        setProgressBarIndeterminateVisibility(true);
        try {
            invokeMethod(this, method, method.getName());
        } catch (Exception exception) {
            showMessage(null, exception, false);
        }
    }

    public void closeQuietly(Closeable closeable) {
        try {
            if (closeable != null) {
                closeable.close();
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }


    public boolean isBlankString(final String string) {
        if (string == null || string.trim().isEmpty()) {
            return true;
        }
        return false;
    }
}
