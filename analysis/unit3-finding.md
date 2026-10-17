# Unit 3 Findings

To the dashboard team:

The dashboard reported that about half of all ratings were withdrawn because of spam, leading to a freeze on reviewer payouts. I found
12 spam withdrawals out of 200 ratings, or 6%. My first query left out 166 ratings with no withdrawal reason recorded. Including them increased
the count not marked as spam from 22 to 188. Leaving those ratings out makes the spam withdrawal rate look higher. I also fixed a separate
query that tried to filter by a calculated column name before it was available. Both corrected versions returned the same 12 spam withdrawals.

I recommend correcting the dashboard and reviewing the payout freeze using all 200 ratings. The data does not support the reported failure
rate. Eligible reviewer payouts should be released after review, with spam withdrawals and other issues handled individually.
