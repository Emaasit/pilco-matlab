%% draw_cdp.m
% *Summary:* Draw the cart-double-pendulum system with reward, applied force, 
% and predictive uncertainty of the tips of the pendulums
%
%    function draw_cdp(x, theta2, theta3, force, cost, M, S, text1, text2)
%
%
% *Input arguments:*
%
%		x          position of the cart
%   theta2     angle of inner pendulum
%   theta3     angle of outer pendulum
%   force      force applied to cart
%   cost       cost structure
%     .fcn     function handle (it is assumed to use saturating cost)
%     .<>      other fields that are passed to cost
%   M          (optional) mean of state
%   S          (optional) covariance of state
%   text1      (optional) text field 1
%   text2      (optional) text field 2
%
%
% Copyright (C) 2008-2013 by
% Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen.
%
% Last modified: 2013-03-27

function draw_cdp(x, theta2, theta3, force, cost, M, S, text1, text2)
%% Code

scale = 1;

l = 0.3*scale;
xmin = -3*scale;
xmax = 3*scale;
height = 0.07*scale;
width  = 0.25*scale;

font_size = 12;

% Compute positions
cart = [ x + width,  height
  x + width, -height
  x - width, -height
  x - width,  height
  x + width,  height ];
pend2 = [x, 0;
  x-2*l*sin(theta2), cos(theta2)*2*l];
pend3 = [x-2*l*sin(theta2), 2*l*cos(theta2);
  x-2*l*sin(theta2)-2*l*sin(theta3), 2*l*cos(theta2)+2*l*cos(theta3)];


% plot cart double pendulum
clf
hold on

plot(0,4*l,'k+','MarkerSize',2*font_size,'linewidth',2);
plot([xmin, xmax], [-height-0.03*scale, -height-0.03*scale], ...
  'Color','b','LineWidth',3);
plot([0 force/20*xmax],[-0.3, -0.3].*scale, 'Color', 'g', 'LineWidth', font_size);

% Plot reward
reward = 1-cost.fcn(cost, [x, 0, 0, 0, theta2, theta3]',zeros(6));
plot([0 reward*xmax],[-0.5, -0.5].*scale, 'Color', 'y', 'LineWidth', font_size);

% Draw Cart
plot(cart(:,1), cart(:,2),'Color','k','LineWidth',3);           
fill(cart(:,1), cart(:,2),'k');
% Draw Pendulum2
plot(pend2(:,1), pend2(:,2),'Color','r','LineWidth', round(font_size/2)); 
 % Draw Pendulum3
plot(pend3(:,1), pend3(:,2),'Color','r','LineWidth', round(font_size/2));
% joint at cart
plot(x,0,'o','MarkerSize', round((font_size+4)/2),'Color','y','markerface','y'); 
% 2nd joint
plot(pend3(1,1),pend3(1,2),'o','MarkerSize', ...
  round((font_size+4)/2),'Color','y','markerface','y');
% tip of 2nd joint
plot(pend3(2,1),pend3(2,2),'o','MarkerSize', ...
  round((font_size+4)/2),'Color','y','markerface','y'); 


% plot ellipses around tip of pendulum (if M, S exist)
try
  if max(max(S))>0
    [M1 S1 M2 S2] = getPlotDistr_cdp(M, S, 2*l, 2*l);
    error_ellipse(S1,M1,'style','b'); % inner pendulum
    error_ellipse(S2,M2,'style','r'); % outer pendulum
  end
catch
  
end


text(0,-0.3*scale,'applied  force','fontsize', font_size)
text(0,-0.5*scale,'immediate reward','fontsize', font_size)

if exist('text1','var')
  text(0,-0.7*scale, text1,'fontsize', font_size);
  if exist('text2','var')
    text(0,-0.9*scale, text2,'fontsize', font_size)
  end
end


set(gca,'DataAspectRatio',[1 1 1],'XLim',[xmin xmax],'YLim',[-1.4 1.4].*scale);

axis off

drawnow;

