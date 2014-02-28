package com.blueprint.ffandroid;

import android.graphics.Picture;
import android.location.Location;
import java.util.Date;
/**
 * An object to represent a donation in the Feeding Forward application.
 */
public class Donation {

    /** The title of the donation. */
    private String title;
    /** A description of the donation. */
    private String description;
    /** A picture associated with the donation. */
    private Picture pic;
    /** A location associated with the donation. */
    private Location loc;
    /** The weight of the donation */
    private double weigt;
    /** The type of vehicle that the donation asks for. */
    private String vehicle;
    /** The start date of the donation. */
    private Date startDate;
    /** The end date of the donation. */
    private Date endDate;


}
