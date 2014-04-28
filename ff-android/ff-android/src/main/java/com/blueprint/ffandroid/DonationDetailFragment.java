package com.blueprint.ffandroid;

import android.app.Activity;
import android.support.v4.app.FragmentTransaction;
import android.content.Intent;
import android.net.Uri;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.text.SimpleDateFormat;

/**
 * Created by Nishant on 4/27/14.
 */
public class DonationDetailFragment extends Fragment {

    Donation donation;
    private SimpleDateFormat sdf = new SimpleDateFormat("EEE, MMM d, ''yy");

    private TextView kind;
    private TextView date;
    private TextView status;
    private TextView address;

    public static DonationDetailFragment newInstance(){
        return new DonationDetailFragment();
    }

    public DonationDetailFragment(){
        donation = new Donation();
    }

    void setDonationText(Donation d){
        kind.setText(d.getKind());
        status.setText(d.getStatus());
        address.setText(d.getAddress());
        date.setText(sdf.format(d.getdateCreated()));
    }

    void updateView(Donation d){
        this.donation = d;
        if (kind != null) {
            setDonationText(d);
        }

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.donation_detail, container, false);

        Button back = (Button) rootView.findViewById(R.id.back);
        Button cancel = (Button) rootView.findViewById(R.id.cancel_pickup);

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity mainActivity = (MainActivity) DonationDetailFragment.this.getActivity();
                Fragment listViewFragment = mainActivity.donationListFragment;
                mainActivity.replaceFragment(listViewFragment);
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO: Make API request to cancel donation
            }
        });

        kind =  (TextView) rootView.findViewById(R.id.kind);
        date = (TextView) rootView.findViewById(R.id.date);
        status = (TextView) rootView.findViewById(R.id.status);
        address = (TextView) rootView.findViewById(R.id.address);

        setDonationText(donation);

        return rootView;
    }

}
