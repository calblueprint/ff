package com.blueprint.ffandroid;

import android.app.Activity;
import android.app.ListFragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
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

/**
 * Created by Nishant on 4/12/14.
 */
public class DonationListFragment extends ListFragment{

    private static RequestQueue queue;
    private static String BASE_URL = "http://feeding_forever.herokuapp.com/api/pickups/auth_token=";
    private String token;

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

        JsonArrayRequest request = new JsonArrayRequest(BASE_URL + token,
            new Response.Listener<JSONArray>() {
                @Override
                public void onResponse(JSONArray jsonArray) {
                    Donation data[] = new Donation[jsonArray.length()];
                    try{
                        for (int i=0; i<jsonArray.length(); i++) {
                            JSONObject jsonObject = jsonArray.getJSONObject(i);
                            //TODO: parse JSONArray and make array of Donation objects.
                        }
                    } catch (JSONException e) {
                        Log.e("JSON List Error", e.toString());
                        return;
                    }

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
                            message = (String) response.get("message");
                        } catch (Exception e) {
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

    public DonationAdapter(Context context, Donation[] data){
        super(context, R.layout.donation_table_row, data);
        this.data = data;
        this.context = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //TODO: populate table row with donation information
        return convertView;
    }



}
