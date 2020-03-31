function y=SIORX_local2(par,t,g,h,S0,H0,R0,X0,C,Inc,N)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); teps1=par(4); eps1=par(5); teps2=par(6); eps2=par(7);
    Y0 = SIORXage_model([b g h S0 [i0 0] H0 R0 X0],-t0:1, C, Inc, N);
    Y=zeros(t(end),10);

    % SHOULD CHECK 1<teps1<teps2<t(end)
    Y(1:teps1,:)      = SIORXage_model([b g h Y0(end,:) ],1:teps1,           C, Inc, N);
    Y(teps1:teps2,:)  = SIORXage_model([b g h Y(teps1,:)],teps1:teps2,  eps1*C, Inc, N);
    Y(teps2:t(end),:) = SIORXage_model([b g h Y(teps2,:)],teps2:t(end), eps2*C, Inc, N);

%    y=sum(Y(:,5)+Y(:,6),2);
    y=sum(Y(:,9)+Y(:,10),2);
end


