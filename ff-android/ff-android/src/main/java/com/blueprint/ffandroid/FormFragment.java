package com.blueprint.ffandroid;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.ActionBar;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.telephony.PhoneNumberFormattingTextWatcher;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link FormFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 *
 */
public class FormFragment extends Fragment implements View.OnClickListener,
        DatePickerDialog.OnDateSetListener, TimePickerDialog.OnTimeSetListener,
        View.OnFocusChangeListener, FFScrollView.OnScrollViewListener,
        View.OnTouchListener {

    static final int REQUEST_IMAGE_CAPTURE = 1;

    /** The parent MainActivity. */
    private MainActivity parent;

    /** Form Fields */
    private EditText kind_field;
    private EditText weight_field;
    private EditText pickup_time_field;
    private EditText address_field;
    private Button pickup_button;
    private EditText finish_by_field;
    private EditText phone_field;

    private ImageView food_imageview;
    private FFScrollView scrollView;
    private RelativeLayout imageHeader;
    private TextView releaseTextView;

    private boolean showImage;

    private int imageHeight;

    private static final String url = "http://feeding-forever.herokuapp.com/api/pickups";

    /** The date the donation will be picked up. */
    private Date pickup_date;

    /** The date and time the donation must be picked up by. */
    private Date finish_by_date;

    /** Checks if date picker has been fired.
     * Related to a bug in dialog pickers in Android.
     */
    private boolean pickerFired;

    /** The datepicker that was displayed. */
    private int datePickerDisplayed;

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
        parent = (MainActivity) getActivity();
        setupFragment(rootView);
        setFonts(rootView);

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
            address_field.setText(donation.getFullAddress());
        }
        if (donation.getEndDate() != null) {
            finish_by_field.setText(dateString(donation.getEndDate()));
        }
    }

    public void setupFragment(View rootView) {
        ImageButton photo = (ImageButton) rootView.findViewById(R.id.camera_button);

        kind_field = (EditText) rootView.findViewById(R.id.donation_kind);
        weight_field = (EditText) rootView.findViewById(R.id.donation_weight_field);
        pickup_time_field = (EditText) rootView.findViewById(R.id.pickup_time);
        address_field = (EditText) rootView.findViewById(R.id.address_field);
        pickup_button = (Button) rootView.findViewById(R.id.pickup_button);
        finish_by_field = (EditText) rootView.findViewById(R.id.finish_by);
        phone_field = (EditText) rootView.findViewById(R.id.phone_field);
        food_imageview = (ImageView) rootView.findViewById(R.id.image_banner);
        scrollView = (FFScrollView) rootView.findViewById(R.id.scrollview);
        imageHeader = (RelativeLayout) rootView.findViewById(R.id.image_header_layout);

        phone_field.addTextChangedListener(new PhoneNumberFormattingTextWatcher());

        scrollView.setScrollViewListener(this);

        food_imageview.setImageResource(R.drawable.hipster_food);
        //imageHeight = (int) getResources().getDimension(R.dimen.picture_height);

        scrollToView(imageHeader);

        rootView.setOnTouchListener(this);

        pickup_button.setOnClickListener(this);
        photo.setOnClickListener(this);
        pickup_time_field.setOnClickListener(this);
        finish_by_field.setOnClickListener(this);

        pickup_date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.HOUR_OF_DAY, 2);
        finish_by_date = cal.getTime();
        finish_by_field.setText(dateString(finish_by_date));
    }

    /**
     * Sets the fonts of the Buttons and TextViews in this fragment
     */
    private void setFonts(View rootView){
        Typeface tf = (parent.myTypeface);
        kind_field.setTypeface(tf);
        weight_field.setTypeface(tf);
        pickup_time_field.setTypeface(tf);
        address_field.setTypeface(tf);
        pickup_button.setTypeface(tf);
        finish_by_field.setTypeface(tf);
        phone_field.setTypeface(tf);

        ((TextView) rootView.findViewById(R.id.kind_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.weight_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.start_date_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.end_date_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.address_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.phone_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.units)).setTypeface(tf);
    }

    public void onScrollChanged(FFScrollView v, int l, int t, int oldl, int oldt) {
        showImage = false;
        if (t <= 0) {
            updateImageView(t * -1);
            if (t < -80) {
                // open photo view
                showImage = true;
            }
        }
    }

    private final void scrollToView(View view){
        final View v = view;
        new Handler().post(new Runnable() {
            @Override
            public void run() {
                scrollView.scrollTo(0, v.getTop());
            }
        });
    }

    private void updateImageView(int t) {

//        Handler uiHandler = new Handler(Looper.getMainLooper());
//
//        final int delta = t;
//        uiHandler.post(new Runnable() {
//            @Override
//            public void run() {
//                RelativeLayout.LayoutParams layout = (RelativeLayout.LayoutParams) food_imageview.getLayoutParams();
//                layout.height = (imageHeight + (delta * 10));
//                food_imageview.setLayoutParams(layout);
//            }
//        });
//        
//        RelativeLayout.LayoutParams layout = (RelativeLayout.LayoutParams) food_imageview.getLayoutParams();
//        layout.height = imageHeight + (delta * 10);
//        food_imageview.setLayoutParams(layout);
    }

    @Override
    public boolean onTouch(View view, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_UP) {
            if (showImage) {
                System.out.println("show the image");
            }
        }
        return true;
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

            food_imageview.setImageBitmap(imageBitmap);
        }
    }

    private void showPickupDateDialog() {
        Calendar cal = Calendar.getInstance();
        DatePickerDialog dialog = new DatePickerDialog(parent, this, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH));
        dialog.show();
    }

    @Override
    public void onDateSet(DatePicker view, int year, int monthOfYear, int  dayOfMonth) {
        switch (datePickerDisplayed) {
            case R.id.finish_by:
                finish_by_date = new Date(year, monthOfYear, dayOfMonth);
                break;
            case R.id.pickup_time:
                pickup_date = new Date(year, monthOfYear, dayOfMonth);
                break;
        }
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
        switch (datePickerDisplayed) {
            case R.id.finish_by:
                finish_by_date.setMinutes(minute);
                finish_by_date.setHours(hourOfDay);
                parent.donation.setEndDate(finish_by_date);
                finish_by_field.setText(dateString(finish_by_date));
                break;
            case R.id.pickup_time:
                pickup_date.setMinutes(minute);
                pickup_date.setHours(hourOfDay);
                parent.donation.setStartDate(pickup_date);
                pickup_time_field.setText(dateString(pickup_date));
                break;
        }
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
        return parent.donation.isValid();
    }

    private void postDonation() {
        RequestQueue queue = Volley.newRequestQueue(parent);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, url+"?access_token="+parent.accessToken, parent.donation.toJSONObj(),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        // Got response
                        System.out.println("Got Response");
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        // Error
                        System.out.println(volleyError.toString());
                        volleyError.printStackTrace();
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
                datePickerDisplayed = R.id.pickup_time;
                break;
            case R.id.finish_by:
                pickerFired = false;
                showPickupDateDialog();
                datePickerDisplayed = R.id.finish_by;
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
