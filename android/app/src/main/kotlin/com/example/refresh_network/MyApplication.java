package com.example.refresh_network;

import android.app.Application;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.UserManager;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.work.Configuration;
import androidx.work.WorkManager;

public class MyApplication extends Application implements Configuration.Provider {

    @Override
    public void onCreate() {
        super.onCreate();

        // 先检测是否可以初始化 WorkManager
        if (isUserUnlocked()) {
            initWorkManager();
        } else {
            // 监听用户解锁事件，延迟初始化
            new Handler(Looper.getMainLooper()).postDelayed(this::initWorkManager, 5000);
        }
    }

    private void initWorkManager() {
        try {
            WorkManager.initialize(this, new Configuration.Builder().build());
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
    }

    private boolean isUserUnlocked() {
        UserManager userManager = (UserManager) getSystemService(Context.USER_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            return userManager != null && userManager.isUserUnlocked();
        }
        return  true;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
//        MultiDex.install(this);
    }

    @NonNull
    @Override
    public Configuration getWorkManagerConfiguration() {
        return new Configuration.Builder().build();
    }
}