package com.avos.avoscloud.feedback;

import java.util.List;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUtils;
import com.avos.avoscloud.LogUtil;
import com.avos.avoscloud.feedback.Comment.CommentType;
import com.avos.avoscloud.feedback.FeedbackThread.SyncCallback;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.view.View.OnClickListener;

public class ThreadActivity extends Activity {

  FeedbackAgent agent;
  ListView feedbackListView;
  Button sendButton;
  EditText feedbackInput;
  EditText contact;
  FeedbackThread thread;
  FeedbackListAdapter adapter;
  SyncCallback syncCallback;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(Resources.layout.avoscloud_feedback_activity_conversation(this));

    setupActionBar();

    agent = new FeedbackAgent(this);
    adapter = new FeedbackListAdapter(this);
    thread = agent.getDefaultThread();
    feedbackListView = (ListView) findViewById(Resources.id.avoscloud_feedback_thread_list(this));
    feedbackListView.setAdapter(adapter);
    sendButton = (Button) findViewById(Resources.id.avoscloud_feedback_send(this));
    feedbackInput = (EditText) findViewById(Resources.id.avoscloud_feedback_input(this));
    syncCallback = new SyncCallback() {

      @Override
      public void onCommentsSend(List<Comment> comments, AVException e) {
        LogUtil.avlog.d("send new comments");
        adapter.notifyDataSetChanged();
      }

      @Override
      public void onCommentsFetch(List<Comment> comments, AVException e) {
        LogUtil.avlog.d("fetch new comments");
        adapter.notifyDataSetChanged();
      }

    };
    sendButton.setOnClickListener(new OnClickListener() {

      @Override
      public void onClick(View v) {
        String feedbackText = feedbackInput.getText().toString();
        if (!AVUtils.isBlankString(feedbackText)) {
          thread.add(new Comment(feedbackText));
          adapter.notifyDataSetChanged();
          feedbackListView.setSelection(feedbackListView.getAdapter().getCount());
          feedbackListView.smoothScrollToPosition(feedbackListView.getAdapter().getCount());
          thread.sync(syncCallback);
          feedbackInput.setText("");
        }
      }
    });

    feedbackInput.setOnFocusChangeListener(new OnFocusChangeListener() {

      @Override
      public void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus) {
          feedbackListView.setSelection(feedbackListView.getAdapter().getCount());
          feedbackListView.smoothScrollToPosition(feedbackListView.getAdapter().getCount());
        }
      }
    });
    contact = (EditText) findViewById(Resources.id.avoscloud_feedback_contact(this));
    if (agent.isContactEnabled()) {
      contact.setVisibility(View.VISIBLE);
      contact.setText(thread.getContact());
      contact.addTextChangedListener(new TextWatcher() {

        @Override
        public void afterTextChanged(Editable s) {
          if (!AVUtils.isBlankString(s.toString())) {
            thread.setContact(s.toString());
          }
        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }

      });
    } else {
      contact.setVisibility(View.GONE);
    }

    thread.sync(syncCallback);
  }

  public void setupActionBar() {
    ActionBar actionBar = getActionBar();
    if (actionBar != null) {
      actionBar.setCustomView(Resources.layout.avoscloud_feedback_thread_actionbar(this));
      actionBar.setDisplayShowCustomEnabled(true);
      actionBar.setDisplayShowHomeEnabled(false);
      actionBar.setDisplayShowTitleEnabled(false);
      View backButton =
          actionBar.getCustomView().findViewById(
              Resources.id.avoscloud_feedback_actionbar_back(this));
      backButton.setOnClickListener(new OnClickListener() {
        @Override
        public void onClick(View v) {
          onBackPressed();
          finish();
        }
      });
    }
  }

  public class FeedbackListAdapter extends BaseAdapter {

    Context mContext;
    LayoutInflater inflater;

    public FeedbackListAdapter(Context context) {
      this.mContext = context;
      inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
      return thread.getCommentsList().size();
    }

    @Override
    public Object getItem(int position) {
      return thread.getCommentsList().get(position);
    }

    @Override
    public long getItemId(int position) {
      return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      ViewHolder holder;
      if (convertView == null) {
        if (this.getItemViewType(position) == 0) {
          convertView =
              inflater.inflate(Resources.layout.avoscloud_feedback_user_reply(ThreadActivity.this),
                  null);
        } else {
          convertView =
              inflater.inflate(Resources.layout.avoscloud_feedback_dev_reply(ThreadActivity.this),
                  null);
        }
        holder = new ViewHolder();
        holder.content =
            (TextView) convertView.findViewById(Resources.id
                .avoscloud_feedback_content(ThreadActivity.this));
        holder.timestamp =
            (TextView) convertView.findViewById(Resources.id
                .avoscloud_feedback_timestamp(ThreadActivity.this));
        convertView.setTag(holder);
      } else {
        holder = (ViewHolder) convertView.getTag();
      }
      final Comment comment = (Comment) getItem(position);
      holder.content.setText(comment.getContent());
      if (Math.abs(comment.getCreatedAt().getTime() - System.currentTimeMillis()) < 10000) {
        holder.timestamp.setText(getResources().getString(
            Resources.string.avosclou_feedback_just_now(ThreadActivity.this)));
      } else {
        holder.timestamp.setText(DateUtils.getRelativeTimeSpanString(comment.getCreatedAt()
            .getTime(), System.currentTimeMillis() - 1, 0l, DateUtils.FORMAT_ABBREV_ALL));
      }
      return convertView;
    }

    @Override
    public int getViewTypeCount() {
      return 2;
    }

    @Override
    public int getItemViewType(int position) {
      Comment comment = (Comment) this.getItem(position);
      if (comment.getCommentType().equals(CommentType.USER)) {
        return 0;
      } else {
        return 1;
      }
    }
  }

  public class ViewHolder {
    TextView content;
    TextView timestamp;
  }

}
