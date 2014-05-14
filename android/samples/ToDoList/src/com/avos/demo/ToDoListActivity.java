package com.avos.demo;


import java.util.Collections;
import java.util.List;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.avos.avoscloud.*;
import com.avos.avoscloud.search.AVSearchQuery;



public class ToDoListActivity extends ListActivity {
  private static final int ACTIVITY_CREATE = 0;
  private static final int ACTIVITY_EDIT = 1;

  public static final int INSERT_ID = Menu.FIRST;
  private static final int DELETE_ID = Menu.FIRST + 1;
  private static final int SEARCH_ID = Menu.FIRST + 2;

  private volatile List<Todo> todos;
  private Dialog progressDialog;

  private static final String TAG = ToDoListActivity.class.getName();
  private EditText searchInput;

  private class RemoteDataTask extends AsyncTask<Void, Void, Void> {
    // Override this method to do custom remote calls
    @Override
    protected Void doInBackground(Void... params) {
      // 查询当前Todo列表
      AVQuery<Todo> query = AVQuery.getQuery(Todo.class);
      // 按照更新时间降序排序
      query.orderByDescending("updatedAt");
      // 最大返回1000条
      query.limit(1000);
      try {
        todos = query.find();
      } catch (AVException exception) {
        Log.e(TAG, "Query todos failed.", exception);
        todos = Collections.emptyList();
      }
      return null;
    }

    @Override
    protected void onPreExecute() {
      ToDoListActivity.this.progressDialog =
          ProgressDialog.show(ToDoListActivity.this, "", "Loading...", true);
      super.onPreExecute();
    }

    @Override
    protected void onProgressUpdate(Void... values) {

      super.onProgressUpdate(values);
    }

    @Override
    protected void onPostExecute(Void result) {
      // 展现ListView
      TodoAdapter adapter = new TodoAdapter(ToDoListActivity.this, todos);
      setListAdapter(adapter);
      registerForContextMenu(getListView());
      ToDoListActivity.this.progressDialog.dismiss();
      TextView empty = (TextView) findViewById(android.R.id.empty);
      if (todos != null && !todos.isEmpty()) {
        empty.setVisibility(View.INVISIBLE);
      } else {
        empty.setVisibility(View.VISIBLE);
      }
    }
  }

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(com.avos.demo.R.layout.main);
    TextView empty = (TextView) findViewById(android.R.id.empty);
    empty.setVisibility(View.VISIBLE);
    searchInput = new EditText(this);
    new RemoteDataTask().execute();
  }

  private void createTodo() {
    Intent i = new Intent(this, CreateTodo.class);
    startActivityForResult(i, ACTIVITY_CREATE);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
    super.onActivityResult(requestCode, resultCode, intent);
    if (intent == null) {
      return;
    }
    switch (requestCode) {
      case ACTIVITY_CREATE:
        // 自定义事件统计
        AVAnalytics.onEvent(getApplicationContext(), "create_todo");
        break;
      case ACTIVITY_EDIT:
        // 自定义事件统计
        AVAnalytics.onEvent(getApplicationContext(), "update_todo");
        break;
    }
    // 暂时提示信息
    boolean success = intent.getBooleanExtra("success", true);
    Toast toast = null;
    if (success) {
      toast = Toast.makeText(getApplicationContext(), "Save successfully.", Toast.LENGTH_SHORT);
      // 重新查询，刷新ListView
      new RemoteDataTask().execute();
    } else {
      toast = Toast.makeText(getApplicationContext(), "Save failure.", Toast.LENGTH_SHORT);
    }
    toast.show();
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    boolean result = super.onCreateOptionsMenu(menu);
    menu.add(0, INSERT_ID, 0, com.avos.demo.R.string.menu_insert);
    menu.add(0, SEARCH_ID, 1, com.avos.demo.R.string.menu_search);
    return result;
  }

  @Override
  public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
    super.onCreateContextMenu(menu, v, menuInfo);
    menu.add(0, DELETE_ID, 0, com.avos.demo.R.string.menu_delete);
  }

  @Override
  public boolean onContextItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case DELETE_ID:
        AdapterContextMenuInfo info = (AdapterContextMenuInfo) item.getMenuInfo();

        // Delete the remote object
        final Todo todo = todos.get(info.position);

        new RemoteDataTask() {
          @Override
          protected Void doInBackground(Void... params) {
            try {
              todo.delete();
            } catch (AVException e) {}
            // 自定义事件统计
            AVAnalytics.onEvent(getApplicationContext(), "delete_todo");
            super.doInBackground();
            return null;
          }
        }.execute();
        return true;
    }
    return super.onContextItemSelected(item);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case INSERT_ID:
        createTodo();
        return true;
      case SEARCH_ID:
        searchInput = new EditText(this);
        new AlertDialog.Builder(this).setTitle("请输入").setIcon(android.R.drawable.ic_dialog_info)
            .setView(searchInput).setPositiveButton("确定", new OnClickListener() {

              @Override
              public void onClick(DialogInterface dialog, int which) {
                String inputSearch = searchInput.getText().toString();
                if (!AVUtils.isBlankString(inputSearch)) {
                  AVSearchQuery searchQuery = new AVSearchQuery(inputSearch);
                  searchQuery.search();
                }
              }
            }).setNegativeButton("取消", null).show();
        return true;
    }

    return super.onOptionsItemSelected(item);
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    super.onListItemClick(l, v, position, id);
    // 打开编辑页面，传递content和objectId过去
    Intent i = new Intent(this, CreateTodo.class);
    i.putExtra("content", todos.get(position).getString("content"));
    i.putExtra("objectId", todos.get(position).getObjectId());
    startActivityForResult(i, ACTIVITY_EDIT);
  }

}
