package com.blueprint.ffandroid;

import android.app.Activity;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.content.Context;
import android.content.SharedPreferences;



/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 *
 * @author howardchen
 *
 */
public class AccountFragment extends Fragment implements View.OnClickListener{

    /** The name of the account.*/
    private String name;
    /** The email of the account.*/
    private String email;
    /** The Organization of the account.*/
    private String organization;
    /** The phone number of the account.*/
    private String phoneNumber;
    /** The String for the Shared Preference. */
    public static final String PREFS = "LOGIN_PREFS";

    private OnFragmentInteractionListener mListener;

    /** The TextView that holds the user's name. */
    private TextView nameText;
    /** The TextView that holds the user's Email. */
    private TextView emailText;
    /** The TextView that holds the user's organization. */
    private TextView organizationText;
    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment AccountFragment.
     */
    public static AccountFragment newInstance() {
        AccountFragment fragment = new AccountFragment();
        return fragment;
    }

    /**
     * Basic AccountFragment constructor.
     */
    public AccountFragment() {

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        SharedPreferences prefs = getActivity().getSharedPreferences(PREFS, 0);
        name = prefs.getString("name","");
        email = prefs.getString("email", "");
        organization = prefs.getString("role", "");
        super.onCreate(savedInstanceState);
        System.out.println("Created account fragment!");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment



        View rootView = inflater.inflate(R.layout.fragment_account, container, false);
        nameText = (TextView) rootView.findViewById(R.id.account_name);
        nameText.setText(name);
        emailText = (TextView) rootView.findViewById(R.id.account_email);
        emailText.setText(email);
        organizationText = (TextView) rootView.findViewById(R.id.account_organization);
        organizationText.setText(organization);
        return rootView;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void onClick(View v) {
        switch(v.getId()){
            default:
                break;
        }
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
        // TODO: Update argument type and name
        public void onFragmentInteraction(Uri uri);
    }

}