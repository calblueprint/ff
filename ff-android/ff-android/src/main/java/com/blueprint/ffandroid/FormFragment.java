package com.blueprint.ffandroid;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.TimePicker;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONObject;

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
        DatePickerDialog.OnDateSetListener, TimePickerDialog.OnTimeSetListener,
        View.OnFocusChangeListener {

    static final int REQUEST_IMAGE_CAPTURE = 1;

    /** The parent MainActivity. */
    private MainActivity parent;

    /** Form Fields */
    private EditText kind_field;
    private EditText weight_field;
    private EditText pickup_time_field;
    private EditText address_field;
    private Button pickup_button;

    private static final String url = "http://feeding-forever.herokuapp.com/api/session";

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
        setupFragment(rootView);

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

    public void setupFragment(View rootView) {
        ImageButton photo = (ImageButton) rootView.findViewById(R.id.camera_button);

        kind_field = (EditText) rootView.findViewById(R.id.donation_kind);
        weight_field = (EditText) rootView.findViewById(R.id.donation_weight);
        pickup_time_field = (EditText) rootView.findViewById(R.id.pickup_time);
        address_field = (EditText) rootView.findViewById(R.id.address_field);
        pickup_button = (Button) rootView.findViewById(R.id.pickup_button);

        pickup_button.setOnClickListener(this);

        photo.setOnClickListener(this);
        pickup_time_field.setOnClickListener(this);

        pickup_date = new Date();
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

    private void displayInvalidDialog() {
        int[] errors = parent.donation.getErrors();

        AlertDialog alertDialog = new AlertDialog.Builder(parent).create();
        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
            }
        });

        if (errors[0] == 1) { // Invalid Address
            alertDialog.setTitle("Invalid Address");
            alertDialog.setMessage("The address must be in the United States.");
            alertDialog.show();
        } else if (errors[1] == 1) { // Invalid weight
            alertDialog.setTitle("Invalid Weight");
            alertDialog.setMessage("The weight must be a number between 1 and 500.");
            alertDialog.show();
        } else if (errors[2] == 1) { // Invalid Start Date
            alertDialog.setTitle("Invalid Time");
            alertDialog.setMessage("The pickup time must be later than the current time.");
            alertDialog.show();
        } else if (errors[3] == 1) { // Invalid Kind
            alertDialog.setTitle("Invalid Kind");
            alertDialog.setMessage("The kind field cannot be blank.");
            alertDialog.show();
        }
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (!hasFocus) {
            if (kind_field.getId() == v.getId()) {
                parent.donation.setKind(kind_field.getText().toString());
            }
            if (address_field.getId() == v.getId()) {
                parent.donation.setAddress(address_field.getText().toString());
            }
        }
    }

    private void updateDonation() {
        try {
            parent.donation.setWeight(Double.parseDouble(weight_field.getText().toString()));
        } catch (NumberFormatException e) {
            System.out.println(e.toString());
        }
        parent.donation.setStartDate(pickup_date);
        parent.donation.setAddress(address_field.getText().toString());
        parent.donation.setKind(kind_field.getText().toString());
    }

    private boolean validateDonation() {
        System.out.println(parent.donation.isValid());
        return parent.donation.isValid();
    }

    private void postDonation() {
        RequestQueue queue = Volley.newRequestQueue(parent);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, url, parent.donation.toJSONObj(),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        // Got response
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        // Error
                    }
                }
        );

        queue.add(request);
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.pickup_time:
                pickerFired = false;
                showPickupDateDialog();
                break;
            case R.id.pickup_button:
                updateDonation();
                if (validateDonation()) {
                    postDonation();
                    parent.replaceFragment(parent.congratulatoryFragment);
                } else {
                    displayInvalidDialog();
                }
                break;
            case R.id.camera_button:
                dispatchTakePictureIntent();
                break;
        }
    }
}
