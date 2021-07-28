library("tidyverse")
library("mgcv")

###### loading data
BF <- read.csv("filepath.csv", header = T, check.names = F, sep = ",")

########################
## Figures
########################

# set up unitless comparison
BF$bmiz <- scale(BF$BMI)
BF$bfz <- scale(BF$TCBF)

# generate splines 
bmiage <- gam(bmiz ~ s(Age, bs="cr", k = 6), data=BF)
bfage <- gam(bfz ~ s(Age, bs="cr", k = 6), data=BF)

# Figure 1
plot(BF[,c(6,17)], col="red", ylab="Standardized Values", xlab="Age",
     xlim=c(0,61), ylim=c(-1.6,3))
points(BF[,c(6,16)], col="blue")
BF$bfpred <- bfage$fitted.values
lines(BF[,c(6,18)], col="red")
BF$bmipred <- bmiage$fitted.values
lines(BF[,c(6,19)], col="blue")
legend(50,3.17,legend=c("TCBF","BMI"), col=c("red","blue"),
       lty=c(1,1), ncol=1)

# Figure 2
variables <- c("Volunteer", "Age")
x <- seq(1,60,by = 0.1)
y <- seq(1,60,by = 0.1)
newdata <- as.data.frame(cbind(x, y))
colnames(newdata) <- variables
newdata$predbf <- predict.gam(bfage, newdata)
newdata$predbmi <- predict.gam(bmiage, newdata)
plot(newdata$predbf,newdata$predbmi, col = "red", ylim = c(-1.8,1.8), xlim = c(-1.8,1.8),
     ylab = "Predicted mean BMI (standardized values)", xlab = "Predicted mean TCBF (standardized values)")
# adding age labels to figure 2 
text(x=c(-0.158043167,0.500159445,1.067920759,1.482434317
), y=c(-0.715638300,-0.868285644,-0.989533883,-1.057578080), labels = c("1","2","3","4"), pos = 1)
text(x= 1.681594820, y= -1.050866434, labels = "5", pos = 4)
text(x=c(1.649706176,1.445619538,1.134914158,0.783169286,0.455875598,0.197117117,0.001856006
), y=c(-0.964601801,-0.820900099,-0.644306223,-0.459365070,-0.290586503,-0.154014081,-0.046263721
), labels = c("6","7","8","9","10","11","12"), pos = 3)
text(x=c(-0.321947994, -0.560103077, -0.6890860, -0.7761920, -0.9333620,
         -1.2145771
), y=c(0.165037520, 0.430190284, 0.6747033, 0.8663153, 1.0639580,
       1.009917
), labels = c("15","20","25","30","40", "60"), pos = 3)
abline(a = 0, b = -1, col = "grey", lty = 2)



###################
## Modeling 
##################

# focus analysis on kids 
BF_fil <- filter(BF, Age<13)

# setting up table 2
## generate data for making model predictions 
variables <- c("Volunteer", "Age")
x <- seq(1,12,by = 0.1)
y <- seq(1,12,by = 0.1)
newdata <- as.data.frame(cbind(x, y))
colnames(newdata) <- variables

## modeling the spline 
bfage <- gam(TCBF ~ s(Age, bs="cr", k = 5), data=BF_fil)

## generate predictions for each age 
pbf <- predict.gam(bfage, newdata, se.fit = T)
max(pbf$fit) # 24.10598 is the max predicted mean TCBF 
newdata$predbf <- pbf$fit # max predicted mean TCBF is at age 5.6 years
newdata$predbfse <- pbf$se.fit # SE for predicted mean TCBF at age 5.6 years is 0.6886639

## storing peak TCBF with 95% CI
peakcbf <- 24.10598
upci <- 24.10598 + (2*0.6886639)
lowci <- 24.10598 - (2*0.6886639)

## From Settergren et al (1980):
##    BF measured in perfusion = 0.65 ml/g/min 
##    Glucose utilization = 248 nmol glucose/g/min
##    248/1,000,000,000 converts nmol to mol, then multiply by 180.16 to get grams (= 4.467968e-05)
##    4.467968e-05 grams glucose per 0.65 ml/g/min CBF:    
##                     4.467968e-05/0.65 = 6.873797e-05 grams glucose per ml blood
##    In our data tcbf is measured in ml/sec, so need to multiply by 60 to get per minute
##        then multiply by 6.873797e-05 to get grams glucose per ml blood per minute
##         finally multiply by 1440 to get grams glucose per ml blood per day
## function to convert TCBF to CMRglu estimate using information above 
tcbf_to_cmrglu <- function(x) {
  x*60*6.873797e-05*1440
}

## converting peak TCBF with 95% CI's to estimates of CMRglu
tcbf_to_cmrglu(peakcbf) # 143.1645 g/day
tcbf_to_cmrglu(upci) # 151.3444 g/day
tcbf_to_cmrglu(lowci) # 134.9846 g/day

## Values from Kuzawa et al. 2014 data for reference:
## peak CMRglu at age 5.2, 167 g/day in males, 146 g/day in females 
## Our CMRglu estimates are very close to Kuzawa et al. 2014 values, which were direct measures

## spline modeling for the AR
bmiage <- gam(BMI ~ s(Age, bs="cr", k = 3), data=BF_fil)

## getting predicted mean for AR
pbmi <- predict.gam(bmiage, newdata, se.fit = T)
min(pbmi$fit) # 16.55816 is the lowest predicted mean BMI 
newdata$pbmi <- pbmi$fit # which occurs at age 4.9 years (we considered this BMI nadir the AR age)
newdata$pbmise <- pbmi$se.fit # SE for the predicted mean BMI at age 4.9 years is 0.7116774

## storing predicted mean BMI at rebound with 95% CI 
AR <- 16.55816
AR_upci <- 16.55816 + (2*0.7116774)
AR_lowci <- 16.55816 - (2*0.7116774)

# Table 3 model 
summary(gam(bmiz ~ s(Age, bs="cr", k = 3) + female + bfz, data=BF_fil))
