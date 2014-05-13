package com.avos.demo;

import com.avos.avoscloud.AVClassName;
import com.avos.avoscloud.AVObject;

@AVClassName(Todo.TODO_CLASS)
public class Todo extends AVObject {

  static final String TODO_CLASS = "Todo";
  private static final String CONTENT_KEY = "content";

  public String getContent() {
    return this.getString(CONTENT_KEY);
  }

  public void setContent(String content) {
    this.put(CONTENT_KEY, content);
  }
}
