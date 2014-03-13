package com.blueprint.ffandroid;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link AmountFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link AmountFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class AmountFragment extends Fragment implements View.OnClickListener {

    /** The parent activity of this fragment. */
    private MainActivity parent;
    /** The spinner that holds the amount. */
    private Spinner amount;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @return A new instance of fragment AmountFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AmountFragment newInstance() {
        AmountFragment fragment = new AmountFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }
    public AmountFragment() {
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
        View rootView =  inflater.inflate(R.layout.fragment_amount, container, false);
        Button forward = (Button) rootView.findViewById(R.id.forward_button);
        forward.setOnClickListener(this);

        setUpView(rootView);
        parent = (MainActivity) getActivity();
        amount = (Spinner) rootView.findViewById(R.id.pounds_spinner);
        return rootView;
    }
    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    public void setUpView(View rootView) {
        Spinner poundsSpinner = (Spinner) rootView.findViewById(R.id.pounds_spinner);

        List pounds = new ArrayList();
        
        pounds.add("1 pound");
        for (int i = 2; i <= 500; i++) {
            pounds.add(i+" pounds");
        }

        ArrayAdapter dataAdapter = new ArrayAdapter(getActivity(), android.R.layout.simple_spinner_item, pounds);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        poundsSpinner.setAdapter(dataAdapter);

    }

    /** Updates the donation. */
    private void updateDonation() {
        String weight = amount.getSelectedItem().toString();
        weight = weight.substring(0, weight.length() - 6);
        parent.donation.setWeight(Double.parseDouble(weight));
    }

    /** Takes in the VIEW and updates the donation. */
    public void onClick(View view) {
        updateDonation();
    }


}
