package com.example.mediationapp

import io.flutter.embedding.android.FlutterActivity

import android.app.AppOpsManager
import android.content.Context
import android.os.Binder
import androidx.annotation.NonNull
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log;

import java.util.*

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.example.mediationapp/usage_permission"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isUsageAccessGranted") {
                result.success(isUsageAccessGranted())
            }
            else if (call.method=="getUsageStats"){
                result.success(getUsageStats())
            }
            else {
                result.notImplemented()
            }
        }

    }

    private fun isUsageAccessGranted(): Boolean {
        val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOpsManager.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Binder.getCallingUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getUsageStats(): List<Map<String, Any>> {
        val usageStatsList = mutableListOf<Map<String, Any>>()
        try {
            val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val calendar = Calendar.getInstance()
            val endTime = calendar.timeInMillis
            calendar.add(Calendar.DAY_OF_MONTH, -1) // Fetch stats for the past day
            val startTime = calendar.timeInMillis

            val stats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startTime,
                endTime
            )

            stats?.forEach { usageStat ->
                if(usageStat!=null){
                    
                usageStatsList.add(
                    mapOf(
                        "packageName" to usageStat.packageName,
                        "totalTimeInForeground" to usageStat.totalTimeInForeground,
                        "lastTimeUsed" to usageStat.lastTimeUsed
                        
                    )
                )
                }
            }
        } catch (e: Exception) {
            Log.e("UsageStats", "Error fetching usage stats", e)
        }
        return usageStatsList
    }


}
