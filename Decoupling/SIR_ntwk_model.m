function Y = SIR_ntwk_model(b,g,S0,I0,R0,t,C,N)

% SIR model with contact matrix C and Incidence matrix Inc
% dS/dt = -b*S.*C*(I./N)
% dI/dt =  b*S.*C*(I./N) -g*I
% dR/dt =  g*I

bC=b*C; n=max(max(size(C)));

[T,Y]=ode45(@DifEq,t,[S0' I0' R0']);

    % time derivative of the SIR model
    function dYdt=DifEq(t,Y) % Y is treated as a column, even if passed as a row !!!
        S=Y(1:n)'; I=Y(n+1:2*n)'; R=Y(2*n+1:3*n)';
        pI=I./N; dS=-S.*(bC*pI); dR=g*I;
        dYdt = [ dS;-dS-dR; -dI];
    end

end
