package com.avos.demo;

import java.util.List;

import com.avos.avoscloud.AVObject;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class TodoAdapter extends BaseAdapter {

  Context mContext;
  List<AVObject> todos;

  public TodoAdapter(Context context, List<AVObject> todos) {
    mContext = context;
    this.todos = todos;
  }

  @Override
  public int getCount() {
    return todos.size();
  }

  @Override
  public Object getItem(int position) {
    todos.get(position);
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
    text.setText((String) todos.get(position).get("name"));
    return convertView;
  }

}
