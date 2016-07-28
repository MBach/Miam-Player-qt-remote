package org.miamplayer.remote.utils;

import android.content.Context;
import android.net.wifi.WifiManager;

/**
 * \brief	The WifiActivator class is used to activate WiFi through the App.
 * \author      Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
public class WifiActivator extends org.qtproject.qt5.android.bindings.QtActivity {

    private static WifiManager wifiManager;
    private static WifiActivator instance;

    public WifiActivator()
    {
        instance = this;
    }

    public static void activate()
    {
        if (wifiManager == null) {
            wifiManager = (WifiManager)instance.getSystemService(Context.WIFI_SERVICE);
        }
        wifiManager.setWifiEnabled(true);
    }

}
