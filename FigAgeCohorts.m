FitSIORX1_t1_Italy; yaX=yX; ya0=y0; ya1=y1; ya2=y2;
FitSIORX2_t1_Italy; ybX=yX; yb0=y0; yb1=y1; yb2=y2;
FitSIORX3_t1_Italy; ycX=yX; yc0=y0; yc1=y1; yc2=y2;

figure(3); 
subplot(2,1,1); plot(T,ya1,'b',T,ya0,'k'); title("1 age cohort")
subplot(2,1,2); plot(T,yc1,'b',T,yc0,'k'); title("3 age cohorts")

% figure(3); 
% subplot(3,1,1); plot(T,ya1,'b',T,ya0,'k')
% subplot(3,1,2); plot(T,yb1,'b',T,yb0,'k')
% subplot(3,1,3); plot(T,yc1,'b',T,yc0,'k')
