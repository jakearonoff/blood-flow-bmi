# blood-flow-bmi
Analysis for paper showing the inverse age trajectories of total cerebral blood flow and BMI in childhood

This is the code I used in a paper showing that total cerebral blood flow (TCBF), an indirect proxy for the total amount of energy the brain is using, 
varies inversely with body fat (measured using the BMI) across childhood. Specifically, as kids' brains require increasing amounts of energy, peaking around the age of 5 years, they are also losing body fat. As the brain's energy needs gradually decline following the peak around 5, body fat increases, suggesting a relationship between the two.  

These age trajectories were non-linear and required me to use regression splines and generalized additive models (GAM) with the mgcv package. 

Aronoff, J. E., Ragin, A., Wu, C., Markl, M. Schnell, S., Shaibani, A., Blair, C., & Kuzawa, C. W. (2022). Why do humans undergo an adiposity rebound? Exploring links with the energetic costs of brain development in childhood using MRI-based 4D measures of total cerebral blood flow. International Journal of Obesity. 
