package com.example.androiddatasourceplugin;

interface DataChangeListener {
    void updateBatteryLevel(float batteryLevel);
    void updateNetworkConnection(boolean isConnected);
    void updateWifiEnabled(boolean isEnabled);
}
