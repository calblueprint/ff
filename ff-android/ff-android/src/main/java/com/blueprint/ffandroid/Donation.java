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


}
