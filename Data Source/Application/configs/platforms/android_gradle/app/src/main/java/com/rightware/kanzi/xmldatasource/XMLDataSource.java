package com.rightware.kanzi.xmldatasource;

import android.content.res.Configuration;
import android.os.Bundle;
import androidx.fragment.app.FragmentActivity;
import android.view.WindowManager;

import com.rightware.kanzi.KanziView;

public class XMLDataSource extends FragmentActivity
{
    private static final String TAG = "XMLDataSource";
    private KanziView mView = null;

    @Override
    protected void onCreate(Bundle icicle)
    {
        setContentView(R.layout.main);

        mView = findViewById(R.id.kanzicontent);
        mView.registerLifecycle(getLifecycle());

        // Force the screen to stay on when this app is on front (no need to clear).
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        super.onCreate(icicle);
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig)
    {
        super.onConfigurationChanged(newConfig);

        mView.setOrientation(newConfig.orientation);
    }
}