# blood-flow-bmi
Analysis for paper showing the inverse age trajectories of total cerebral blood flow and BMI in childhood

This is the code I used in a paper (in prep) showing that total cerebral blood flow (TCBF), an indirect proxy for the total amount of energy the brain is using, 
varies inversely with body fat (measured using the BMI) across childhood. Specifically, as kids' brains require more and more energy (peaking around the age of
5 years) they are also progressively losing body fat. Following this peak brain energy requirement around age 5, the brain starts requiriing less and less energy, 
and kids start progressively gaining body fat. 

These age trajectories were non-linear and required me to use regression splines and generalized additive models (GAM) with the mgcv package. 
