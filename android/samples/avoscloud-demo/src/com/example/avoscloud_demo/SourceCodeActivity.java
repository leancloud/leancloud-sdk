package com.example.avoscloud_demo;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebView;

import java.io.InputStream;

public class SourceCodeActivity extends Activity {
    private WebView webView = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);    //To change body of overridden methods use File | Settings | File Templates.
        webView = new WebView(this);
        webView.getSettings().setJavaScriptEnabled(true);
        setContentView(webView);
        loadContent();
    }

    private void loadContent() {
        String code = getIntent().getStringExtra(DemoBaseActivity.CONTENT_TAG);
        InputStream inputStream = getResources().openRawResource( getResources().getIdentifier("raw/" + "index", "raw", getPackageName()));
        String content = DemoBaseActivity.readTextFile(inputStream);
        content = content.replace("__CODE__", code);
        String baseUrl = "file:///android_asset/raw";
        webView.loadDataWithBaseURL(baseUrl, content, "", "", "");
    }

}
