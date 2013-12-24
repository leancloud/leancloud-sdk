package com.example.avoscloud_demo;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Toast;
import com.avos.avoscloud.AVException;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

public class DemoBaseActivity  extends ListActivity {

    static public final String CONTENT_TAG = "content";

    private List<String> codeSnippetList = new ArrayList<String>();

    public List<String> myTestList() {
        if (codeSnippetList.isEmpty()) {
            codeSnippetList.addAll(methodsWithPrefix("test"));
        }
        return codeSnippetList;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);    //To change body of overridden methods use File | Settings | File Templates.
        requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
        setContentView(R.layout.demo_base);
        setupAdapter();
        setupButtonHandlers();
    }


    private void setupButtonHandlers() {
        Button button = (Button) findViewById(R.id.btn_show_source);
        if (button != null) {
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    showSourceCode();
                }
            });
        }
    }

    static public String readTextFile(InputStream inputStream) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        byte buf[] = new byte[8 * 1024];
        int len;
        try {
            while ((len = inputStream.read(buf)) != -1) {
                outputStream.write(buf, 0, len);
            }
            outputStream.close();
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return outputStream.toString();
    }

    private void showSourceCode() {
        try {
            String name = this.getClass().getSimpleName() + ".java";
            InputStream inputStream = getAssets().open(name);
            String content = readTextFile(inputStream);
            startSourceCodeActivity(content);
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

    public void setupAdapter() {
        List<String> array = myTestList();
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter(this,
                android.R.layout.simple_list_item_1,
                array);
        setListAdapter(adapter);
    }

    private void startSourceCodeActivity(final String content) {
        try {
            Intent intent = new Intent(this, SourceCodeActivity.class);
            intent.putExtra(CONTENT_TAG, content);
            startActivity(intent);
        } catch (Exception exception) {
            exception.printStackTrace();
        }
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
