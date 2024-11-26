package com.example.androiddatasourceplugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.wifi.WifiManager;
import android.os.BatteryManager;

class AndroidDataProvider implements DataProvider
{
    private final BatteryManager mBatteryManager;
    private final ConnectivityManager mConnectivityManager;
    private final WifiManager mWifiManager;
    private final DataChangeListener mDataChangeListener;

    public AndroidDataProvider(Object context, DataChangeListener listener)
    {
        mDataChangeListener = listener;
        Context androidContext = (Context) context;

        mBatteryManager = (BatteryManager) androidContext.getSystemService(Context.BATTERY_SERVICE);
        mConnectivityManager =
                (ConnectivityManager) androidContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        mWifiManager = (WifiManager) androidContext.getSystemService(Context.WIFI_SERVICE);

        // To get battery changes, register the battery receiver.
        androidContext.registerReceiver(mBatteryReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

        // To get the WiFi connectivity state changes, register the WiFi state receiver.
        IntentFilter intentFilter = new IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION);
        androidContext.registerReceiver(mWifiStateReceiver, intentFilter);

        // Listen to connectivity state changes.
        mConnectivityManager.registerDefaultNetworkCallback(mNetworkCallback);
    }

    @Override
    public float getBatteryLevel()
    {
        int batLevel = mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        return ((float) batLevel) / 100.0f;
    }

    @Override
    public void setWifiEnabled(boolean enabled)
    {
        mWifiManager.setWifiEnabled(enabled);
    }

    @Override
    public boolean isWifiEnabled()
    {
        return mWifiManager.isWifiEnabled();
    }

    @Override
    public boolean isNetworkConnected()
    {
        NetworkCapabilities capabilities =
                mConnectivityManager.getNetworkCapabilities(mConnectivityManager.getActiveNetwork());
        if (capabilities == null)
            return false;
        return capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI);
    }

    // Battery level listener
    private final BroadcastReceiver mBatteryReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent)
        {
            int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            float batteryLevel = level / (float) scale;

            mDataChangeListener.updateBatteryLevel(batteryLevel);
        }
    };

    // WiFi state listener that indicates whether WiFi is enabled.
    private final BroadcastReceiver mWifiStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent)
        {
            int wifiStateExtra =
                    intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE, WifiManager.WIFI_STATE_UNKNOWN);
            switch (wifiStateExtra)
            {
                case WifiManager.WIFI_STATE_ENABLED:
                    mDataChangeListener.updateWifiEnabled(true);
                    break;
                case WifiManager.WIFI_STATE_DISABLED:
                    mDataChangeListener.updateWifiEnabled(false);
                    break;
            }
        }
    };

    // Network state listener that indicates whether an Internet connection is available.
    private final ConnectivityManager.NetworkCallback mNetworkCallback =
            new ConnectivityManager.NetworkCallback() {
                @Override
                public void onAvailable(Network network)
                {
                    super.onAvailable(network);
                    NetworkCapabilities capabilities = mConnectivityManager.getNetworkCapabilities(network);
                    if (capabilities != null)
                    {
                        mDataChangeListener.updateNetworkConnection(capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI));
                    }
                }

                @Override
                public void onLost(Network network)
                {
                    super.onLost(network);
                    mDataChangeListener.updateNetworkConnection(false);
                }
            };
}
