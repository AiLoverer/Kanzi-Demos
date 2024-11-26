package com.example.androiddatasourceplugin;

class DummyDataProvider implements DataProvider
{
    @Override
    public float getBatteryLevel()
    {
        return 0.5f;
    }

    private boolean mWifiEnabled = false;

    @Override
    public boolean isWifiEnabled()
    {
        return mWifiEnabled;
    }

    @Override
    public boolean isNetworkConnected()
    {
        return mWifiEnabled;
    }

    @Override
    public void setWifiEnabled(boolean enabled) {
        mWifiEnabled = enabled;
    }
}
