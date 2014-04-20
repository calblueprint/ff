package com.blueprint.ffandroid;

import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.Button;
import android.view.View;
import android.view.View.OnClickListener;
import android.support.v4.app.Fragment;
import android.widget.TextView;

import org.w3c.dom.Text;


public class FAQFragment extends Fragment {

    /** The button that links to the feeding forward. */
    Button link;
    /** The title of the FAQ Fragment.*/
    TextView faq;
    /** The About Feeding Forward Header. */
    TextView faqHeader;
    /** The short description of Feeding Forward. */
    TextView faqDescription;

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
        Button link = (Button) rootView.findViewById(R.id.ff_link);
        link.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {

                Intent browserIntent =
                        new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.feedingforward.com"));
                startActivity(browserIntent);

            }

        });
        faq = (TextView) rootView.findViewById(R.id.faq);
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
        faq.setTypeface(tf);
        faqHeader.setTypeface(tf);
        faqDescription.setTypeface(tf);

    }
}