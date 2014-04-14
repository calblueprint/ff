package com.blueprint.ffandroid;

import android.app.Activity;
import android.app.ListFragment;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.TextView;

/**
 * Created by Nishant on 4/12/14.
 */
public class DonationListFragment extends ListFragment{

    private String url;


    public DonationListFragment(String url) {
        super();
        this.url = url;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        // Inflate the layout for this fragment
//        View rootView = inflater.inflate(R.layout.fragment_donation_list, container, false);
//
//
//        return rootView;
//
//    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState){

    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

}

class DonationAdapter extends ArrayAdapter<Donation> {

    private Donation[] data;
    private Context context;

    public DonationAdapter(Context context, Donation[] data){
        super(context, R.layout.donation_table_row, data);
        this.data = data;
        this.context = context;
    }



}
