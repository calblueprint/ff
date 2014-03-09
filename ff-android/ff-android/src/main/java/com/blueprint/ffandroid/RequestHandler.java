package com.blueprint.ffandroid;

import android.content.Context;
import android.util.Log;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.android.volley.Request;

import org.json.JSONArray;
import org.json.JSONObject;


public class RequestHandler {

    private RequestQueue queue;
    private Context context;

    public RequestHandler(Context context){
        this.context = context;
        this.queue = Volley.newRequestQueue(this.context);
    }


    public JSONArray arrayRequest(String url) {

        final JSONArray response[] = new JSONArray[1];

        JsonArrayRequest request = new JsonArrayRequest(url,

            new Response.Listener<JSONArray>() {
                @Override
                public void onResponse(JSONArray jsonArray) {
                    Log.d("Queue", "Response received");
                    response[0] = jsonArray;
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError volleyError) {
                   Log.d("Volley Error", volleyError.getMessage());
                }
            }
        );

        queue.add(request);

        return response[0];
    }


    public JSONObject objectRequest(int method, String url, JSONObject params) {

        final JSONObject response[] = new JSONObject[1];

        JsonObjectRequest request = new JsonObjectRequest(method, url, params,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        Log.d("Queue", "Response received");
                        response[0] = jsonObject;
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        Log.d("Volley Error", volleyError.getMessage());
                    }
                }
        );

        queue.add(request);

        return response[0];
    }

}


