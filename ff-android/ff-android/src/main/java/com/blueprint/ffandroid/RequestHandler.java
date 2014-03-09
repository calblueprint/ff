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
    /**
     * An object to handle API calls at the HTTP request level.
     */
    private RequestQueue queue;
    private Context context;

    /** Returns a RequestHandler by assigning CONTEXT, an applicaiton
     *  context set by the caller, to a RequestQueue object, which
     *  handles background threading of HTTP requests.
     */
    public RequestHandler(Context context){
        this.context = context;
        this.queue = Volley.newRequestQueue(this.context);
    }


    /** Returns a JSONArray object by taking in a URL.
     *  The Volley API only allows GET requests to return
     *  a JSON array, so no Method argument is necessary.
     *  Similarly, the API does not accept parameters for a
     *  JsonArrayRequest object.
     */
    public JSONArray arrayRequest(String url) {

        /**
        * TODO: Consider overwriting volley source to allow other
        * types of http requests.
        */

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


    /** Returns a JSONObject of the response at the given
     *  URL with the given PARAMS and specified METHOD.
     *  PARAMS is a JSONObject containing the POST or PUT data.
     */
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


