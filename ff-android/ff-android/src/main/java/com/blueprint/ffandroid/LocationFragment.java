package com.blueprint.ffandroid;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link LocationFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link LocationFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class LocationFragment extends Fragment implements View.OnClickListener {

    MainActivity parent;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment LocationFragment.
     */
    public static LocationFragment newInstance() {
        LocationFragment fragment = new LocationFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }
    public LocationFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView =  inflater.inflate(R.layout.fragment_location, container, false);
        Button forward = (Button) rootView.findViewById(R.id.forward_button);
        forward.setOnClickListener(this);
        parent = (MainActivity)this.getActivity();
        return rootView;
    }

    /**
     * Update the donation model with the current info on the
     * screen before passing it along.
     */
    private void updateDonationModel() {
        return;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case (R.id.forward_button):
                updateDonationModel();
                parent.replaceFragment(parent.amountFragment);
                break;
        }
    }
}
