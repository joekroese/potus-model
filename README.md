State and national presidential election forecasting model
================

Code for a dynamic multilevel Bayesian model to predict US presidential
elections. Written in R and Stan.

Improving on Pierre Kremp’s
[implementation](http://www.slate.com/features/pkremp_forecast/report.html)
of Drew Linzer’s dynamic linear model for election forecasting
[(Linzer 2013)](https://votamatic.org/wp-content/uploads/2013/07/Linzer-JASA13.pdf),
we (1) add corrections for partisan non-response, survey mode and survey
population; (2) use informative state-level priors that update
throughout the election year; and (3) specify empirical state-level
correlations from political and demographic variables.

## Predictions

Narrow Biden win in the electoral college.

On average, Republicans will have been underpolled by around 2%. This will lead to Trump taking some states that other models predict he wouldn't: namely Iowa, Georgia, Arizona and North Carolina.

### State wins by party

#### Democrat

Washington, DC
Vermont
Hawaii
Massachusetts
California
Maryland
New York
Washington
Rhode Island
Connecticut
Delaware
New Jersey
Illinois
Oregon
Maine
New Mexico
Colorado
Virginia
New Hampshire
Minnesota
Michigan
Wisconsin
Nevada
Pennsylvania

#### Republican

Wyoming
West Virginia
Oklahoma
Idaho
North Dakota
Arkansas
Kentucky
Alabama
South Dakota
Tennessee
Nebraska
Utah
Louisiana
Indiana
Kansas
Mississippi
Montana
Missouri
South Carolina
Alaska
Texas
Ohio
Iowa
Georgia
Arizona
North Carolina
Florida













