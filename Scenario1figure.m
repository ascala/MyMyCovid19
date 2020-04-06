function Scenario1figure(X1, YMatrix1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 04-Apr-2020 19:11:21

% Create figure
figure1 = figure;

% Create axes
axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1);
set(plot1(1),'LineWidth',2,'Color',[1 0 0]);
set(plot1(2),'LineWidth',2,'LineStyle','--','Color',[0 0 1]);
set(plot1(3),'LineWidth',3,'LineStyle',':','Color',[0 0.5 0]);
set(plot1(4),'LineWidth',2.5,'Color',[0 0 0]);

box(axes1,'on');
% Create textbox
annotation(figure1,'textbox',...
    [0.335241668435576 0.808730158730159 0.156585969008703 0.0571428571428599],...
    'Color',[1 0 0],...
    'String','No Lockdown',...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.742923856020862 0.180281071585419 0.171616960305666 0.0836940836940912],...
    'Color',[0 0.501960784313725 0],...
    'String',{'Lockdown','ends at 50%'},...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.583142857142857 0.298989898989899 0.156827425175122 0.0819624819624888],...
    'Color',[0 0 1],...
    'String',['Lockdown',sprintf('\n'),'ends at 70%'],...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.412569048124449 0.408695652173913 0.204054659308002 0.0620490620490674],...
    'String','Lockdown starts at t=15',...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');
