%Reproduce relults from Irina Barzykina, Feb 2017 (Professor Zietsman)
% Matlab
%The physics of an optimal basketball free throw

%Give release angle theta and initial velocity v, plot trajectory. 

clear all
clc
close all
%Parameters
%g gravitatinal acceleration 9.8 or 10? 
%H height of hoop from floor
%h height of release from floor
%theta_0 release angle
%v0 initial velocity
%alpha angle of descent
% d horizontal distance to middle of hoop
%R radius of hoop
%r radius of ball
%------------------------------------
%Parameters for this study
%------------------------------------
g=9.8;
r=0.12;
R=0.23;
H=3.05;
d=4.6;
h=2;
%------------------------------------
%------------------------------------  
%------------------------------------
%Define velocity in terms of theta and x-component, assume y=H, 
%Equation(4)

v=@(x,theta) (x./cosd(theta)).*sqrt((g/2)./(x*tand(theta)+h-H));
%------------------------------------
%------------------------------------
%Position of ball in terms of initia velocity and release angle,  Equations (1) and (2)

fx=@(t,v,theta)  v.*t*cosd(theta);
fy=@(t,v,theta) h+v.*t*sind(theta)-0.5*g*t.^2;
%------------------------------------
%------------------------------------
theta=45;
V=7.7;

T=max(roots([-.5*g V*sind(theta) h-H]));
        
        %Calculate the trajectory for given V and theta over the interval
        %[0,T]
        t=linspace(0,T);
        X=fx(t,V,theta);
        Y=fy(t,V,theta);
        
        %plot last trajectory
        figure
        hold on
        plot(X,Y)
        %(1:col),Y(1:col)
        %Rim
        x_rim=[d-R d+R];
        y_rim=[H H];
        plot(x_rim,y_rim)
        legend('Trajectory','Rim')
   
% %Plot the ball
alpha=linspace(0,2*pi);
% xs=r*cos(alpha)+X(col);
% ys=(r*sin(alpha)+Y(col));
xs=r*cos(alpha)+X(length(t));
ys=(r*sin(alpha)+Y(length(t)));
fill(xs,ys,'y')
  plot(x_rim,y_rim)
axis('equal')
