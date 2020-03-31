function y=SIOR_local3_model(par,t,g,h,S0,H0,R0,C,Inc,N)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); teps1=par(4); eps1=par(5); teps2=par(6); eps2=par(7); teps3=par(8); eps3=par(9);
    Y0 = SIORage_model([b g h S0 [i0 0] H0 R0],-t0:1, C, Inc, N);
    % SHOULD CHECK 1<teps1<teps2<t(end)
        Y=zeros(t(end),8);
        Y(1:teps1,:)  = SIORage_model([b g h Y0(end,:)],1:teps1, C, Inc, N);
        Y(teps1:teps2,:)  = SIORage_model([b g h Y(teps1,:)],teps1:teps2,  eps1*C, Inc, N);
        Y(teps2:teps3,:)  = SIORage_model([b g h Y(teps2,:)],teps2:teps3,  eps2*C, Inc, N);
        Y(teps3:t(end),:) = SIORage_model([b g h Y(teps3,:)],teps3:t(end), eps3*C, Inc, N);

    y=Y;
end


