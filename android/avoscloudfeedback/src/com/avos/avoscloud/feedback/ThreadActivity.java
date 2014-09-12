package com.avos.avoscloud.feedback;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.AsyncTask;

import com.alibaba.fastjson.JSON;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVPersistenceUtils;
import com.avos.avoscloud.AVUtils;
import com.avos.avoscloud.GenericObjectCallback;
import com.avos.avoscloud.LogUtil;
import com.avos.avoscloud.PaasClient;

public class FeedbackThread {
  List<Comment> commentList;
  String contact;

  private static final String FEEDBACK_PATH = "feedback";
  private static final String FEEDBACK_PUT_PATH = "feedback/%s";
  private static final String FEEDBACK_THREAD_PATH = "feedback/%s/threads";
  private static FeedbackThread thread;

  private FeedbackThread() {
    String content = AVPersistenceUtils.readContentFromFile(getFeedbackCacheFile());
    contact = AVPersistenceUtils.readContentFromFile(getContactCacheFile());
    if (!AVUtils.isBlankString(content)) {
      try {
        commentList = JSON.parseArray(content, Comment.class);
      } catch (Exception e) {
        commentList = new LinkedList<Comment>();
      }
    } else {
      commentList = new LinkedList<Comment>();
    }
  }

  public static synchronized FeedbackThread getInstance() {
    if (thread == null) {
      thread = new FeedbackThread();
    }
    return thread;
  }

  public void add(Comment comment) {
    commentList.add(comment);
  }

  public List<Comment> getCommentsList() {
    return commentList;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    if (!AVUtils.isBlankString(contact) && !contact.equals(this.contact)) {
      this.contact = contact;
      if (commentList.size() > 0) {
        commentList.get(0).setSynced(false);
        saveContact();
      }
    }
  }

  public synchronized void sync(final SyncCallback callback) {
    if (commentList.size() > 0) {
      // 先保存后取
      new AsyncTask<Void, Integer, Exception>() {
        boolean flag = true;
        Exception sendException;

        @Override
        protected Exception doInBackground(Void... params) {
          for (int i = 0; i < commentList.size() && flag; i++) {
            if (!commentList.get(i).synced) {
              final Comment currentComment = commentList.get(i);
              if (currentComment.getAttachment() != null) {
                try {
                  currentComment.getAttachment().save();
                } catch (AVException e) {
                  return e;
                }
              }
              if (i == 0 && !AVUtils.isBlankString(currentComment.getObjectId())) {
                PaasClient.storageInstance().putObject(
                    String.format(FEEDBACK_PUT_PATH, currentComment.getObjectId()),
                    mapFromObject(currentComment, false), true, null, new GenericObjectCallback() {
                      @Override
                      public void onSuccess(String content, AVException e) {
                        if (e != null) {
                          sendException = e;
                          flag = false;
                          return;
                        } else {
                          JSONObject resp;
                          try {
                            resp = new JSONObject(content);
                            if (currentComment.getObjectId().equals(resp.getString("objectId"))) {
                              currentComment.setSynced(true);
                            }
                          } catch (JSONException e1) {
                            sendException = e;
                          }
                        }
                      }

                      @Override
                      public void onFailure(Throwable error, String content) {
                        LogUtil.log.d(content);
                        sendException = new Exception(error);
                        flag = false;
                      }
                    }, currentComment.getObjectId(), null);
              } else {
                PaasClient.storageInstance().postObject(
                    i == 0 ? FEEDBACK_PATH : String.format(FEEDBACK_THREAD_PATH, commentList.get(0)
                        .getObjectId()), mapFromObject(currentComment, i != 0), true,
                    new GenericObjectCallback() {
                      @Override
                      public void onSuccess(String content, AVException e) {
                        if (e != null) {
                          sendException = e;
                          flag = false;
                          return;
                        } else {
                          JSONObject resp;
                          try {
                            resp = new JSONObject(content);
                            currentComment.setObjectId(resp.getString("objectId"));
                            currentComment.setSynced(true);
                            currentComment.setCreatedAt(AVUtils.dateFromString(resp
                                .getString("createdAt")));
                          } catch (JSONException e1) {
                            sendException = e;
                          }
                        }
                      }

                      @Override
                      public void onFailure(Throwable error, String content) {
                        LogUtil.log.d(content);
                        sendException = new Exception(error);
                        flag = false;
                      }
                    });
              }
            }
          }
          return sendException;
        }

        @Override
        public void onPostExecute(Exception ex) {
          saveLocal();
          if (callback != null) {
            callback.onCommentsSend(commentList, ex == null ? null : new AVException(ex));
          }
          if (!AVUtils.isBlankString(commentList.get(0).getObjectId())) {
            PaasClient.storageInstance().getObject(
                String.format(FEEDBACK_THREAD_PATH, commentList.get(0).getObjectId()), null, false,
                null, new GenericObjectCallback() {
                  @Override
                  public void onSuccess(String content, AVException e) {
                    if (e != null) {
                      if (callback != null) {
                        callback.onCommentsFetch(commentList, e);
                      }
                      return;
                    } else {
                      try {
                        JSONObject resp = new JSONObject(content);
                        String results = resp.getString("results");
                        JSONArray commentJsonArray = new JSONArray(results);
                        List<Comment> thread = new LinkedList<Comment>();
                        for (int i = 0; i < commentJsonArray.length(); i++) {
                          JSONObject o = commentJsonArray.getJSONObject(i);
                          Comment c = getComentFromJSONObject(o);
                          if (c != null && !AVUtils.isBlankString(c.getObjectId())) {
                            thread.add(c);
                          }
                        }
                        Comment first = commentList.get(0);
                        commentList.clear();
                        commentList.add(first);
                        for (Comment c : thread) {
                          c.synced = true;
                          commentList.add(c);
                        }
                        if (callback != null) {
                          callback.onCommentsFetch(commentList, e);
                        }
                        saveLocal();
                      } catch (Exception ex) {
                        if (callback != null) {
                          callback.onCommentsFetch(commentList, new AVException(ex));
                        }
                      }
                    }
                  }

                  @Override
                  public void onFailure(Throwable error, String content) {
                    if (callback != null) {
                      callback.onCommentsFetch(commentList, new AVException(content, error));
                    }
                  }
                });
          }
        }
      }.execute((Void) null);
    }
  }

  public interface SyncCallback {
    public void onCommentsSend(List<Comment> comments, AVException e);

    public void onCommentsFetch(List<Comment> comments, AVException e);
  }

  protected void saveLocal() {
    String content = JSON.toJSONString(commentList);
    AVPersistenceUtils.saveContentToFile(content, getFeedbackCacheFile());
    saveContact();
  }

  private void saveContact() {
    if (!AVUtils.isBlankString(contact)) {
      AVPersistenceUtils.saveContentToFile(contact, getContactCacheFile());
    }
  }

  private static File getFeedbackCacheFile() {
    return new File(getFeedbackCacheDir(), "feedback");
  }

  private static File getContactCacheFile() {
    return new File(getFeedbackCacheDir(), "contact");
  }

  private static File getFeedbackCacheDir() {
    File dir = new File(AVPersistenceUtils.getCacheDir(), "FeedbackCache");
    dir.mkdirs();
    return dir;
  }

  protected Comment getComentFromJSONObject(JSONObject o) {
    Comment c = new Comment();
    try {
      c.setObjectId(o.getString("objectId"));
      if (o.has("content")) {
        String content = o.getString("content");
        if (!"null".equalsIgnoreCase(content)) {
          c.setContent(content);
        }
      }
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
      Date createdAt = sdf.parse(o.getString("createdAt"));
      c.setCreatedAt(createdAt);
      if (AVUtils.isBlankString(o.getString("type"))) {
        c.setType("user");
      } else {
        c.setType(o.getString("type"));
      }
      if (o.has("attachment") && !AVUtils.isBlankString(o.getString("attachment"))) {
        c.setAttachment(new AVFile(AVUtils.md5(o.getString("attachment")), o
            .getString("attachment"), null));
      }
      c.setSynced(true);
    } catch (Exception e) {
      return null;
    }
    return c;
  }

  protected String mapFromObject(Comment comment, boolean threadFlag) {

    HashMap<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("content", comment.getContent());
    if (threadFlag) {
      parameters.put("type", comment.getCommentType().toString());
    } else if (!AVUtils.isBlankContent(contact)) {
      parameters.put("contact", contact);
    }
    if (comment.getAttachment() != null) {
      parameters.put("attachment", comment.getAttachment().getUrl());
    }
    return AVUtils.restfulServerData(parameters);
  }
}
