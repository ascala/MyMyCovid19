function y=SIORX3_t1(par,t,g,h,S0,H0,R0,X0,C,Inc,Pop)
    % par are [b i0 t0 teps eps]
    b=par(1); i0=par(2); t0=par(3); teps=par(4); eps=par(5);
    Y0 = SIORX3age_model([b g h S0 [i0 i0 i0]/3 H0 R0 X0],-t0:1, C, Inc, Pop);
    
    Y=zeros(t(end),15);
    % should check 1<teps<t(end)
    Y(1:teps,:)  = SIORX3age_model([b g h Y0(end,:)],1:teps, C, Inc, Pop);
    Y(teps:t(end),:) = SIORX3age_model([b g h Y(teps,:)],teps:t(end), eps*C, Inc, Pop);

%    y=sum(Y(:,5)+Y(:,6),2);
%    y=sum(Y(:,9)+Y(:,10),2);
    y=sum(Y(:,13:15),2);
end


