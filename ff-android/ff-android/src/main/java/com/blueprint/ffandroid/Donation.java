package com.blueprint.ffandroid;

import android.graphics.Picture;
import android.location.Location;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Date;
/**
 * An object to represent a donation in the Feeding Forward application.
 */
public class Donation {

    /** The title of the donation. */
    private String _title;
    /** A description of the donation. */
    private String _description;
    /** A picture associated with the donation. */
    private Picture _picture;
    /** A location associated with the donation. */
    private Location _location;
    /** A human-readable representation of the location */
    private String _address;
    /** The weight of the donation */
    private double _weight;
    /** The type of vehicle that the donation asks for. */
    private String _vehicle;
    /** The start date of the donation. */
    private Date _startDate;
    /** The end date of the donation. */
    private Date _endDate;

    /** Returns a donation by taking in a TITLE, DESCRIPTION, a PICTURE, a
     *  LOCATION, the WEIGHT, a type of VEHICLE, and a START date and END
     *  date of a donation.
     */
    public Donation(String title, String description, Picture picture,
                    Location location, String address, double weight, String vehicle,
                    Date start, Date end) {
        _title = title;
        _description = description;
        _picture = picture;
        _location = location;
        _address = address;
        _weight = weight;
        _vehicle = vehicle;
        _startDate = start;
        _endDate = end;
    }

    /** Returns an empty donation.
     */
    public Donation() {
        _title = "";
        _description = "";
        _picture = new Picture();
        _location = null;
        _address = "";
        _weight = 0.0;
        _vehicle = "";
        _startDate = new Date();
        _endDate = new Date();
    }

    /** Returns the title of the donation.*/
    public String getTitle(){
        return _title;
    }

    /** Returns the description of the donation. */
    public String getDescription(){
        return _description;
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

    /** Sets the TITLE. */
    public void setTitle(String title){
        _title = title;
    }

    /** Sets the DESCRIPTION. */
    public void setDescription(String description){
        _description = description;
    }

    /** Sets the PICTURE. */
    public void setPicture(Picture picture){
        _picture = picture;
    }

    /** Sets the LOCATION. */
    public void setLocation(Location location){
        _location = location;
    }

    /** Sets the ADDRESS */
    public void setAddress(String address) { _address = address; }

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

    /** Returns a String that is in JSON format. */
    public String toJSON() {
        try {
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("title", getTitle());
            jsonObj.put("description", getDescription());
            jsonObj.put("location", getLocation().toString());
            jsonObj.put("weight", Double.toString(getWeight()));
            jsonObj.put("vehicle", getVehicle());
            jsonObj.put("start", getStartDate().toString());
            jsonObj.put("end", getEndDate().toString());
            return jsonObj.toString();
        }
        catch(JSONException e) {
            e.printStackTrace();
        }
        return null;

    }
}
