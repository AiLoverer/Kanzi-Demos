/*
 * Copyright 2008-2024 by Rightware. All rights reserved.
 */
package com.example.androiddatasourceplugin;

import com.rightware.kanzi.DataObject;
import com.rightware.kanzi.DataObjectBool;
import com.rightware.kanzi.DataObjectInt;
import com.rightware.kanzi.DataObjectReal;
import com.rightware.kanzi.DataObjectString;
import com.rightware.kanzi.DataSource;
import com.rightware.kanzi.Domain;
import com.rightware.kanzi.Metaclass;
import com.rightware.kanzi.Metadata;
import com.rightware.kanzi.ObjectRef;
import com.rightware.kanzi.Platform;

public class AndroidDataSourceDataSource extends DataSource implements DataChangeListener {
    @Metadata
    public static final Metaclass metaclass = new Metaclass("AndroidDataSourceDataSource");

    static String BATTERY_LEVEL = "BatteryLevel";
    static String NETWORK_CONNECTED = "NetworkConnected";
    static String WIFI_ENABLED = "WifiEnabled";

    private ObjectRef<DataObject> mRoot;
    private DataProvider mDataProvider;

    public static ObjectRef<AndroidDataSourceDataSource> create(Domain domain, String name) {
        return DataSource.createDerived(domain, name, AndroidDataSourceDataSource.metaclass);
    }

    public DataObject getData() {
        return mRoot.get();
    }

    private AndroidDataSourceDataSource(Domain domain, long handle, Metaclass metaclass) {
        super(domain, handle, metaclass);
    }

    @Override
    protected void initialize() {
        super.initialize();

        Domain domain = getDomain();

        // Construct the proper DataProvider for the current platform.
        if (Platform.isAndroid())
        {
            mDataProvider = new AndroidDataProvider(getDomain().getPlatformContext(), this);
        }
        else
        {
            mDataProvider = new DummyDataProvider();
        }

        // Construct the data object tree of the data source.
        mRoot = DataObject.create(domain, "Root");
        DataObject root = mRoot.get();
        root.addChild(DataObjectReal.create(domain, BATTERY_LEVEL, mDataProvider.getBatteryLevel()).get());
        root.addChild(
                DataObjectBool.create(domain, NETWORK_CONNECTED, mDataProvider.isNetworkConnected()).get());
        ObjectRef<DataObjectBool> enabledRef =
                DataObjectBool.create(domain, WIFI_ENABLED, mDataProvider.isWifiEnabled());
        root.addChild(enabledRef.get());

        // Register a Notification handler to update WiFi state when Data Source changes.
        DataObjectBool wifiEnabled = enabledRef.get();
        wifiEnabled.addModifiedNotificationHandler(new ModifiedSubscriptionFunction() {
            @Override
            public void handle()
            {
                if (!mUpdateInProgress)
                {
                    mDataProvider.setWifiEnabled(wifiEnabled.getValue());
                }
            }
        });
    }

    @Override
    public void close() {
        mRoot.close();
        super.close();
    }

    private boolean mUpdateInProgress = false;
    @Override
    public void updateBatteryLevel(float batteryLevel)
    {
        DataObjectReal batteryObject =
                (DataObjectReal) mRoot.get().lookupDataContext(BATTERY_LEVEL);
        if (batteryObject != null)
        {
            mUpdateInProgress = true;
            batteryObject.setValue(batteryLevel);
            mUpdateInProgress = false;
        }
    }

    @Override
    public void updateNetworkConnection(boolean isConnected)
    {
        DataObjectBool networkConnected =
                (DataObjectBool) mRoot.get().lookupDataContext(NETWORK_CONNECTED);
        if (networkConnected != null)
        {
            mUpdateInProgress = true;
            networkConnected.setValue(isConnected);
            mUpdateInProgress = false;
        }
    }

    @Override
    public void updateWifiEnabled(boolean isEnabled)
    {
        DataObjectBool wifiEnabled = (DataObjectBool) mRoot.get().lookupDataContext(WIFI_ENABLED);
        if (wifiEnabled != null)
        {
            mUpdateInProgress = true;
            wifiEnabled.setValue(isEnabled);
            mUpdateInProgress = false;
        }
    }
}
