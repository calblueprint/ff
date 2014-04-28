package com.blueprint.ffandroid;

import android.content.Context;
import android.graphics.Typeface;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * A list adapter for the navbar that allows images to be put next to text.
 */
public class ListAdapter extends BaseAdapter{
    private LayoutInflater inflater;
    private String[] data;
    private Typeface typeFace;
    private final String TAG = "ListAdapter";

    public ListAdapter(Context context, String[] data, Typeface tf){
        // Caches the LayoutInflater for quicker use
        this.inflater = LayoutInflater.from(context);
        // Sets the events data
        this.data= data;
        typeFace = tf;
    }

    public int getCount() {
        return this.data.length;
    }

    public String getItem(int position) throws IndexOutOfBoundsException{
        return this.data[position];
    }

    public long getItemId(int position) throws IndexOutOfBoundsException{
        if(position < getCount() && position >= 0 ){
            return position;
        }
        return 0;
    }

    public int getViewTypeCount(){
        return 1;
    }

    public View getView(int position, View convertView, ViewGroup parent){
        String myText = getItem(position);

        if(convertView == null){ // If the View is not cached
            // Inflates the Common View from XML file
            convertView = this.inflater.inflate(R.layout.navdrawer_row, null);
        }
        TextView myTextView = (TextView) convertView.findViewById(R.id.list_item);
        myTextView.setText(myText);
        myTextView.setTypeface(typeFace);
        switch (position) {
            case 0: ((ImageView)convertView.findViewById(R.id.list_image)).setImageResource(R.drawable.donate);
                break;
            case 1: ((ImageView)convertView.findViewById(R.id.list_image)).setImageResource(R.drawable.donatelist);
                break;
            case 2: ((ImageView)convertView.findViewById(R.id.list_image)).setImageResource(R.drawable.account);
                break;
            case 3: ((ImageView)convertView.findViewById(R.id.list_image)).setImageResource(R.drawable.faq);
                break;
            case 4: ((ImageView)convertView.findViewById(R.id.list_image)).setImageResource(R.drawable.logout);
                break;
        }
        return convertView;
    }
}