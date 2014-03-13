package com.blueprint.ffandroid;

import android.content.Intent;
import android.content.SharedPreferences;
import android.app.Activity;
import android.app.ActionBar;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.content.SharedPreferences;

import android.util.Log;
import android.widget.EditText;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.android.volley.Request;

import org.json.JSONException;
import org.json.JSONObject;


public class LoginActivity extends Activity {

    public static final String PREFS = "LOGIN_PREFS";
    private RequestQueue queue = Volley.newRequestQueue(this);
    private static final String url = "http://feedingforward.apiary.io/api/session";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        SharedPreferences prefs = getPreferences(0);


//        if (savedInstanceState == null) {
//            getSupportFragmentManager().beginTransaction()
//                    .add(R.id.container, new PlaceholderFragment())
//                    .commit();
//        }

        if (prefs.getString("token", null) != null) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("token", prefs.getString("token", null));
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

        EditText user = (EditText) findViewById(R.id.username);
        EditText pass = (EditText) findViewById(R.id.pass);

        String userString = user.toString();
        String passString = pass.toString();

        final JSONObject params = new JSONObject();

        try {
            params.put("email", userString);
            params.put("pass", passString);
        } catch (JSONException exp) {
            Log.d("JSON Exception: ", exp.getMessage());
            return;
        }


        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, url, params,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        SharedPreferences prefs = getPreferences(0);
                        SharedPreferences.Editor editor = prefs.edit();

                        try {
                            editor.putString("email", params.getString("email"));
                            editor.putString("pass", params.getString("pass"));
                            editor.putString("token", jsonObject.getString("token"));
                            editor.commit();

                            intent.putExtra("token", jsonObject.getString("token"));
                            startActivity(intent);

                        } catch (JSONException exp) {
                            Log.d("JSON Exception: ", exp.getMessage());
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        Log.d("Volley Error", volleyError.getMessage());
                }
        });



    }



}