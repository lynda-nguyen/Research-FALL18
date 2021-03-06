# R 
# 09/18/2018
# data source: https://arxiv.org/pdf/1702.07234.pdf

## Parameters used throughout the paper
# ball minimum circumference = 29.5 in (74.9 cm)
# ball minimum weight = 20 oz (567 g)
# d = distance from free throw line to basket = 4.6m
# H = basket rim to floor height = 3.05 m
# R = radius of basket rim = 0.23 m 
# r = radius of basketball = 0.12 m

#making the data table
free.throw.df <- data.frame("d" = c(4.55,4.59,4.22,4.61,4.76,4.24,4.53,
                                    4.12,4.57,4.57,4.55,4.30,4.61,4.20,
                                    4.59,4.55,4.86,4.86,4.34,4.30,4.61,
                                    4.59,4.40,4.22,4.63),
                            "h_max" = c(4.04,4.12,4.08,4.06,4.08,4.10,
                                        4.10,3.83,4.16,4.14,4.02,3.98,
                                        4.12,3.94,4.08,4.08,4.18,4.10,
                                        4.02,3.85,4.00,4.06,3.85,3.89,4.10),
                            "t" = c(0.94,0.91,0.92,0.93,0.92,0.92,0.92,
                                    1.02,0.90,0.91,0.94,0.96,0.91,0.97,
                                    0.92,0.92,0.89,0.92,0.94,1.01,0.95,
                                    0.93,1.01,0.99,0.92),
                            "v_x" = c(4.26,4.18,3.90,4.29,4.40,3.89,4.16,
                                      4.19,4.11,4.14,4.29,4.11,4.20,4.08,
                                      4.24,4.20,4.35,4.46,4.09,4.33,4.38,
                                      4.27,4.43,4.19,4.25),
                            "v_y"= c(6.25,6.37,6.31,6.28,6.31,
                                     6.34,6.34,5.91,6.43,6.40,6.22,6.16,
                                     6.37,6.10,6.31,6.31,6.46,6.34,6.22,
                                     5.94,6.19,6.28,5.94,6.00,6.34),
                            "v" = c(7.49,7.61,7.38,7.54,7.65,7.41,7.55,
                                    6.99,7.65,7.62,7.46,7.29,7.62,7.19,
                                    7.56,7.54,7.82,7.72,7.36,7.10,7.47,
                                    7.53,7.15,7.12,7.60),
                            "theta"=c(55.71,56.69,58.29,55.68,55.10,58.46,
                                      56.74,54.65,57.38,57.09,55.40,56.28,
                                      56.58,56.24,56.10,56.32,56.04,54.86,
                                      56.68,53.89,54.74,55.79,53.28,55.10,56.18),
                            "score"=c(1,1,0,1,0,0,1,0,1,1,1,0,1,0,1,1,0,0,0,0,
                                      1,1,0,0,1))

free.throw.df

#plot of 25 observed free throws by student (without theoretical lines)
plot(free.throw.df$theta, free.throw.df$v, col = free.throw.df$score+1, main = "Free Throws by Student", ylab = "Release Velocity (m/s)",
     xlab = "Release Angle (theta)")
legend("topleft", legend = c("0", "1"), col=c("black", "red"), fill = 1:2)

#################################################################################
#Angle-velocity smile

d = 4.6
R = 0.23
H = 3.05
r = 0.12
h = 2

velocity <-(seq(7,11,0.1))
theta <- (seq(30,70,1))
N = length(velocity) # same as length(theta)

#(x − (d − R))^2 + (y − H)^2 > r^2
x <- numeric(N^2) #initialize x vector
y <- numeric(N^2) #initialize y vector
t <- numeric(N^2) #initialize time vector
k <-1   # counter variable for for loops

#when using cosine, must convert from radians to degrees, use pi/180
for (i in 1:N){
  for (j in 1:N){
    #time = (d-(R/2)/velocity*cos(theta))
    t[k] = (d-(R/2))/(velocity[i]*cos(theta[j]*(pi/180)))
    x[k] <- velocity[i]*t[k]*cos(theta[j]*(pi/180))
    y[k] <- h + velocity[i]*sin(theta[j]*(pi/180))*t[k] - 0.5*(9.8)*t[k]*t[k]
    k = k+1
  }
}

# (x − (d − R))^2 = a
# (y − H)^2 = b
a <- numeric(N^2) #initialize a component
b <- numeric(N^2) #initialize b component
for (i in 1:N^2){
  a[i] = x[i]- d + R
  b[i] = y[i]- H
}

# c adds a and b to compare to r^2
c = a^2 + b^2

# score is a categorical value that indicates if the shot will be made 
score <- numeric(N^2)

for(i in 1:N^2){
  if (c[i] < r^2){
    score[i] = 1
  }
}

# determines which values are less than r^2
values <- which(score == 1)

#converts the values to get the theta and velocity values
x.theta <- numeric(length(values))      #initialize x (theta) column
y.velocities <- numeric(length(values)) #initialize y (velocity) column

# values[i] <- score comes from c value, which derives from x[i] and y[i]
# for loop increments by i, j, and k
  # k increments by one, for every 41 j's, i increments by 1
    # k == values, j == theta
      # values[i] - (as.integer(values[1]/41))*41 == theta sequence value
        #ie 223 - 5(223) = 18 = theta[18] == 47 degrees

      #velocity == i
        # if (as.integer(values[i]/41) is greater than 0, then +1 is added b/c of 41 remainder
          # ie 223/41 = 5 + 1 == 6
              # ie velocity[6] == 7.5
for(i in 1:length(values)){
  # EQ.8 says theta min is 39.8, thus we can ignore values less than that
  if ((theta[values[i] - (as.integer(values[i]/41))*41]) > 39.8){
    x.theta[i] <- theta[values[i] - (as.integer(values[i]/41))*41]
    if (values[i]/41 > as.integer(values[i]/41)){
      y.velocities[i] <- velocity[as.integer(values[i]/41) + 1]
    }
    else{
      y.velocities[i] <- velocity[as.integer(values[i]/41)]
    }
  }
}

# displays data in a data frame && cleans the zero values out
angle.vs.vel.df <- rbind(x.theta[x.theta != 0], y.velocities[y.velocities != 0])
transpose.df <- t(angle.vs.vel.df)

#plots the data 
plot(x.theta[x.theta != 0], y.velocities[y.velocities != 0], ylab = "v, m/s",
     xlab = "theta", main = "Angle-Velocity 'Smile'")
