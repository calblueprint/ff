package com.blueprint.ffandroid;

import android.app.ActionBar;
import android.app.Activity;
import android.support.v4.app.FragmentManager;
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
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.text.SimpleDateFormat;

/**
 * Created by Nishant on 4/27/14.
 */
public class DonationDetailFragment extends Fragment implements FragmentLifeCycle{


    Donation donation;
    private SimpleDateFormat sdf = new SimpleDateFormat("EEE, MMM d, ''yy");

    /** The TextView that shows what kind of donation it is. */
    private TextView kind;
    /** The TextView that shows the date of the donation. */
    private TextView date;
    /** The TextView that shows the status of the donation. */
    private TextView status;
    /** The TextView that shows the address of the donation. */
    private TextView address;
    /** The top circle in the view. */
    private ImageView topCircle;
    /** The middle circle in the view. */
    private ImageView midCircle;
    /** The bottom circle in the view. */
    private ImageView botCircle;
    /** The status of the donation. */
    private String statusValue;
    /** Determins whether or not the view was created. */
    private boolean created = false;

    public static DonationDetailFragment newInstance(){
        return new DonationDetailFragment();
    }

    public DonationDetailFragment(){
        donation = new Donation();
    }

    /** Takes in a donation D and sets all the texts and colors in the
     * TextView. */
    void setDonationText(Donation d){
        kind.setText(d.getKind());
        statusValue = d.getStatus();
        status.setText(statusValue);
        Context context = this.getActivity();
        if (statusValue.equals("complete")) {
            status.setTextColor(context.getResources().getColor(R.color.complete));
            setProgress(0);
        } else if (statusValue.equals("canceled")) {
            status.setTextColor(context.getResources().getColor(R.color.canceled));
            setProgress(4);
        } else if (statusValue.equals("moving")) {
            status.setTextColor(context.getResources().getColor(R.color.moving));
            setProgress(1);
        } else if (statusValue.equals("available")) {
            status.setTextColor(context.getResources().getColor(R.color.available));
            setProgress(2);
        } else if (statusValue.equals("claimed")) {
            setProgress(1);
            status.setTextColor(context.getResources().getColor(R.color.claimed));
        } else {
            status.setTextColor(context.getResources().getColor(R.color.unknown));
        }
        address.setText(d.getAddress());
        date.setText(sdf.format(d.getdateCreated()));
    }

    /** Takes in a Donation D and updates the TextView. */
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

        //Button back = (Button) rootView.findViewById(R.id.back);
        Button cancel = (Button) rootView.findViewById(R.id.cancel_pickup);
/*
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FragmentManager fm = DonationDetailFragment.this.getActivity().getSupportFragmentManager();
                fm.popBackStack();
                MainActivity mainActivity = (MainActivity) DonationDetailFragment.this.getActivity();
                Fragment listViewFragment = mainActivity.donationListFragment;
                mainActivity.replaceFragment(listViewFragment);
            }
        });
*/
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO: Make API request to cancel donation
            }
        });
        created = true;
        kind =  (TextView) rootView.findViewById(R.id.kind);
        date = (TextView) rootView.findViewById(R.id.date);
        status = (TextView) rootView.findViewById(R.id.status);
        address = (TextView) rootView.findViewById(R.id.address);
        topCircle = (ImageView) rootView.findViewById(R.id.top_circle);
        midCircle = (ImageView) rootView.findViewById(R.id.mid_circle);
        botCircle = (ImageView) rootView.findViewById(R.id.bot_circle);

        setDonationText(donation);

        return rootView;
    }

    /**
     * Returns the name of the class as a string.
     * useful for backstack.
     */
    public String getName() {
        return "DonationDetailFragment";
    }

    @Override
    public void willAppear() {
        return;
    }

    @Override
    public boolean isCreated() {
        return created;
    }

    /** Sets the progress bar to the correct STEP. */
    private void setProgress(int step) {
        topCircle.setImageResource(R.drawable.ic_black_circle);
        midCircle.setImageResource(R.drawable.ic_black_circle);
        botCircle.setImageResource(R.drawable.ic_black_circle);
        if (step == 2) {
            topCircle.setImageResource(R.drawable.ic_bp_blue_circle);
        } else if (step == 1) {
            midCircle.setImageResource(R.drawable.ic_bp_blue_circle);
        } else if (step == 0) {
            botCircle.setImageResource(R.drawable.ic_bp_blue_circle);
        }
    }
}

