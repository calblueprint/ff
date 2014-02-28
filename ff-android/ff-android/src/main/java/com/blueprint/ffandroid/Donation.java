package com.blueprint.ffandroid;

import android.graphics.Picture;
import android.location.Location;
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
                    Location location, double weight, String vehicle,
                    Date start, Date end) {
        _title = title;
        _description = description;
        _picture = picture;
        _location = location;
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
}
