package com.blueprint.ffandroid;

import android.content.Context;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.text.style.MetricAffectingSpan;
import android.util.LruCache;

/**
 * A class that styles a Spannable with a typeface.
 */
public class TypefaceSpan extends MetricAffectingSpan{

    /** A LruCache for typefaces. */
    private static LruCache<String, Typeface> typefaceCache = new LruCache<String, Typeface>(12);

    private Typeface tf;

    /** The TypefaceSpan in a given CONTEXT with the typeface TYPEFACENAME. */
    public TypefaceSpan(Context context, String typefaceName) {
        tf = typefaceCache.get(typefaceName);
        if (tf == null) {
            MainActivity parent = (MainActivity) context;
            tf = parent.myTypeface;
            typefaceCache.put(typefaceName, tf);
        }
    }

    @Override
    public void updateMeasureState(TextPaint p) {
        p.setTypeface(tf);
        p.setFlags(p.getFlags() | Paint.SUBPIXEL_TEXT_FLAG);
    }

    @Override
    public void updateDrawState(TextPaint tp) {
        tp.setTypeface(tf);
        tp.setFlags(tp.getFlags() | Paint.SUBPIXEL_TEXT_FLAG);
    }
}
