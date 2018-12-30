Libname Yelp 'C:\Users\pvaradarajan\Documents\Business reporting tools\BusinessReportingTools-master\Individual_assignment';

*/Evolution of reviews over time with business*/;
proc sql;
create table Yelp.Evolution_Yelp as
select A.business_id,name,review_count,A.stars,year(date) as Year_Review
from Yelp.Yelp_Business A,Yelp.Yelp_Review2 B
where A.Business_id = B.Business_id;
quit;

*/Some comparisons with photos along companies*/;
proc sql;
create table Yelp.Photodetails as
select A.Business_id,photo_id,categories,label
from Yelp.Yelp_Business A,Yelp.Yelp_Photo B
where A.Business_id = B.Business_id;
quit;

*/Analysis on the review scores across categories*/;
proc sql;
create table Yelp.reviewscore as
select Business_id,name,Categories, Case when stars = 5 then 'Verygood'
				    when stars = 1 then 'Worst'
				    when stars = 4 then 'good'
				    when stars = 0 then 'Noreviews'
				    else 'Average'
				    END as Reviewscore
from Yelp.Yelp_Business;
quit;

*/Analysing the relationship between reviews and tips*/;
proc sql;
create table Yelp.tip_review as
select A.Business_id,name,categories,count(text) as nooftips,stars
from Yelp.Yelp_Business A , Yelp.Yelp_Tip B
where A.Business_id = B.Business_id
group by 1,2;
quit;

*/Relationship between users, business and reviews*/;
proc sql;
create table Yelp.userdetails as
select B.User_id,B.Business_id,C.name,A.name as Username,A.review_count,Average_stars,Yelping_Since,
	int(((('01Dec2018'D) - Yelping_since)/365)) as Recency_user
from Yelp.Yelp_Review2 B,Yelp.Yelp_User2 A,Yelp.Yelp_Business C
where A.User_id = B.User_id
AND B.business_id = C.business_id;
quit;

*/Exporting the checkin data to CSV*/;
proc export data = Yelp.Yelp_Checkin 
outfile = 'C:\Users\pvaradarajan\Documents\Business reporting tools\checkin.CSV'
 DBMS = csv;
run;

*/Manipulating 	the checkin table for some useful insights after importing the transposed data from Tableu*/;
Proc sql;
Update YELP.CHECKIN
Set Checkin='0'
Where Checkin contains 'NA';
quit;
Proc sql;
Create table Yelp.checkin_yelp as
Select Business_Id,case when Dayofweek="Sat" | Dayofweek="Sun" then "Weekend"
else "Weekday" end as Weekcategory,
case when Time >= 5 and  Time <= 11 then 'Morning' 
 when Time >= 12 and  Time <= 16 then 'Noon'
 when Time >= 17 and  Time <= 21 then 'Evening'
 else 'Night' end as Timeofday
as Timeofday,DayofWeek, Checkin
from Yelp.Checkin ;
quit;

