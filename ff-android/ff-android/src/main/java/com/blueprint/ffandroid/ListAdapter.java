package com.blueprint.ffandroid;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * A list adapter
 */
public class ListAdapter extends BaseAdapter{
    private LayoutInflater inflater;
    private ArrayList<String> data;

    public ListAdapter(Context context, ArrayList<String> data){
        // Caches the LayoutInflater for quicker use
        this.inflater = LayoutInflater.from(context);
        // Sets the events data
        this.data= data;
    }

    public int getCount() {
        return this.data.size();
    }

    public String getItem(int position) throws IndexOutOfBoundsException{
        return this.data.get(position);
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
            convertView = this.inflater.inflate(R.id.navdrawer_row, null);
        }

        // Select your color and apply it to your textview
        int myColor;
        if(myText.substring(0, 1) == "a"){
        }else{
        }
        // Of course you will need to set the same ID in your item list XML layout.

        return convertView;
    }
}