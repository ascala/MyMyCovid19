
########################################################################################
## R code for the practical on modelling within host infection dynamics
## The code represents the within host infection model with immune response in the lecture
########################################################################################
library(deSolve)

## ODE system for the infection model
## DO NOT CHANGE THIS PART
InfectionModelODE <- function(t, xinit, parms) {
	X <- xinit[1] # Susceptible target cells
	Y <- xinit[2] # Infected cells
	V <- xinit[3] # Virus
	U <- xinit[4] # T-cell response
	W <- xinit[5] # neutralizing AB response
      M <- xinit[1]+xinit[2] # total nr of cells
	with(as.list(parms),{	
	dX <- delta*(M-X-Y)- mu * X- beta*V*X
	dY <- beta * X * V -alpha * Y - theta * U * Y
	dV <- kappa*Y - rho * V - psi * V * W
      dU <- eps * Y *U - sigma * U
      dW <- gamma*V * W - omega * W
 	res<-c(dX, dY, dV, dU, dW)
 	list(res)
  	})
	}

##########################################################################
## The function FullInfectionModel simulates the infection process
## We pre-programmed this model with certain baseline parameter values. 
## Run this code in R first
## To run the model with different initial conditions /  parameter values, 
## see instructions at the bottom of this file 
#############################################################################
FullInfectionModel <- function(xinit, delta = 0.1, mu = 0.01, beta=0.005, alpha = 0.05, rho=5.0, kappa=50.0, theta=0.1, eps =0.005, sigma = 0.01, psi = 1, gamma=0.01, omega = 0.1){
	# variables:
	# y(1) = z (non diff. macros)
	# y(2) = x (susceptible macros)
	# y(3) = y (number of infected cells)
	# y(4) = v (virus load)
	# Parameters:
	# alpha = apoptosis rate of infected cells
	# beta = infection rate
	# delta = differentiation rate z->x
	# mu = death rate of non-infected cells
	# kappa = virus replication rate
	# rho = virus decay rate
      # eps = stimulation rate of CTL response
      # sigma = death rate of CTL response
      # theta = rate in which CTLs eliminate infected cells
      # gamma = stimulation rate of AB response
      # omega = decay rate of AB response
      # psi = rate in which ABs eliminate virus


	# Time span to produce solutions
	tspan <- 1000
	
      # set new initial conditions
      # xinit2 <- c(x0 = 100, y0 = 0, v0 = 1, u0=0.01, w0=0.01) #refers to  x0, y0, v0, u0, w0	
	
      ## Set parameter values: Use the default values above and set some to zero to 'switch' off Tcell or nAB response, or both:   	
      parms <- c(delta = delta, mu = mu, beta=beta, alpha = alpha, rho=rho, kappa=kappa, theta=theta, eps =eps, sigma = sigma, psi = psi, gamma=gamma, omega = omega)      
      # switch off both Tcell and nAB response:      
      parmsNoIR <- c(delta = delta, mu = mu, beta=beta, alpha = alpha, rho=rho, kappa=kappa, theta=0, eps =0, sigma = 0, psi = 0, gamma=0, omega = 0)
      # T-cell response only - switch off nAB response
      parmsTcell <- c(delta = delta, mu = mu, beta=beta, alpha = alpha, rho=rho, kappa=kappa, theta=theta, eps =eps, sigma = sigma, psi = 0, gamma=0, omega = 0)
      # nAB response only - swith off Tcell respone
      parmsNAB <- c(delta = delta, mu = mu, beta=beta, alpha = alpha, rho=rho, kappa=kappa, theta=0, eps =0, sigma = 0, psi = psi, gamma=gamma, omega = omega)

      
      ## Generate the corresponding solutions  X(t), Y(t), V(t), U(t), W(t) by solving the ODE systems for the above parameter values      
      out  <- as.data.frame(lsoda(xinit, 0:tspan, InfectionModelODE, parms))
      outNoIR  <- as.data.frame(lsoda(xinit, 0:tspan, InfectionModelODE, parmsNoIR))
      outTcell  <- as.data.frame(lsoda(xinit, 0:tspan, InfectionModelODE, parmsTcell))
      outNAB  <- as.data.frame(lsoda(xinit, 0:tspan, InfectionModelODE, parmsNAB))
      out$total <- rowSums(out[,2:3])#total number of cells - for scaling axes in plots below

	
      ## Produce plots

	dev.new(width = 10, height = 8)
	layout(matrix(c(1,2),1,2), widths=c(0.5, 0.5))
	#xMax <- out$time[which.max(out$v0)] * 10
      xMax <- 1000 #plot up to time <= 1000
      #yMax <- outNoIR$v0[which.max(out$v0)] 
      yMax <- max(outNoIR$v0)
#	first plot: Virus load profiles for 4 different scenarios
	par(mar = c(4,4,1,1), mfrow=c(2,2))
  	plot(out$time, out$v0, type = "l", ylab = "Virus load", xlab = "Time", col = "blue2", xlim = c(0, xMax), ylim = c(0,yMax))
      points(outNoIR$time, outNoIR$v0, type = "l", col = "green")
      points(outTcell$time, outTcell$v0, type = "l", col = "red")
      points(outNAB$time, outNAB$v0, type = "l", col = "black")
      legend("topright", c("Tcells & nABs", "No immune response", "Tcells only", "nABs only"), lty = rep(1,3), col = c("blue2", "green", "red", "black"))

#	2nd plot: Infected cells for 4 different scenarios
      plot(out$time, out$y0, type = "l", ylab = "Infected cells", xlab = "Time", col = "blue2", ylim = c(0, max(out$total)), xlim = c(0, xMax))
      points(outNoIR$time, outNoIR$y0, type = "l", col = "green")
      points(outTcell$time, outTcell$y0, type = "l", col = "red")
      points(outNAB$time, outNAB$y0, type = "l", col = "black")
	legend("topright", c("Tcells & nABs", "No immune response", "Tcells only", "nABs only"), lty = rep(1,3), col = c("blue2", "green", "red", "black"))
   
#	3rd plot: Tcell response with / without NAB response	
      plot(out$time, out$u0, type = "l", ylab = "T cell response", xlab = "Time", col = "blue2", ylim = c(0, max(outTcell$u0)), xlim = c(0, xMax))
      points(outTcell$time, outTcell$u0, type = "l", col = "red")
	legend("topright", c("Tcells & nABs", "Tcells only"), lty = rep(1,3), col = c("blue2", "red"))

#	4th plot: neutralizing Antibody response for with / without T-cell response	
      plot(out$time, out$w0, type = "l", ylab = "neutralizing AB response", xlab = "Time", col = "blue2", ylim = c(0, max(outNAB$w0)), xlim = c(0, xMax))
      points(outNAB$time, outNAB$w0, type = "l", col = "black")
	legend("topright", c("Tcells & nABs", "nABs only"), lty = rep(1,3), col = c("blue2", "black"))

    
return(c(1))
}

###########################################################################
## Running the model with different initial conditions or different input parameters
## YOU CAN CHANGE THIS PART OF THE CODE
###########################################################################

# To call the model with the default parameter values above, set initial conditions and then type FullInfectionModel(x)
 x <- c(x0 = 100, y0 = 0, v0 = 1, u0=0.1, w0=0.01)
FullInfectionModel(x)

# To run the model with different parameter values, change the values directly in the function argument, ie. type e.g. 
#defaults were: delta = 0.1, mu = 0.01, beta=0.005, alpha = 0.05, rho=5.0, kappa=50.0, theta=0.1, eps =0.005, sigma = 0.01, psi = 1, gamma=0.01, omega = 0.1)
FullInfectionModel(x, delta = 0.001, mu = 0.0001, beta=0.005, alpha = 0.0005, rho=1.0, kappa=10.0, theta=0.00005, eps =0.0005, sigma = 0.01, psi = 1, gamma=0.1, omega = 0.005)

# Reminder: Parameters are
	# alpha = apoptosis rate of infected cells
	# beta = infection rate
	# delta = differentiation rate z->x
	# mu = death rate of non-infected cells
	# kappa = virus replication rate
	# rho = virus decay rate
      # eps = stimulation rate of CTL response
      # sigma = death rate of CTL response
      # theta = rate in which CTLs eliminate infected cells
      # gamma = stimulation rate of AB response
      # omega = decay rate of AB response
      # psi = rate in which ABs eliminate virus





