function y=SIORX1_t2(par,t,g,h,S0,H0,R0,X0,C,Inc,N)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); t1=par(4); a1=par(5); t2=par(6); a2=par(7);
    
    Y0 = SIORX1age_model([b g h S0 i0 H0 R0 X0],-t0:1, C, Inc, N);
    Y=zeros(t(end),5);
    % SHOULD CHECK 1<t1<t2<t(end)
    Y(1:t1,:)      = SIORX1age_model([b g h Y0(end,:) ], 1:t1,         C, Inc, N);
    Y(t1:t2,:)     = SIORX1age_model([b g h Y(t1,:)],    t1:t2,     a1*C, Inc, N);
    Y(t2:t(end),:) = SIORX1age_model([b g h Y(t2,:)],    t2:t(end), a2*C, Inc, N);

    y=Y(:,5);
end


