/*
 * Copyright 2008-2024 by Rightware. All rights reserved.
 */
package com.example.androiddatasourceplugin;

import com.rightware.kanzi.MetaclassRegistry;
import com.rightware.kanzi.Plugin;

public class AndroidDataSourcePlugin extends Plugin {
    @Override
    public String getName() {
        return BuildConfig.PLUGIN_NAME;
    }

    @Override
    public void registerClasses(MetaclassRegistry metaclassRegistry) {
        metaclassRegistry.registerClass(AndroidDataSourceDataSource.class);
    }
}
