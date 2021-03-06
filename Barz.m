%Reproduce relults from Irina Barzykina, Feb 2017 (Professor Zietsman)
% Matlab
%The physics of an optimal basketball free throw
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
%Get idea of theta_min from Equation (8)
%to determine theta interval for v_max.
%Rough estimate of theta_min. Verify numerically. 
%Includes approximations such as d-R+r approx d. 
factor=(r/(2*R))*(1-r/R)^(-.5)+2*(H-h)/d;
theta_min=atand(factor);

%------------------------------------
%------------------------------------
%Define velocity in terms of theta and x-component, assume y=H, 
%Equation(4)

v=@(x,theta) (x./cosd(theta)).*sqrt((g/2)./(x*tand(theta)+h-H))
%------------------------------------
%------------------------------------
%Position of ball in terms of initia velocity and release angle,  Equations (1) and (2)

fx=@(t,v,theta)  v.*t*cosd(theta);
fy=@(t,v,theta) h+v.*t*sind(theta)-0.5*g*t.^2;
%------------------------------------
%------------------------------------
% %Plot v_max
% theta=linspace(theta_min,65);
% v_max=v(d+R-r,theta);
% 
% 
% figure
% hold on
% plot(theta,v_max)
% legend('v_max(theta) starting at the point theta_min')
%------------------------------------
%------------------------------------


%Iterate over values for theta
N=30 %number of theta points for smile plot
theta_vector=linspace(theta_min,65,N);
   for i=1:N
       %Calculate v_max and v_min for each theta(i)
        theta=theta_vector(i);
 
        %Calculate v_max for specific theta
        v_max=v(d+R-r,theta);
        
%Start with a theta and v_max-k*0.001, calculate (x,y) over t interval,
%check if (9) holds.
%Do that by making a vector called Test that calculates (X-(d-R)).^2+(Y-H).^2-r^2
%for eaxch X and Y on the trajectory. 
%Determine when the entries in Test changes sign,that is, ball hits front rim.  
%The previous velocity must thenbe v_min since there was no
%violation of coniditon (9) for that velocity.

        %For a fixed theta
        k=0;col=[];
        while isempty(col)   %this means condition(9) holds
            V=v_max-k*0.001;
        %Time interval to consider motion on depending on theta and V
        %roots of quadratic (Equation (2) where y=H. Choose largest T for downward motion
        
        T=max(roots([-.5*g V*sind(theta) h-H]));
        
        %Calculate the trajectory for given V and theta over the interval
        %[0,T]
        t=linspace(0,T);
        X=fx(t,V,theta);
        Y=fy(t,V,theta);
        %Determine if ball will miss the front rim
        Test=(X-(d-R)).^2+(Y-H).^2-r^2;
        %Find the first time that the condition is violated. The entry before, is
        %positive and the entry after is negative.
        [row, col]=find(Test<0,1);
        %Increase counter k to update V=v_max-k*0.001 if col is empty, that is condition not violated.
        %If conidtion is violated, while loop will end. 
        k=k+1;
        end
        %For given theta and current V, this Test vector is the first case where 
        %where the (x,y) coordinate violates condition (9). 
        %the "previous" velocity, V+0.001 was the min velocity where the coniditon was not
        %violated
        
        %smile_data=[theta v_max v_min]
        v_min=V+0.001;
        smile_data(i,:)=[theta_vector(i) v_max v_min];
   end
   
   figure
   hold on
   plot(smile_data(:,1),smile_data(:,2),smile_data(:,1),smile_data(:,3))
   legend('theta v.s. v_{max}', 'theta v.s. v_{min}')
   title('Smile for theta v.s. v_{max} and v_{min}')
