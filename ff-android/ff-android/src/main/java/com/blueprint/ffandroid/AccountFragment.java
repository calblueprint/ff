package com.blueprint.ffandroid;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link TitleFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link TitleFragment#newInstance} factory method to
 * create an instance of this fragment.
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

    private OnFragmentInteractionListener mListener;

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
        name = "Yolo";
        email = "swag@swag.com";
        organization = "SwagTT";
        phoneNumber = "911-911-9111";

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.out.println("Created account fragment!");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_account, container, false);
        TextView editText = (TextView) rootView.findViewById(R.id.account_name);
        editText.setText(name);
        editText = (TextView) rootView.findViewById(R.id.account_email);
        editText.setText(email);
        editText = (TextView) rootView.findViewById(R.id.account_organization);
        editText.setText(organization);
        editText = (TextView) rootView.findViewById(R.id.account_number);
        editText.setText(phoneNumber);
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
            case(R.id.checkbox_cheese):
                //Do whatever is supposed to be done when the checkbox is toggled.
                break;
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
