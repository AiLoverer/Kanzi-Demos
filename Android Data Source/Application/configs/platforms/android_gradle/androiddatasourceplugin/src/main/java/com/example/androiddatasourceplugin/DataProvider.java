package com.example.androiddatasourceplugin;

interface DataProvider {
    float getBatteryLevel();
    boolean isWifiEnabled();
    boolean isNetworkConnected();
    void setWifiEnabled(boolean enabled);
}
