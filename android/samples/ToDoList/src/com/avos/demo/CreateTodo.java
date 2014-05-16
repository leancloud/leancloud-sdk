package com.avos.demo;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.GetCallback;
import com.avos.avoscloud.SaveCallback;
import com.avos.demo.R;

public class CreateTodo extends Activity {

  private EditText contentText;
  private String objectId;

  @Override
  protected void onPause() {
    super.onPause();
    // 页面统计，结束
    AVAnalytics.onPause(this);
  }

  @Override
  protected void onResume() {
    super.onResume();
    // 页面统计，开始
    AVAnalytics.onResume(this);
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.create_todo);
    setTitle(R.string.create_todo);

    contentText = (EditText) findViewById(R.id.content);

    Intent intent = getIntent();
    // 通过搜索结果打开
    if (intent.getAction() == Intent.ACTION_VIEW) {
      // 如果是VIEW action，我们通过getData获取URI
      Uri uri = intent.getData();
      String path = uri.getPath();
      int index = path.lastIndexOf("/");
      if (index > 0) {
        // 获取objectId
        objectId = path.substring(index + 1);
        Todo todo = new Todo();
        todo.setObjectId(objectId);
        // 通过Fetch获取content内容
        todo.fetchInBackground(new GetCallback<AVObject>() {
          @Override
          public void done(AVObject todo, AVException arg1) {
            if (todo != null) {
              String content = todo.getString("content");
              if (content != null) {
                contentText.setText(content);
              }
            }
          }
        });
      }
    } else {
      // 通过ListView点击打开
      Bundle extras = getIntent().getExtras();
      if (extras != null) {
        String content = extras.getString("content");
        objectId = extras.getString("objectId");

        if (content != null) {
          contentText.setText(content);
        }
      }
    }

    Button confirmButton = (Button) findViewById(R.id.confirm);
    confirmButton.setOnClickListener(new View.OnClickListener() {
      public void onClick(View view) {
        final Todo todo = new Todo();
        if (!TextUtils.isEmpty(objectId)) {
          // 如果存在objectId，保存会变成更新操作。
          todo.setObjectId(objectId);
        }
        todo.setContent(contentText.getText().toString());
        // 异步保存
        todo.saveInBackground(new SaveCallback() {
          @Override
          public void done(AVException e) {
            // done方法一定在UI线程执行
            if (e != null) {
              Log.e("CreateTodo", "Update todo failed.", e);
            }
            Bundle bundle = new Bundle();
            bundle.putBoolean("success", e == null);
            Intent intent = new Intent();
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
            finish();
          }
        });
      }
    });
  }

}
