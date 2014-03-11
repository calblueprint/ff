package com.blueprint.ffandroid;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link PhotoFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link PhotoFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class PhotoFragment extends Fragment implements View.OnClickListener {

    static final int REQUEST_IMAGE_CAPTURE = 1;

    /** The ImageView that appears on the screen */
    private ImageView mImageView;


    /** The parent MainActivity. */
    private MainActivity parent;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment PhotoFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static PhotoFragment newInstance() {
        PhotoFragment fragment = new PhotoFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }
    public PhotoFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView =  inflater.inflate(R.layout.fragment_photo, container, false);
        mImageView = (ImageView) rootView.findViewById(R.id.photo_imageview);
        parent = (MainActivity) getActivity();
        setupClickListeners(rootView);
        return rootView;
    }

    public void setupClickListeners(View rootView) {
        Button forward = (Button) rootView.findViewById(R.id.forward_button);
        Button photo = (Button) rootView.findViewById(R.id.camera_button);
        forward.setOnClickListener(this);
        photo.setOnClickListener(this);
    }

    private void dispatchTakePictureIntent() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getActivity().getPackageManager()) != null) {
            startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == getActivity().RESULT_OK) {
            Bundle extras = data.getExtras();
            Bitmap imageBitmap = (Bitmap) extras.get("data");

            mImageView.setImageBitmap(imageBitmap);
        }
    }

    public void updateDonationModel() {
        return;
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.forward_button:
                updateDonationModel();
                parent.getSupportFragmentManager().beginTransaction()
                        .replace(R.id.container, LocationFragment.newInstance())
                        .commit();
                break;
            case R.id.camera_button:
                dispatchTakePictureIntent();
                break;
            case R.id.camera_button_image:
                dispatchTakePictureIntent();
                break;
        }
    }

}
