function Y=SIORX1_t0(par,t,g,h,S0,H0,R0,X0,C,Inc,Pop)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); 
    Y0 = SIORX1age_model([b g h S0 i0 H0 R0 X0],-t0:1, C, Inc, Pop);
    Y  = SIORX1age_model([b g h Y0(end,:)],t, C, Inc, Pop);
%    y=sum(Y(:,5)+Y(:,6),2);
%    y=sum(Y(:,9)+Y(:,10),2);
%    y=Y(:,5);
end


