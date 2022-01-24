# blood-flow-bmi
Analysis for paper showing the inverse age trajectories of total cerebral blood flow and BMI in childhood

This is the code I used in a paper (in press) showing that total cerebral blood flow (TCBF), an indirect proxy for the total amount of energy the brain is using, 
varies inversely with body fat (measured using the BMI) across childhood. Specifically, as kids' brains require increasing amounts of energy, peaking around the age of 5 years, they are also losing body fat. As the brain's energy needs gradually decline following the peak around 5, body fat increases, suggesting a relationship between the two.  

These age trajectories were non-linear and required me to use regression splines and generalized additive models (GAM) with the mgcv package. 
