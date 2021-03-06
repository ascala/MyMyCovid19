function y=SIORX2_t1(par,t,g,h,S0,H0,R0,X0,C,Inc,N)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); teps=par(4); eps=par(5);
    Y0 = SIORX2age_model([b g h S0 [i0 0] H0 R0 X0],-t0:1, C, Inc, N);
    Y=zeros(t(end),10);
    if t(end)<=teps;
        Y = SIORX2age_model([b g h Y0(end,:)],t, C, Inc, N);
    else
        Y(1:teps,:)  = SIORX2age_model([b g h Y0(end,:)],1:teps, C, Inc, N);
        Y(teps:t(end),:) = SIORX2age_model([b g h Y(teps,:)],teps:t(end), eps*C, Inc, N);
    end
%    y=sum(Y(:,5)+Y(:,6),2);
    y=sum(Y(:,9)+Y(:,10),2);
end


