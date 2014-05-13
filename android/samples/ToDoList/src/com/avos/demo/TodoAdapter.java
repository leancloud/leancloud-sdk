package com.avos.demo;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class TodoAdapter extends BaseAdapter {

  Context mContext;
  List<Todo> todos;

  public TodoAdapter(Context context, List<Todo> todos) {
    mContext = context;
    this.todos = todos;
  }

  @Override
  public int getCount() {
    return todos != null ? todos.size() : 0;
  }

  @Override
  public Object getItem(int position) {
    if (todos != null)
      return todos.get(position);
    else
      return null;
  }

  @Override
  public long getItemId(int position) {
    return position;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {
    if (convertView == null) {
      convertView = LayoutInflater.from(mContext).inflate(R.layout.todo_row, null);
    }
    TextView text = (TextView) convertView.findViewById(R.id.text);
    Todo todo = todos.get(position);
    if (todo != null)
      text.setText(todo.getContent());
    return convertView;
  }

}
