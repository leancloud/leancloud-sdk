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
        try {
            String code = getIntent().getStringExtra(DemoBaseActivity.CONTENT_TAG);
            InputStream inputStream = getAssets().open("index.html");
            String template = DemoBaseActivity.readTextFile(inputStream);
            template = template.replace("__CODE__", code);
            String baseUrl = "file:///android_asset/";
            webView.loadDataWithBaseURL(baseUrl, template, "text/html", "UTF-8", "");
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

}
