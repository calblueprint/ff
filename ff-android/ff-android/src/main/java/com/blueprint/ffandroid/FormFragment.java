package com.blueprint.ffandroid;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TimePicker;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link FormFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 *
 */
public class FormFragment extends Fragment implements View.OnClickListener,
        DatePickerDialog.OnDateSetListener, TimePickerDialog.OnTimeSetListener {

    static final int REQUEST_IMAGE_CAPTURE = 1;

    /** The parent MainActivity. */
    private MainActivity parent;

    /** Form Fields */
    private EditText kind_field;
    private EditText weight_field;
    private EditText pickup_time_field;
    private EditText address_field;

    /** The date the donation will be picked up */
    private Date pickup_date;

    /** Checks if date picker has been fired.
     * Related to a bug in dialog pickers in Android.
     */
    private boolean pickerFired;

    /** The ImageView that will appear on the screen. */
    private ImageView mImageView;

    public FormFragment() {
        // Required empty public constructor
    }

    public static FormFragment newInstance() {
        FormFragment fragment = new FormFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView =  inflater.inflate(R.layout.fragment_form, container, false);

        mImageView = (ImageView) rootView.findViewById(R.id.photo_imageview);
        parent = (MainActivity) getActivity();
        setupViews(rootView);

        loadDonation();

        return rootView;
    }

    private void loadDonation() {
        Donation donation = parent.donation;

        if (donation.getVehicle() != "") {
            kind_field.setText(donation.getVehicle());
        }
        if (donation.getWeight() != 0.0) {
            weight_field.setText(Double.toString(donation.getWeight()));
        }
        if (donation.getStartDate() != null) {
            pickup_time_field.setText(dateString(donation.getStartDate()));
        }
        if (donation.getLocation() != null) {
            address_field.setText(donation.getAddress());
        }
    }

    public void setupViews(View rootView) {
        ImageButton photo = (ImageButton) rootView.findViewById(R.id.camera_button);

        kind_field = (EditText) rootView.findViewById(R.id.donation_kind);
        weight_field = (EditText) rootView.findViewById(R.id.donation_weight);
        pickup_time_field = (EditText) rootView.findViewById(R.id.pickup_time);
        address_field = (EditText) rootView.findViewById(R.id.address_field);

        photo.setOnClickListener(this);
        pickup_time_field.setOnClickListener(this);
    }

    private String dateString(Date date) {
        DateFormat df = new SimpleDateFormat("hh:mm a MMMMM dd");
        return df.format(date);
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

    private void showPickupDateDialog() {
        Calendar cal = Calendar.getInstance();
        DatePickerDialog dialog = new DatePickerDialog(parent, this, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        dialog.show();
    }

    @Override
    public void onDateSet(DatePicker view, int year, int monthOfYear, int  dayOfMonth) {
        pickup_date = new Date(year, monthOfYear, dayOfMonth);
        if (!pickerFired) {
            pickerFired = true;
            showPickupTimeDialog();
        }
    }

    public void showPickupTimeDialog() {
        Calendar cal = Calendar.getInstance();
        TimePickerDialog dialog = new TimePickerDialog(parent, this, cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), false);
        dialog.show();
    }

    @Override
    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
        pickup_date.setMinutes(minute);
        pickup_date.setHours(hourOfDay);

        parent.donation.setStartDate(pickup_date);
        pickup_time_field.setText(dateString(pickup_date));
        pickerFired = false;
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.pickup_time:
                pickerFired = false;
                showPickupDateDialog();
                break;
            case R.id.pickup_button:
                break;
            case R.id.camera_button:
                dispatchTakePictureIntent();
                break;
        }
    }
}
