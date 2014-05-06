package com.blueprint.ffandroid;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
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

import uk.co.senab.actionbarpulltorefresh.library.DefaultHeaderTransformer;
import uk.co.senab.actionbarpulltorefresh.library.HeaderTransformer;
import uk.co.senab.actionbarpulltorefresh.library.PullToRefreshLayout;
import uk.co.senab.actionbarpulltorefresh.library.ActionBarPullToRefresh;
import uk.co.senab.actionbarpulltorefresh.library.listeners.OnRefreshListener;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Locale;

/**
 * Created by Nishant on 4/12/14.
 */
public class DonationListFragment extends Fragment {

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
    public View onCreateView (LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        final Context contextThemeWrapper = new ContextThemeWrapper(getActivity(), R.style.Theme_DonationList);

        // clone the inflater using the ContextThemeWrapper
        LayoutInflater localInflater = (LayoutInflater) contextThemeWrapper.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        // inflate the layout using the cloned inflater, not default inflater
        return localInflater.inflate(R.layout.donation_listview, container, false);

    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState){
        super.onActivityCreated(savedInstanceState);
        final PullToRefreshLayout pullToRefreshView = (PullToRefreshLayout) getView().findViewById(R.id.ptr_layout);
        final ListView listView = (ListView) getView().findViewById(R.id.donation_list);

        //Set onclicklistener for the list view
        listView.setOnItemClickListener(new ListView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
                Donation d = (Donation) parent.getItemAtPosition(position);
                ((MainActivity) DonationListFragment.this.getActivity()).updateDetailView(d);

            }
        });


        getData(listView, pullToRefreshView);


        ActionBarPullToRefresh.from(getActivity())
                              .allChildrenArePullable()
                              .listener(new OnRefreshListener() {
                                     @Override
                                     public void onRefreshStarted(View view) {

                                        final ListView donationList = (ListView) view.findViewById(R.id.donation_list);
                                        getData(donationList, pullToRefreshView);

                                     }
                              })
                              .setup(pullToRefreshView);


    }


    private void getData(final ListView listView, final PullToRefreshLayout pullToRefreshLayout) {

        SharedPreferences prefs = getActivity().getSharedPreferences(LoginActivity.PREFS, 0);
        final String token = prefs.getString("token", "None");
        final RequestQueue queue = Volley.newRequestQueue(getActivity());

        JsonArrayRequest request = new JsonArrayRequest(getString(R.string.pickup_list_url) + token,
                new Response.Listener<JSONArray>() {
                    @Override
                    public void onResponse(JSONArray jsonArray) {
                        Donation[] data = new Donation[jsonArray.length()];

                        try {
                            for (int i = 0; i < jsonArray.length(); i++) {
                                JSONObject jsonObject = jsonArray.getJSONObject(i);
                                Donation donation = new Donation();
                                donation.setAddress(jsonObject.getJSONObject("location").getString("text"));
                                donation.setKind(jsonObject.getString("kind"));
                                donation.setStatus(jsonObject.getString("status"));
                                String dateString = jsonObject.getString("createdAt");
                                donation.setDateCreated(inputDateFormat.parse(dateString));
                                data[i] = donation;

                            }
                        } catch (JSONException e) {
                            Log.e("JSON List Error", e.toString());
                            return;
                        } catch (ParseException e) {
                            Log.e("JSON List Error", e.toString());
                            return;
                        }

                        Arrays.sort(data);

                        DonationAdapter adapter = new DonationAdapter(DonationListFragment.this.getActivity(), data);
                        listView.setAdapter(adapter);

                        if (pullToRefreshLayout.isRefreshing()) {
                            pullToRefreshLayout.setRefreshComplete();
                        }
                    }
                },

                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        Context context = getActivity();
                        String message;
                        if (volleyError instanceof NetworkError) {
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

                        if (pullToRefreshLayout.isRefreshing()) {
                            pullToRefreshLayout.setRefreshComplete();
                        }
                    }
                }
        );

        queue.add(request);
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
        MainActivity activity = new MainActivity();
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
