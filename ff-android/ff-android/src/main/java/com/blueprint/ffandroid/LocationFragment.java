package com.blueprint.ffandroid;

import android.content.Context;
import android.content.IntentSender;
import android.graphics.Point;
import android.graphics.Typeface;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextWatcher;
import android.text.method.KeyListener;
import android.view.*;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


/**
 * A simple {@link android.support.v4.app.Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link LocationFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link LocationFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class LocationFragment extends Fragment implements View.OnClickListener, LocationListener,
        GooglePlayServicesClient.ConnectionCallbacks,
        GooglePlayServicesClient.OnConnectionFailedListener,
        View.OnFocusChangeListener, FragmentLifeCycle {


    /** A request code to send to Google Play services */
    private static final int CONNECTION_FAILURE_RESOLUTION_REQUEST = 9000;

    /** The location Client */
    private LocationClient mLocationClient;

    /** The parent activity */
    MainActivity parent;

    /** The Address Field displayed to the user */
    private EditText address_field;
    private ImageButton locationButton;

    private GoogleMap map;
    /**View used to save fragment state after onDestroy()**/
    private View rootView;

    /** Whether the fragment has been created previously */
    private boolean created = false;

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
        if (rootView != null) {
            ViewGroup parent = (ViewGroup) rootView.getParent();
            if (parent != null)
                parent.removeView(rootView);
        }
        try {
            rootView = inflater.inflate(R.layout.fragment_location, container, false);
        } catch (InflateException e) {
            /* map is already there, just return view as it is */
        }

        created = true;

        Button forward = (Button) rootView.findViewById(R.id.forward_button);
        forward.setOnClickListener(this);
        parent = (MainActivity)this.getActivity();

        address_field = (EditText) rootView.findViewById(R.id.address_field);
        address_field.setOnFocusChangeListener(this);


        InputFilter filter = new InputFilter() {
            public CharSequence filter(CharSequence source, int start, int end,
                                       Spanned dest, int dstart, int dend) {
                for (int i = start; i < end; i++) {
                    if (source.charAt(i) == '\n') {
                        InputMethodManager imm = (InputMethodManager) parent.getSystemService(
                                Context.INPUT_METHOD_SERVICE);
                        imm.hideSoftInputFromWindow(address_field.getWindowToken(), 0);
                        address_field.clearFocus();
                        return "";
                    }
                }
                return null;
            }
        };

        address_field.setFilters(new InputFilter[]{filter});


        locationButton = (ImageButton) rootView.findViewById(R.id.current_location_button);
        locationButton.setOnClickListener(this);

        setFonts(rootView);

        map = ((SupportMapFragment) parent.getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
        map.setMyLocationEnabled(true);
        mLocationClient = new LocationClient(parent, this, this);

        return rootView;
    }

    private void setFonts(View rootView){
        Typeface tf = (parent.myTypeface);
        address_field.setTypeface(tf);

        ((TextView) rootView.findViewById(R.id.address_header)).setTypeface(tf);
        ((TextView) rootView.findViewById(R.id.forward_button)).setTypeface(tf);
    }


    @Override
    public void onLocationChanged(Location location) {
        updateMap(location);

        getAddress(location);
        parent.donation.setLocation(location);
    }

    private void updateMap(Location location) {
        if (location != null) {
            double lat = location.getLatitude();
            double lng = location.getLongitude();

            LatLng myLocation = new LatLng(lat, lng);
            map.animateCamera(CameraUpdateFactory.newLatLngZoom(myLocation, 16));
            parent.donation.setLocation(location);
        }
    }

    private void updateMap(String address) {
        String address_url = address.replace(" ", "+");
        String url = "https://maps.googleapis.com/maps/api/geocode/json?address="+ address_url +"&sensor=true&key="+getString(R.string.GEOCODER_API_KEY);

        AsyncHttpClient client = new AsyncHttpClient();
        client.get(url, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(String response) {
                try {
                    JSONArray results = new JSONObject(response).getJSONArray("results");
                    JSONObject locationJson = results.getJSONObject(0).getJSONObject("geometry").getJSONObject("location");
                    double lat = locationJson.getDouble("lat");
                    double lng = locationJson.getDouble("lng");
                    Location loc = new Location("Google Geocoder API");
                    loc.setLatitude(lat);
                    loc.setLongitude(lng);
                    updateMap(loc);
                } catch (JSONException e) {
                    Toast.makeText(parent, "Error updating map", Toast.LENGTH_SHORT).show();
                }

            }
        });
    }

    private void getAddress(Location location) {
        String coordinates = location.getLatitude() + ","  + location.getLongitude();
        String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+ coordinates +"&sensor=true&key="+getString(R.string.GEOCODER_API_KEY);

        AsyncHttpClient client = new AsyncHttpClient();
        client.get(url, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(String response) {
                try {
                    JSONArray results = new JSONObject(response).getJSONArray("results");
                    String address = results.getJSONObject(0).getString("formatted_address");
                    JSONArray address_components = results.getJSONObject(0).getJSONArray("address_components");
                    String number = address_components.getJSONObject(0).getString("long_name");
                    String street = address_components.getJSONObject(1).getString("long_name");
                    String city = address_components.getJSONObject(2).getString("long_name");
                    String state = address_components.getJSONObject(4).getString("short_name");
                    setAddress(number+" "+street, city, state);
                    setAddress(address);
                } catch (JSONException e) {
                    Toast.makeText(parent, "Error retrieving address", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    /**
     * Update the donation object based on form field.
     */
    public void updateDonation() {
        parent.donation.setFullAddress(address_field.getText().toString());
    }

    /**
     * Sets the address of the donation.
     */
    public void setAddress(String address) {
        address_field.setText(address);
        parent.donation.setFullAddress(address);
    }

    /** Sets the and saves the ADDRESS, CITY, and STATE of the donation. */
    public void setAddress(String address, String city, String state) {
        parent.donation.setAddress(address, city, state);
    }

    /**
     * Called when the Activity becomes visible.
     */
    @Override
    public void onStart() {
        super.onStart();
        // Connect the client.
        mLocationClient.connect();
    }

    /**
     * Called when the Activity is no longer visible.
     */
    @Override
    public void onStop() {
        // Disconnecting the client invalidates it.
        mLocationClient.disconnect();
        super.onStop();
    }

    /**
         * Called by Location Services when the request to connect the
         * client finishes successfully. At this point, you can
         * request the current location or start periodic updates
         */
    @Override
    public void onConnected(Bundle dataBundle) {
        if (mLocationClient.isConnected()) {
            onLocationChanged(mLocationClient.getLastLocation());
            mLocationClient.disconnect();
        } else {
            System.out.println("not connected");
        }
    }

    /**
     * Called by Location Services if the connection to the
     * location client drops because of an error.
     */
    @Override
    public void onDisconnected() {
        // Display the connection status
        Toast.makeText(parent, "Disconnected. Please re-connect.",
                Toast.LENGTH_SHORT).show();
    }

    /*
     * Called by Location Services if the attempt to
     * Location Services fails.
     */
    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        /*
         * Google Play services can resolve some errors it detects.
         * If the error has a resolution, try sending an Intent to
         * start a Google Play services activity that can resolve
         * error.
         */
        if (connectionResult.hasResolution()) {
            try {
                // Start an Activity that tries to resolve the error
                connectionResult.startResolutionForResult(
                        parent,
                        CONNECTION_FAILURE_RESOLUTION_REQUEST);
                /*
                 * Thrown if Google Play services canceled the original
                 * PendingIntent
                 */
            } catch (IntentSender.SendIntentException e) {
                // Log the error
                e.printStackTrace();
            }
        } else {
            /*
             * If no resolution is available, display a dialog to the
             * user with the error.
             */
            //showErrorDialog(connectionResult.getErrorCode());
        }
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
        // TODO Auto-generated method stub
    }

    @Override
    public void onProviderEnabled(String provider) {
    }

    @Override
    public void onProviderDisabled(String provider) {
    }


    /** Called whenever the address field's focus has been changed.
     * @param v -- will always be this.address_field
     * @param hasFocus -- whether the object has focus or not
     */
    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (!hasFocus) {
            EditText address = (EditText) v;
            updateMap(address.getText().toString());
            setAddress(address.getText().toString());
        }
    }

    @Override
    public void willAppear() {
        return;
    }

    @Override
    public boolean isCreated() {
        return created;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case (R.id.forward_button):
                updateDonation();
                parent.mTitle = "Fill Out Donation Details";
                parent.getActionBar().setTitle(parent.mTitle);
                parent.replaceFragment(parent.formFragment);
                break;
            case (R.id.current_location_button):
                System.out.println("address");
                mLocationClient.connect();
                break;
        }
    }
}
