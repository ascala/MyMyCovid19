
########################################################################################
## R code for the practical on modelling within host infection dynamics
## The code represents the basic infection model without immune response in the lecture
########################################################################################
library(deSolve)

## ODE system for basic infection model
## DO NOT CHANGE THIS PART
BasicModelODE <- function(t, xinit, parms) {
	Z <- xinit[1] # Non diff
	X <- xinit[2] # suscept
	Y <- xinit[3] # infected
	V <- xinit[4] # virus
	with(as.list(parms),{
	
	dZ <- tau-(mu+delta)*Z
	dX <- delta * Z - beta * X * V - mu*X
	dY <- beta * X * V -alpha * Y
	dV <- kappa*Y - rho * V
 	res<-c(dZ, dX, dY, dV)
 	list(res)
  	})
	}

##########################################################################
## The function BasicInfectionModel simulates the infection process
## We pre-programmed this model with certain baseline parameter values. 
## Run this code in R first
## To run the model with different initial conditions /  parameter values, 
## see instructions at the bottom of this file 
#############################################################################
BasicInfectionModel <- function(x, tau = 1.0, mu = 0.01, beta=0.005, delta = 0.1, alpha = 0.05, rho=5.0, kappa=50.0){
	#Model variables:
	# y(1) = z (non diff. macros)
	# y(2) = x (susceptible macros)
	# y(3) = y (number of infected cells)
	# y(4) = v (virus load)
	# Parameters:
	# alpha = poptosis rate of infected cells
	# beta = infection rate
	# delta = differentiation rate z->x
	# tau,mu = birth and death rate of non-infected macros 
	# kappa = virus replication rate
	# rho = virus decay rate


	# Time span
	tspan <- 500
	
    # set initial conditions
     xinit <- c(z0 = 90, x0 = 10, y0 = 0, v0 = 1) #refers to z0, x0, y0, v0	
	# Set default parameter values    
      parms <- c(tau = 1, mu = 0.01, beta = 0.01, delta = 0.1,  alpha = 0.05, rho = 5, kappa = 20)	
      # if you want to directly plot the solutions for 2 parameter sets, create a new set      
      parms2 <- c(tau = tau, mu = mu, beta = beta, delta = delta,  alpha = alpha,  rho = rho, kappa = kappa)
      # Generate solutions Z(t), X(t), Y(t), V(t) by solving the ODE systems for the above parameter values      
      out  <- as.data.frame(lsoda(xinit, 0:tspan, BasicModelODE, parms))
      # Solns for 2nd param set      
      out2  <- as.data.frame(lsoda(xinit, 0:tspan, BasicModelODE, parms2))
      #Calculate total number of cells N= Z+X+Y	
      out$total <- rowSums(out[,2:4])
      out2$total <- rowSums(out2[,2:4])
	
# Produce plots

	dev.new(width = 10, height = 8)
	layout(matrix(c(1,2),1,2), widths=c(0.5, 0.5))
	xMax <- out$time[which.max(out$v0)] * 10
	par(mar = c(4,4,1,1))
      #Plot 1: Viral load profile
  	plot(out$time, out$v0, type = "l", ylab = "Virus load", xlab = "Time", xlim = c(0, xMax))
      #add plot for 2nd set     
      points(out2$time, out2$v0, type = "l", col = "grey")
      #Plot 2: cell numbers	
      plot(out$time, out$z0, type = "l", ylab = "Cell count", xlab = "Time", col = "blue2", ylim = c(0, max(out$total)), xlim = c(0, xMax))
	points(out$time, out$x0, type = "l", col = "orange")
	points(out$time, out$y0, type = "l", col = "red")
      #add plot for 2nd set     
      points(out2$time, out2$z0, type = "l", col = "blue2",lty=2, lwd=2)
      points(out2$time, out2$x0, type = "l", col = "orange", lty=2, lwd=2)
	points(out2$time, out2$y0, type = "l", col = "red", lty=2, lwd=2)
	
      legend("topright", c("Non differentiated", "Susceptible", "Infected"), lty = rep(1,3), col = c("blue2", "orange", "red"))

      #Return R0, and Virus load at equilibrium for this parameter set
      Veq = (delta*tau*kappa)/((delta+mu)*alpha*rho) -mu/beta 
      R0 = (tau* beta * kappa * delta)/(alpha*rho*mu*(delta+mu))
      return(c("R0, V_equilibrium", R0, Veq))
}



###########################################################################
## Running the model with different initial conditions or different input parameters
## YOU CAN CHANGE THIS PART OF THE CODE
###########################################################################
# To call the model with the default parameter values above, set initial conditions and then type BasicInfectionModel(x)
x <- c(z0 = 80, x0 = 20, y0 = 0, v0 = 1) #refers to z0, x0, y0, v0
BasicInfectionModel(x)
# To generate R0 and plots with different parameter values, change the parameter values in the line below and copy the line into the R command window
#default parameter values were: (tau = 1, mu = 0.01, beta = 0.01, delta = 0.1,  alpha = 0.05, kappa = 20, rho = 5)
BasicInfectionModel(x,tau = 1.0, mu = 0.01, beta=0.05, delta = 0.1, alpha = 0.05, rho=5.0, kappa=40.0)

#or if you just want to change one of the parameter values, e.g beta, type
BasicInfectionModel(beta = 0.00025)

	# Reminder: Parameters are
	# alpha = apoptosis rate of infected cells
	# beta = infection rate
	# delta = differentiation rate z->x
	# tau,mu = birth and death rate of non-infected macros
	# kappa = virus replication rate
	# rho = virus decay rate


