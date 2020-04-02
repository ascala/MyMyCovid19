function Y = SIORX3age_model(par,t,C,Inc,Pop)
b=par(1); g=par(2); h=par(3);
%S0=[par(4) par(5)]; I0=[par(6) par(7)]; H0=[par(8) par(9)]; R0=[par(10) par(11)]; X0=[par(12) par(13)]
%Y0=[S0 I0 H0 R0 X0]=par(4:11); % WILL BE TREATED AS A COLUMN !!!

% SIR model with contact matrix C and Incidence matrix Inc
% dS/dt = -b*S.*C*I/N
% dI/dt =  b*S.*C*I/N -g*I
% dO/dt =  g*Inc*I-h*O
% dR/dt =  g(1-Inc)*I+h*O
% dX/dt =  g*Inc*I % JUST A COUNTER

bC=b*C;         % dS/dt = -S.*bC*I/N
                % dI/dt =  S.*bC*I/N - g*I
Gi=g*Inc;       % dO/dt =    Gi.*I   - h*O  ; dX/dt = Gi.*I
Gi1=g*(1-Inc);  % dR/dt =   Gi1.*I   + h*O


[T,Y]=ode45(@DifEq,t,par(4:18));

    % time derivative of the SIR model
    function dYdt=DifEq(t,Y) % Y is treated as a column, even if passed as a row !!!
        S=Y(1:3); I=Y(4:6); O=Y(7:9); R=Y(10:12); X=Y(13:15);
        dS=-S.*(bC*I./Pop); dI=-g*I;
        dO=Gi.*I; dR=Gi1.*I; dH=h*O;
        dYdt = [ dS;-dS+dI; dO-dH; dR+dH; dO];
    end

end
