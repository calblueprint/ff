package com.blueprint.ffandroid;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.app.Activity;
import android.app.ActionBar;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.content.SharedPreferences;

import android.util.Log;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkError;
import com.android.volley.NoConnectionError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.android.volley.Request;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;


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


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void attemptLogin(View view){

        final Intent intent = new Intent(this, MainActivity.class);

        EditText email = (EditText) findViewById(R.id.username);
        EditText pass = (EditText) findViewById(R.id.pass);


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
                            editor.putString("email", emailString);
                            editor.putString("password", passString);
                            editor.putString("token", token);
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
                        Log.d("Volley Error", new String(volleyError.networkResponse.data));
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
                }
        });


        queue.add(request);

    }



}