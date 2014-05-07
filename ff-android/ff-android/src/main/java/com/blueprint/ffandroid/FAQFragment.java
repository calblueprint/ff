package com.blueprint.ffandroid;

import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;


public class FAQFragment extends Fragment implements FragmentLifeCycle {

    /** The button that links to the feeding forward. */
    Button link;
    /** The About Feeding Forward Header. */
    TextView faqHeader;
    /** The short description of Feeding Forward. */
    TextView faqDescription;
    /** The header for The Blueprint Link. */
    TextView bpHeader;

    private boolean created = false;

    public static FAQFragment newInstance() {
        FAQFragment fragment = new FAQFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_faq, container, false);

        created = true;

        link = (Button) rootView.findViewById(R.id.ff_link);
        link.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {

                Intent browserIntent =
                        new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.calblueprint.org"));
                startActivity(browserIntent);

            }

        });
        ImageButton blueprintLink = (ImageButton) rootView.findViewById(R.id.cal_blueprint_button);
        blueprintLink.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {

                Intent browserIntent =
                        new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.calblueprint.org"));
                startActivity(browserIntent);

            }

        });
        bpHeader = (TextView) rootView.findViewById(R.id.created_by_cal_blueprint);
        faqHeader = (TextView) rootView.findViewById(R.id.about_feeding_forward);
        faqDescription = (TextView) rootView.findViewById(R.id.about_description);
        setFonts();
        return rootView;
    }

    /**
     * Sets the fonts of the Buttons and TextViews in this fragment
     */
    private void setFonts(){
        MainActivity parent = (MainActivity)this.getActivity();
        Typeface tf = parent.myTypeface;
        faqHeader.setTypeface(tf);
        faqDescription.setTypeface(tf);
        link.setTypeface(tf);
        bpHeader.setTypeface(tf);

    }

    @Override
    public void willAppear() {
        return;
    }

    @Override
    public boolean isCreated() {
        return created;
    }
}