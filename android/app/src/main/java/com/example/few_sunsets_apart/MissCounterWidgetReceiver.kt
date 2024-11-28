package com.example.few_sunsets_apart

import HomeWidgetGlanceWidgetReceiver
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import androidx.glance.GlanceId
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.action.ActionCallback
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
/**class MissCounterWidgetReceiver : HomeWidgetProvider() {
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
}**/

class MissCounterWidgetReceiver : HomeWidgetGlanceWidgetReceiver<MissCounterAppWidget>() {
    override val glanceAppWidget: MissCounterAppWidget
        get() = MissCounterAppWidget()
}

class InteractiveAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("homeWidgetExample://titleclicked"))
        backgroundIntent.send()
    }
}
