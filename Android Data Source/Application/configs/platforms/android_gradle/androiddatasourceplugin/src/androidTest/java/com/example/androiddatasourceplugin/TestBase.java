/*
 * Copyright 2008-2024 by Rightware. All rights reserved.
 */
package com.example.androiddatasourceplugin;

import android.content.Context;
import android.os.Handler;

import androidx.test.core.app.ApplicationProvider;
import com.rightware.kanzi.Domain;
import com.rightware.kanzi.Node2D;
import com.rightware.kanzi.Scene;
import com.rightware.kanzi.TestRuntime;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.rules.ErrorCollector;

class TestBase
{
    @Rule
    public final ErrorCollector mErrorCollector = new ErrorCollector();

    private TestRuntime mRuntime;

    static
    {
        TestRuntime.LoadKanziLibraries();
    }

    @Before
    final public void baseSetUp()
    {
        mRuntime = new TestRuntime(getAndroidContext());

        new AndroidDataSourcePlugin().registerClasses(getDomain().getMetaclassRegistry());
    }

    @After
    final public void baseTearDown()
    {
        if (mRuntime != null)
        {
            mRuntime.close();
            mRuntime = null;
        }
    }

    protected Domain getDomain()
    {
        return mRuntime.getDomain();
    }

    protected Node2D getScreen()
    {
        return mRuntime.getScreen();
    }

    protected Scene getScene()
    {
        return mRuntime.getScene();
    }

    protected Context getAndroidContext()
    {
        return ApplicationProvider.getApplicationContext();
    }
}
