package com.upino.upino

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Safe-to-Spend on the home screen. The app writes the figure already
 * formatted, so the widget does no arithmetic and cannot disagree with it.
 */
class UpinoWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.upino_widget).apply {
                setTextViewText(R.id.widget_label, widgetData.getString("label", "Safe to spend"))
                setTextViewText(R.id.widget_amount, widgetData.getString("amount", "—"))
                setTextViewText(R.id.widget_note, widgetData.getString("note", ""))
                setTextViewText(R.id.widget_spend, widgetData.getString("spend", "+"))
                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
                setOnClickPendingIntent(
                    R.id.widget_spend,
                    HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("upino://spend"),
                    ),
                )
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
