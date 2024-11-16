package com.example.few_sunsets_apart

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class MissCounterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.miss_counter_widget).apply {
                val widgetText = widgetData.getString("appwidget_text", null)
                setTextViewText(R.id.appwidget_text, widgetText)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}