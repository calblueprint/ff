package com.blueprint.ffandroid;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link TitleFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link TitleFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class TitleFragment extends Fragment implements View.OnClickListener{
    /** The parent MainActivity. */
    private MainActivity parent;

    /** The EditText that contains the title. */
    private EditText title;
    /** The EditText that contains the description. */
    private EditText description;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment TitleFragment.
     */
    public static TitleFragment newInstance() {
        TitleFragment fragment = new TitleFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }
    public TitleFragment() {
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
        View rootView = inflater.inflate(R.layout.fragment_title, container, false);
        Button forward = (Button) rootView.findViewById(R.id.forward_button);
        title = (EditText) rootView.findViewById(R.id.donation_title);
        description = (EditText) rootView.findViewById(R.id.donation_description);
        forward.setOnClickListener(this);
        parent = (MainActivity)this.getActivity();
        return rootView;
    }

    /**
     * Update the donation model with the current info on the
     * screen before passing it along.
     */
    private void updateDonationModel() {
        parent.donation.setTitle(title.getText().toString());
        parent.donation.setDescription(description.getText().toString());
    }

    @Override
    public void onClick(View v){
        switch(v.getId()){
            case (R.id.forward_button):
                updateDonationModel();
                parent.getSupportFragmentManager().beginTransaction()
                        .replace(R.id.container, PhotoFragment.newInstance())
                        .commit();
                break;
        }
    }

}
