function Y = SIRage_model(par,t,C,N)
b=par(1); g=par(2); 
%S0=[par(3); par(4)]; I0=[par(5); par(6)]; R0=[par(7); par(8)]; 
%Y0=[S0' I0' R0']=par(3:8);

% SIR model with contact matrix C and incidence matrix inc
% dS/dt = -b*S.*C*I/N
% dI/dt =  b*S.*C*I/N -g*I
% dR/dt =  gI

[T,Y]=ode45(@DifEq,t,par(3:8));

    % time derivative of the SIR model
    function dYdt=DifEq(t,Y) 
        S=Y(1:2); I=Y(3:4); R=Y(5:6);
        dI=b*S.*(C*I/N); 
        dR=g*I;
        dYdt = [ -dI; dI-dR; dR];
    end

end

