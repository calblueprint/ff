package com.blueprint.ffandroid;

import android.content.IntentSender;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.loopj.android.http.*;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONArray;
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
        GooglePlayServicesClient.OnConnectionFailedListener {


    /** A request code to send to Google Play services */
    private static final int CONNECTION_FAILURE_RESOLUTION_REQUEST = 9000;

    /** The location Client */
    private LocationClient mLocationClient;

    /** The parent activity */
    MainActivity parent;

    /** The Address Field displayed to the user */
    private EditText address_field;

    private LocationManager locationManager;

    private GoogleMap map;

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

        address_field = (EditText) rootView.findViewById(R.id.address_field);

        map = ((SupportMapFragment) parent.getSupportFragmentManager().findFragmentById(R.id.map)).getMap();
        map.setMyLocationEnabled(true);
        mLocationClient = new LocationClient(parent, this, this);

        return rootView;
    }

    @Override
    public void onLocationChanged(Location location) {
        double lat = location.getLatitude();
        double lng = location.getLongitude();

        CameraUpdate center = CameraUpdateFactory.newLatLng(new LatLng(lat, lng));
        CameraUpdate zoom = CameraUpdateFactory.zoomTo(15);

        map.moveCamera(center);
        map.animateCamera(zoom);

        getAddress(location);
        parent.donation.setLocation(location);
    }

    private void getAddress(Location location) {
        String coordinates = location.getLatitude() + ","  + location.getLongitude();
        String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+ coordinates +"&sensor=true&key="+getString(R.string.GEOCODER_API_KEY);
        System.out.println(url);
        AsyncHttpClient client = new AsyncHttpClient();

        client.get(url, new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(String response) {
                try {
                    JSONArray results = new JSONObject(response).getJSONArray("results");
                    String address = results.getJSONObject(0).getString("formatted_address");
                    setAddress(address);
                } catch (org.json.JSONException e) {
                    Toast.makeText(parent, "Error retrieving address", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    /**
     * Sets and saves the ADDRESS of the donation.
     */
    public void setAddress(String address) {
        address_field.setText(address);
        parent.donation.setAddress(address);
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
        onLocationChanged(mLocationClient.getLastLocation());
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
                parent.replaceFragment(parent.formFragment);
                break;
        }
    }
}
