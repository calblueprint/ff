package com.blueprint.ffandroid;

import android.app.ActionBar;
import android.app.Activity;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.Image;
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
    /** The cancle image in the view. */
    private ImageView cancelCircle;
    /** The status of the donation. */
    private String statusValue;
    /** Determins whether or not the view was created. */
    private boolean created = false;
    /** The parent activity. */
    private MainActivity parent;
    /** The TextView for case1. */
    private TextView case1;
    /** The TextView for case2. */
    private TextView case2;
    /** The TextView for case3. */
    private TextView case3;
    /** The TextView for case4. */
    private TextView case4;

    public static DonationDetailFragment newInstance(){
        return new DonationDetailFragment();
    }

    public DonationDetailFragment(){
        parent = (MainActivity) getActivity();
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
            setProgress(2);
        } else if (statusValue.equals("canceled")) {
            status.setTextColor(context.getResources().getColor(R.color.canceled));
            setProgress(3);
        } else if (statusValue.equals("moving")) {
            status.setTextColor(context.getResources().getColor(R.color.moving));
            setProgress(2);
        } else if (statusValue.equals("available")) {
            status.setTextColor(context.getResources().getColor(R.color.available));
            setProgress(0);
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
        cancelCircle = (ImageView) rootView.findViewById(R.id.bot_circle);

        case1 = (TextView) rootView.findViewById(R.id.case_1);
        case2 = (TextView) rootView.findViewById(R.id.case_2);
        case3 = (TextView) rootView.findViewById(R.id.case_3);
        case4 = (TextView) rootView.findViewById(R.id.case_4);


        parent = (MainActivity) getActivity();
        setDonationText(donation);
        setFonts();
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

        if (step == 0) {
            Log.i("fgdgfd", topCircle.getBackground() + "");
            Drawable d = getResources().getDrawable(R.drawable.cars);
            d.setColorFilter(R.color.bp_blue, PorterDuff.Mode.MULTIPLY);
            topCircle.setBackground(d);

            topCircle.getBackground().setColorFilter(R.color.bp_blue, PorterDuff.Mode.MULTIPLY);
            topCircle.setColorFilter(R.color.bp_blue, PorterDuff.Mode.MULTIPLY);
            topCircle.setColorFilter(getResources().getColor(R.color.bp_blue));


        } else if (step == 1) {
            midCircle.setColorFilter(R.color.bp_blue);
            midCircle.getBackground().setColorFilter(R.color.bp_blue, PorterDuff.Mode.MULTIPLY);

        } else if (step == 2) {
            botCircle.setColorFilter(R.color.bp_blue);
        } else {
            cancelCircle.setColorFilter(R.color.bp_blue);
        }
    }

    /**
     * Sets the fonts of the Buttons and TextViews in this fragment
     */
    private void setFonts(){
        Typeface tf = (parent.myTypeface);
        kind.setTypeface(tf);
        date.setTypeface(tf);
        status.setTypeface(tf);
        address.setTypeface(tf);
        case1.setTypeface(tf);
        case2.setTypeface(tf);
        case3.setTypeface(tf);
        case4.setTypeface(tf);
    }
}

