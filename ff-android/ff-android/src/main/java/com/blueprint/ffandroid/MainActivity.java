package com.blueprint.ffandroid;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;

public class MainActivity extends ActionBarActivity
        implements NavigationDrawerFragment.NavigationDrawerCallbacks {

    /**
     * Fragment managing the behaviors, interactions and presentation of the navigation drawer.
     */
    private NavigationDrawerFragment mNavigationDrawerFragment;

    /**
     * Used to store the last screen title. For use in {@link #restoreActionBar()}.
     */
    private CharSequence mTitle;
    /** The donation object that is created and updated. */
    public Donation donation;
    /**Fragment declarations**/
    LocationFragment locationFragment;
    AccountFragment accountFragment;
    FormFragment formFragment;
    Fragment currentFragment;
    CongratulatoryFragment congratulatoryFragment;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initializeFragments();
        setContentView(R.layout.activity_donate);

        mNavigationDrawerFragment = (NavigationDrawerFragment)
                getSupportFragmentManager().findFragmentById(R.id.navigation_drawer);
        mTitle = getTitle();
        mTitle = getTitle();

        // Set up the drawer.
        mNavigationDrawerFragment.setUp(
                R.id.navigation_drawer,
                (DrawerLayout) findViewById(R.id.drawer_layout));
        donation = new Donation();
    }

    private void initializeFragments(){
        locationFragment = LocationFragment.newInstance();
        accountFragment = AccountFragment.newInstance();
        formFragment = FormFragment.newInstance();
        congratulatoryFragment = CongratulatoryFragment.newInstance();
        currentFragment = locationFragment;
    }

    @Override
    public void onNavigationDrawerItemSelected(int position) {
        // update the main content by replacing fragments

        switch (position) {
            case 0:
                replaceFragment(locationFragment);
                break;
            case 2:
                replaceFragment(accountFragment);
                break;
            case 4:
                SharedPreferences prefs = getSharedPreferences(LoginActivity.PREFS, 0);
                SharedPreferences.Editor editor = prefs.edit();
                editor.clear();
                editor.commit();
                Intent intent = new Intent(this, LoginActivity.class);
                this.finish();
                startActivity(intent);
                break;
            case 6:
                replaceFragment(congratulatoryFragment);
                break;
        }
    }

    public void replaceFragment(Fragment newFragment){
        FragmentManager fragmentManager = getSupportFragmentManager();
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        if(!newFragment.isAdded()){
            ft.add(R.id.container, newFragment);
        }
        ft.hide(currentFragment);
        ft.show(newFragment);
        ft.commit();
        currentFragment = newFragment;
    }

    public void onSectionAttached(int number) {
        switch (number) {
            case 1:
                mTitle = getString(R.string.donation_start_title);
                break;
        }
    }

    public void restoreActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD);
        actionBar.setDisplayShowTitleEnabled(true);
        actionBar.setTitle(mTitle);
    }

}
