FF-iPhone-App-New
=================

FF iPhone App Rewrite

ChangeLog:

Version 2.0

1)  Visual changes on screens Post Donation, Login, and Registration step-1/step-2

2)  My Donations is now split into two tabs: Current Donations and Past Donations

        - Current Donations show a list of donations whose pickup day is >= today.
        - Past Donations show a more detailed list of donations whose pickup day is < today
        
3)  Batch Load donations data

        - Instead of loading all donations at once, it now loads them in batches. This is done by incorporating Infinite-Scrolling on table views.

4)  Switched to use UIWebView to perform Facebook Login instead of launching Safari.
