function y=SIORX3_manyeps_model(par,t,g,h,S0,H0,R0,X0,teps,Eps,C,Inc,Pop)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3);
    Y0 = SIORX3age_model([b g h S0 [i0 0 0] H0 R0 X0],-t0:teps(1), C, Inc, Pop);
    Y=zeros(t(end),15);
    Y(1:teps(1),:)=Y0(1:teps(1),:)
    % SHOULD CHECK 1<teps1<teps2<t(end)
    n=max(size(teps)); teps=[teps t(end)]; Ci=ones(size(C));
    for i=1:n
        Ti=teps(i):teps(i+1); 
        Ci(:,:)=Eps(3,:,:); Ci=Ci.*C;
        Y(Ti,:)  = SIORX3age_model([b g h Y(Ti)], Ti, Ci, Inc, Pop);
    end
    y=Y;
end


