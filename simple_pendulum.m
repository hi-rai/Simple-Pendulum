clear ;
clc ;
%Properties of Pendulum
g = 9.81 ;           		% Acceleration due to gravity
mass = 10 ;              	% Mass of the pendulum
len = 1 ;              		% Length of the Pendulum
damCoff = 1000 ;            % Damping coefficient 
% Initial Boundary Conditions for the motion of the pendulum
Phi = 0.5;            		% Angular Position
PhiDot = 1.0;        		% Angular Velocity
totDuration = 60;      		% Duration of the Simulation 
fps = 20;           		% Number of frames per second
interval = [0, totDuration];% Time span represented as vector
initial=[Phi; PhiDot; g; mass; len ; damCoff]; % Initial conditions for the problem
% Simulation of Simple Pendulum by calling graph() function
graph(initial, totDuration, fps);


%defining graph() function
function graph(initial, totDuration, fps)
totFrames=totDuration*fps; % Total number of frames
% Solving the Differential Equation of the pendulum using ode45
solutions=ode45(@Equation,[0 totDuration], initial); 
time = linspace(0,totDuration,totFrames);
%obtaining the solution to the problem from the 'solution' structure returned by ode45 
y = deval(solutions,time);
%Assigning Angular Position and velocity to new variables
phi = y(1,:)';
phiDot = y(2,:)';
len = initial(5); 
% To set the Range os Phase plane, time vs. depl plots
minPhi = 1.25*min(phi) ; maxPhi = 1.25*max(phi);
minPhiDot = 1.25*min(phiDot) ; maxPhiDot = 1.25*max(phiDot);
% Drawing the graph
newFig = figure ;
set(newFig,'name','Signals and Systems - Simple Pendulum','numbertitle','off','color', 'y','menubar','figure') ;
%toggle button to stop the simulation
stop = uicontrol('style','toggle','string','stop','background','w');
% Plot for swinging pendulum
subplot(2,2,1);
SubP1 = plot(0,0,'MarkerSize',30,'Marker','.','LineWidth',1.5,'Color','b');
title('Simple Pendulum Animation','Color','m');
range = 1.2*len;
axis([-range range -range range]);
axis square;
set(gca,'XTickLabelMode', 'manual', 'XTickLabel', [],'YTickLabelMode', .....
    'manual', 'YTickLabel', []);
% Plot for the phase plane description of pendulum motion
subplot(2,2,[3 4]) ;
subP2 = plot(initial(1),initial(2),'LineWidth',1,'Color','b') ;
axis([minPhi maxPhi minPhiDot maxPhiDot]) ;
xlabel('\phi') ;ylabel('\phi''') ;
set(get(gca,'YLabel'),'Rotation',0.0)
grid on ;
title('Phase Plane Plot','Color','m')
% Plot for time Vs. displacement graph
subplot(2,2,2) ;
subP3 = plot(time(1),initial(1),'LineWidth',1,'Color','b') ;
axis([0 totDuration minPhi maxPhi]) ;
xlabel('t') ;ylabel('\phi') ;
set(get(gca,'YLabel'),'Rotation',0.0)
grid on ;
title('Time Vs. Displacement Plot','Color','m');
% Animation starts
for i=1:length(phi)-1
    % Animation Plot
    if (ishandle(SubP1)==1)
        PendX=[0,len*sin(phi(i))];
        PendY=[0,-len*cos(phi(i))];
        set(SubP1,'XData',PendX,'YData',PendY);
        if get(stop,'value')==0
            drawnow;
        elseif get(stop,'value')==1
            break;
        end
        % Phase Plane Plot
        if (ishandle(subP2)==1)
            PhaPlot(i,(1:2)) = [phi(i) phiDot(i)];
            set(subP2,'XData',PhaPlot(:,1),'YData',PhaPlot(:,2));
            drawnow;         
        end
            % Time Vs. displacement Plot  
        if (ishandle(subP3)==1)
            TimePlot(i,(1:2)) = [time(i) phi(i)] ; %#ok<*AGROW>
            set(subP3,'Xdata',TimePlot(:,1),'YData',TimePlot(:,2)) ;
            drawnow ;    
        end    
   end  
end         
% Close the Figure window
set(stop,'style','pushbutton','string','close','callback','close(gcf)');
end


%function defining differential equation for the angular velocity of the pendulum 
%function is passed as an argument to ode45
function xVel = Equation(~,x)
w0 = x(3)/x(5);
eta = x(6)/(x(4)*x(5));
xVel=zeros(length(x),1);
xVel(1)=x(2);       %angular velocity
xVel(2)=-(w0*sin(x(1))+eta*x(2));   %angular acceleration
%xVel=[x(2);  -(w0*sin(x(1))+eta*x(2));];
end
