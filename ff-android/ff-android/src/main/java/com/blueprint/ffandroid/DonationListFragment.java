package com.blueprint.ffandroid;

import android.app.Activity;
import android.graphics.Typeface;
import android.support.v4.app.ListFragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.ArrayList;
import java.util.Locale;

/**
 * Created by Nishant on 4/12/14.
 */
public class DonationListFragment extends ListFragment{

    private static RequestQueue queue;
    private String token;
    private static SimpleDateFormat inputDateFormat =  new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);


    public static DonationListFragment newInstance(){
       return new DonationListFragment();
    }

    public DonationListFragment() {
        super();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }


    @Override
    public void onActivityCreated(Bundle savedInstanceState){
        super.onActivityCreated(savedInstanceState);

        SharedPreferences prefs = getActivity().getSharedPreferences(LoginActivity.PREFS, 0);
        this.token = prefs.getString("token", "None");
        this.queue = Volley.newRequestQueue(getActivity());

        JsonArrayRequest request = new JsonArrayRequest(getString(R.string.pickup_list_url) + token,
            new Response.Listener<JSONArray>() {
                @Override
                public void onResponse(JSONArray jsonArray) {
                    Donation[] data = new Donation[jsonArray.length()];

                    try{
                        for (int i=0; i<jsonArray.length(); i++) {
                            JSONObject jsonObject = jsonArray.getJSONObject(i);
                            Donation donation = new Donation();
                            donation.setAddress(jsonObject.getJSONObject("location").getString("text"));
                            donation.setKind(jsonObject.getString("kind"));
                            donation.setStatus(jsonObject.getString("status"));
                            String dateString = jsonObject.getString("createdAt");
                            donation.setDateCreated(inputDateFormat.parse(dateString));
                            data[i] = donation;

                        }
                    } catch (JSONException e){
                        Log.e("JSON List Error", e.toString());
                        return;
                    } catch (ParseException e){
                        Log.e("JSON List Error", e.toString());
                        return;
                    }

                    Arrays.sort(data);

                    DonationAdapter adapter = new DonationAdapter(DonationListFragment.this.getActivity(), data);
                    DonationListFragment.this.setListAdapter(adapter);

                }
            },

            new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError volleyError) {
                    Context context = getActivity();
                    String message;
                    if (volleyError instanceof NetworkError){
                        message = "Network Error. Please try again later.";
                    } else {
                        try {
                            JSONObject response = new JSONObject(new String(volleyError.networkResponse.data));
                            message = response.toString();
                            Log.e("Volley Error", message);
                        } catch (Exception e) {
                            Log.e("Volley Error", "unknown");
                            message = "Unknown Error";
                        }
                    }
                    Toast toast = Toast.makeText(context, message, Toast.LENGTH_SHORT);
                    toast.show();
                }
            }
        );

        queue.add(request);

    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {

        //TODO: launch detail view for selected item

    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

}

class DonationAdapter extends ArrayAdapter<Donation> {

    private Donation[] data;
    private Context context;
    /** A Simple Date Formatter to make date strings more readable. */
    private SimpleDateFormat sdf;

    public DonationAdapter(Context context, Donation[] data){
        super(context, R.layout.donation_table_row, data);
        sdf = new SimpleDateFormat("EEE, MMM d, ''yy");
        this.data = data;
        this.context = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate(R.layout.donation_table_row, parent, false);
        TextView kind = (TextView) rowView.findViewById(R.id.kind);
        TextView date = (TextView) rowView.findViewById(R.id.date);
        TextView donationStatus = (TextView) rowView.findViewById(R.id.status);
        Donation d = data[position];
        kind.setText(d.getKind());
        MainActivity activity = (MainActivity) this.getContext();
        Typeface tf = activity.myTypeface;
        kind.setTypeface(tf);
        date.setText(sdf.format(d.getdateCreated()));
        date.setTypeface(tf);
        String status = d.getStatus();
        donationStatus.setText(status);
        donationStatus.setTypeface(tf);

        if (status.equals("complete")) {
            donationStatus.setTextColor(context.getResources().getColor(R.color.complete));
        } else if (status.equals("canceled")) {
            donationStatus.setTextColor(context.getResources().getColor(R.color.canceled));
        } else if (status.equals("moving")) {
            donationStatus.setTextColor(context.getResources().getColor(R.color.moving));
        } else if (status.equals("available")) {
            donationStatus.setTextColor(context.getResources().getColor(R.color.available));
        } else if (status.equals("claimed")) {
            donationStatus.setTextColor(context.getResources().getColor(R.color.claimed));
        } else {
            donationStatus.setTextColor(context.getResources().getColor(R.color.unknown));
        }

        return rowView;
    }



}
