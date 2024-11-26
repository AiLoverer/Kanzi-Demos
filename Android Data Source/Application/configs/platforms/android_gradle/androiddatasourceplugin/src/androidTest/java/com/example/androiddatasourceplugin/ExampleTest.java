/*
 * Copyright 2008-2024 by Rightware. All rights reserved.
 */
package com.example.androiddatasourceplugin;

import static org.junit.Assert.assertEquals;

import com.rightware.kanzi.ObjectRef;

import org.junit.Test;

public class ExampleTest extends TestBase
{
    @Test
    public void example()
    {
        ObjectRef<AndroidDataSourceDataSource> ref = AndroidDataSourceDataSource.create(getDomain(), "Test Object");
        AndroidDataSourceDataSource src = ref.get();

        assertEquals("Test Object", src.getName());
    }
}
