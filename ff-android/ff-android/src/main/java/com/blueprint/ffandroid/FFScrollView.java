package com.blueprint.ffandroid;

import android.content.Context;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.widget.ScrollView;

/**
 * Created by varunrau on 4/24/14.
 */
public class FFScrollView extends ScrollView {

    private OnScrollViewListener scrollViewListener;
    private static final int MAX_Y_OVERSCROLL_DISTANCE = 50;

    public FFScrollView(Context context) {
        super(context);
    }

    public FFScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public FFScrollView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        scrollViewListener.onScrollChanged(this, l, t, oldl, oldt);
        super.onScrollChanged(l, t, oldl, oldt);
    }
    public interface OnScrollViewListener {
        void onScrollChanged(FFScrollView v, int l, int t, int oldl, int oldt);
    }

    public void setScrollViewListener(OnScrollViewListener listener) {
        scrollViewListener = listener;
    }

    @Override
    protected boolean overScrollBy(int deltaX, int deltaY, int scrollX, int scrollY, int scrollRangeX, int scrollRangeY, int maxOverScrollX, int maxOverScrollY, boolean isTouchEvent) {
        final DisplayMetrics metrics = getContext().getResources().getDisplayMetrics();
        final float density = metrics.density;
        return super.overScrollBy(deltaX, deltaY, scrollX, scrollY, scrollRangeX, scrollRangeY, maxOverScrollX, (int) density * MAX_Y_OVERSCROLL_DISTANCE, isTouchEvent);
    }
}
