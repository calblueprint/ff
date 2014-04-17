package com.blueprint.ffandroid;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


import com.android.volley.NetworkError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.Request;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.HashSet;
public class LoginActivity extends Activity {

    public static final String PREFS = "LOGIN_PREFS";
    private RequestQueue queue;
    private static final String url = "http://feeding-forever.herokuapp.com/api/session";



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        queue = Volley.newRequestQueue(this);

        SharedPreferences prefs = getSharedPreferences(PREFS, 0);

        if (!prefs.getString("token", "none").equals("none")) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("token", prefs.getString("token", null));
            this.finish();
            startActivity(intent);
        }

    }

    public void attemptLogin(View view){

        final Intent intent = new Intent(this, MainActivity.class);

        EditText email = (EditText) findViewById(R.id.username);
        EditText pass = (EditText) findViewById(R.id.pass);
        final Button loginButton = (Button) findViewById(R.id.login_button);
        loginButton.setEnabled(false);


        final String emailString = email.getText().toString();
        final String passString = pass.getText().toString();

        HashMap<String, String> params = new HashMap<String, String>();
        params.put("email", emailString);
        params.put("password", passString);


        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, url, new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        SharedPreferences prefs = getSharedPreferences(PREFS, 0);
                        SharedPreferences.Editor editor = prefs.edit();

                        try {
                            String token = jsonObject.getString("token");
                            JSONObject location = jsonObject.getJSONObject("location");
                            String locationType = location.getString("type");
                            JSONArray coords = location.getJSONArray("coordinates");
                            String address = location.getString("text");
                            String name = jsonObject.getString("name");
                            String role = jsonObject.getString("role");
                            JSONArray roleTags = jsonObject.getJSONArray("roleTags");


                            editor.putString("email", emailString);
                            editor.putString("password", passString);
                            editor.putString("token", token);
                            editor.putString("name", name);
                            editor.putString("address", address);
                            editor.putLong("latitude", coords.getLong(0));
                            editor.putLong("longitude", coords.getLong(1));
                            editor.putString("locationType", locationType);
                            editor.putString("role", role);
                            HashSet<String> roleTagSet = new HashSet<String>();
                            for (int i = 0; i < roleTags.length(); i++){
                                roleTagSet.add(roleTags.getString(i));
                            }
                            editor.putStringSet("roleTags", roleTagSet);

                            editor.commit();

                            intent.putExtra("token", jsonObject.getString("token"));
                            LoginActivity.this.finish();
                            startActivity(intent);

                        } catch (JSONException err) {
                            Log.d("JSON Exception: ", err.getMessage());
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        Context context = getApplicationContext();
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
                        loginButton.setEnabled(true);
                }
        });


        queue.add(request);

    }



}
