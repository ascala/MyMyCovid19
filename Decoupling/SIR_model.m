function Y = SIR_model(b,g,S0,I0,R0,t,N)

% SIR model with contact matrix C and Incidence matrix Inc
% dS/dt = -b*S.*C*(I./N)
% dI/dt =  b*S.*C*(I./N) -g*I
% dR/dt =  g*I


[T,Y]=ode45(@DifEq,t,[S0 I0 R0]);

    % time derivative of the SIR model
    function dYdt=DifEq(t,Y) % Y is treated as a column, even if passed as a row !!!
        S=Y(1); I=Y(2); R=Y(3);
        dS=-S*I/N; dR=g*I;
        dYdt = [  dS; 
                 -dS-dR; 
                     dR];
    end

end
