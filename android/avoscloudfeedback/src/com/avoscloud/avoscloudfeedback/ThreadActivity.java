package com.avoscloud.avoscloudfeedback;

import java.util.List;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUtils;
import com.avos.avoscloud.LogUtil;
import com.avoscloud.avoscloudfeedback.Comment.CommentType;
import com.avoscloud.avoscloudfeedback.FeedbackThread.SyncCallback;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
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
    setContentView(R.layout.avoscloud_feedback_activity_conversation);

    setupActionBar();

    agent = new FeedbackAgent(this);
    adapter = new FeedbackListAdapter(this);
    thread = agent.getDefaultThread();
    feedbackListView = (ListView) findViewById(R.id.avoscloud_feedback_thread_list);
    feedbackListView.setAdapter(adapter);
    sendButton = (Button) findViewById(R.id.avoscloud_feedback_send);
    feedbackInput = (EditText) findViewById(R.id.avoscloud_feedback_input);
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
          feedbackListView.setSelection(thread.getCommentsList().size() - 1);
          thread.sync(syncCallback);
          feedbackInput.setText("");
        }
      }
    });

    contact = (EditText) findViewById(R.id.avoscloud_feedback_contact);
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

    feedbackListView.setOnScrollListener(new OnScrollListener() {

      @Override
      public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount,
          int totalItemCount) {
        if (firstVisibleItem > 0) {
          contact.setVisibility(View.GONE);
        } else {
          contact.setVisibility(View.VISIBLE);
        }
      }

      @Override
      public void onScrollStateChanged(AbsListView view, int scrollState) {

      }

    });

    thread.sync(syncCallback);
  }

  public void setupActionBar() {
    ActionBar actionBar = getActionBar();
    actionBar.setCustomView(R.layout.avoscloud_feedback_thread_actionbar);
    actionBar.setDisplayShowCustomEnabled(true);
    actionBar.setDisplayShowHomeEnabled(false);
    actionBar.setDisplayShowTitleEnabled(false);
    actionBar.setBackgroundDrawable(getResources().getDrawable(
        R.drawable.avoscloud_feedback_user_reply_background));
    View backButton =
        actionBar.getCustomView().findViewById(R.id.avoscloud_feedback_actionbar_back);
    backButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        onBackPressed();
        finish();
      }
    });
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
          convertView = inflater.inflate(R.layout.avoscloud_feedback_user_reply, null);
        } else {
          convertView = inflater.inflate(R.layout.avoscloud_feedback_dev_reply, null);
        }
        holder = new ViewHolder();
        holder.content = (TextView) convertView.findViewById(R.id.avoscloud_feedback_content);
        holder.timestamp = (TextView) convertView.findViewById(R.id.avoscloud_feedback_timestamp);
        convertView.setTag(holder);
      } else {
        holder = (ViewHolder) convertView.getTag();
      }
      final Comment comment = (Comment) getItem(position);
      holder.content.setText(comment.getContent());
      holder.timestamp.setText(DateUtils.getRelativeTimeSpanString(
          comment.getCreatedAt().getTime(), System.currentTimeMillis() - 1, 0l,
          DateUtils.FORMAT_ABBREV_ALL));
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
