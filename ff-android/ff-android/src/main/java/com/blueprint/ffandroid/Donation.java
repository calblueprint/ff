package com.blueprint.ffandroid;

import android.graphics.Picture;
import android.location.Location;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Array;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * An object to represent a donation in the Feeding Forward application.
 */
public class Donation {

    /** The kind of  donation. */
    private String _kind;
    /** A picture associated with the donation. */
    private Picture _picture;
    /** A location associated with the donation. */
    private Location _location;
    /** A human-readable representation of the location */
    private String _address;
    /** The state tbe donation was made in. */
    private String _state;
    /** The city the donation was made in. */
    private String _city;
    /** The full address the donation was made in. */
    private String _fullAddress;
    /** The weight of the donation */
    private double _weight;
    /** The type of vehicle that the donation asks for. */
    private String _vehicle;
    /** The start date of the donation. */
    private Date _startDate;
    /** The end date of the donation. */
    private Date _endDate;
    /** The phone number of the user who created the donation. */
    private String _phoneNumber;

    /** Returns a donation by taking in a TITLE, DESCRIPTION, a PICTURE, a
     *  LOCATION, the WEIGHT, a type of VEHICLE, and a START date and END
     *  date of a donation.
     */
    public Donation(String kind, Picture picture,
                    Location location, String address, double weight, String vehicle,
                    Date start, Date end, String phoneNumber, String city, String state) {
        _kind = kind;
        _picture = picture;
        _location = location;
        _address = address;
        _weight = weight;
        _vehicle = vehicle;
        _startDate = start;
        _endDate = end;
        _phoneNumber = phoneNumber;
        _city = city;
        _state = state;
    }

    /** Returns an empty donation.
     */
    public Donation() {
        _kind = "";
        _picture = new Picture();
        _location = null;
        _address = "";
        _weight = 0.0;
        _vehicle = "";
        _startDate = new Date();
        _endDate = new Date();
        _phoneNumber = "";
    }

    /** Returns the description of the donation. */
    public String getKind(){
        return _kind;
    }

    /** Returns the picture of the donation. */
    public Picture getPicture(){
        return _picture;
    }

    /** Returns the location of the donation. */
    public Location getLocation(){
        return _location;
    }

    /** Returns the address of the donation. */
    public String getAddress() { return _address; }

    /** Returns the address including the state, city, and country. */
    public String getFullAddress() { return _fullAddress; }

    /** Returns the weight of the donation. */
    public double getWeight() {
        return _weight;
    }

    /** Returns the vehicle of the donation. */
    public String getVehicle() {
        return _vehicle;
    }

    /** Returns the start date. */
    public Date getStartDate() {
        return _startDate;
    }

    /** Returns the vehicle of the donation. */
    public Date getEndDate() {
        return _endDate;
    }

    /** Returns the phone of the user who created the donation. */
    public String getPhoneNumber() { return _phoneNumber; }

    /** Returns the city the donation was made in. */
    public String getCity() { return _city; }

    /** Returns the state the donation was made in. */
    public String getState() { return _state; }

    private String getStartTime() {
        DateFormat df = new SimpleDateFormat("MMMM/dd/yyyy hh:mm aaa");
        return df.format(_startDate);
    }

    /** Sets the DESCRIPTION. */
    public void setKind(String kind){
        _kind = kind;
    }

    /** Sets the PICTURE. */
    public void setPicture(Picture picture){
        _picture = picture;
    }

    /** Sets the LOCATION. */
    public void setLocation(Location location){
        _location = location;
    }

    /** Sets the ADDRESS. */
    public void setAddress(String address) { _address = address; }

    /** Sets the FULLADDRESS of the donation. */
    public void setFullAddress(String fullAddress) { _fullAddress = fullAddress; }

    /** Sets the ADDRESS, CITY, and STATE */
    public void setAddress(String address, String city, String state) {
        _address = address;
        _city = city;
        _state = state;
    }

    /** Sets the Weight. */
    public void setWeight(double weight) {
        _weight = weight;
    }

    /** Sets the VEHICLE. */
    public void setVehicle(String vehicle) {
        _vehicle = vehicle;
    }

    /** Sets the START date. */
    public void setStartDate(Date start) {
        _startDate = start;
    }

    /** Sets the END date. */
    public void setEndDate(Date end) {
        _endDate = end;
    }

    /** Sets the PHONENUMBER of the donation. */
    public void setPhoneNumber(String phoneNumber) { _phoneNumber = phoneNumber; }

    private JSONObject getLocationJson() {
        JSONObject locationJson = null;
        try {
            locationJson = new JSONObject();
            locationJson.put("type", "Point");
            JSONArray coordinates = new JSONArray();
            coordinates.put(getLocation().getLatitude());
            coordinates.put(getLocation().getLatitude());
            locationJson.put("coordinates", coordinates);
            locationJson.put("text", getAddress());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return locationJson;
    }
    /** Checks if donation object is valid.
     * A donation is valid iff none of its fields violate a requirement.
     * */
    public boolean isValid() {
        int numErrors = 0;
        for (int i : getErrors()) numErrors += i;
        return numErrors == 0;
    }

    /** Checks if donation object is valid.
     * A donation is valid iff it satisfies all the following requirements:
     * 1. The location is in the United States.
     * 2. The weight is a number between 1 and 500.
     * 3. The start date is later than the current time.
     * 4. The kind field is not empty.
     * */
    public int[] getErrors() {

        int[] errors = new int[4];
        for (int i = 0; i < errors.length; i++) errors[i] = 0;

        // Requirement 1
        String[] address_fields = _address.split(" ");
        String country = address_fields[address_fields.length - 1];
        if (!country.equals("USA")) {
            errors[0] = 1;
        }

        // Requirement 2
        if (_weight < 1 || _weight > 500) {
            errors[1] = 1;
        }

        // Requirement 3
        if (_startDate == null || _startDate.after(new Date())) {
            errors[1] = 1;
        }

        // Requirement 4
        if (_kind.length() == 0) {
            errors[1] = 1;
        }

        return errors;
    }

    /** Returns a String that is in JSON format. */
    public String toJSON() {
        return toJSONObj().toString();
    }

    /** Returns a JSONObject */
    public JSONObject toJSONObj() {
        try {
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("pickupAt", JSONObject.NULL);
            jsonObj.put("finishBy", getEndDate().toString());
            jsonObj.put("weight", Double.toString(getWeight()));
            jsonObj.put("kind", getKind());
            jsonObj.put("location", getLocationJson());
            jsonObj.put("phone", getPhoneNumber());
            jsonObj.put("inputWeight", Double.toString(getWeight()));
            return jsonObj;
        }
        catch(JSONException e) {
            e.printStackTrace();
        }
        return null;
    }
}
