function y=SIORX3_t2_model(par,t,g,h,S0,H0,R0,X0,C,Inc,Pop)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); teps1=par(4); eps1=par(5); teps2=par(6); eps2=par(7);
    Y0 = SIORX3age_model([b g h S0 [i0 i0 i0]/3 H0 R0 X0],-t0:1, C, Inc, Pop);
    Y=zeros(t(end),15);

    % SHOULD CHECK 1<teps1<teps2<t(end)
    Y(1:teps1,:)      = SIORX3age_model([b g h Y0(end,:) ],1:teps1,      C,      Inc, Pop);
    Y(teps1:teps2,:)  = SIORX3age_model([b g h Y(teps1,:)],teps1:teps2,  eps1*C, Inc, Pop);
    Y(teps2:t(end),:) = SIORX3age_model([b g h Y(teps2,:)],teps2:t(end), eps2*C, Inc, Pop);

    y=Y;
end


