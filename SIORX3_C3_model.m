function y=SIORX3_t2_model(t,t0,b,g,h,S0,I0,H0,R0,X0,C,Inc,Pop,t1,C1,t2,C2,t3,C3)
    
    Y0 = SIORX3age_model([b g h S0 I0 H0 R0 X0],-t0:1, C, Inc, Pop);
    Y=zeros(t(end),15);
    
    % SHOULD CHECK 1<teps1<teps2<t(end)
    Y(1:t1,:)      = SIORX3age_model([b g h Y0(end,:)], 1:t1,      C,  Inc, Pop);
    Y(t1:t2,:)     = SIORX3age_model([b g h  Y(t1,:) ], t1:t2,     C1, Inc, Pop);
    Y(t2:t3,:)     = SIORX3age_model([b g h  Y(t2,:) ], t2:t3,     C2, Inc, Pop);
    Y(t3:t(end),:) = SIORX3age_model([b g h  Y(t3,:) ], t3:t(end), C2, Inc, Pop);

    y=Y;
end


