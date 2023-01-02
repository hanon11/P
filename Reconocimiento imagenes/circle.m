function [x,y]=circle(h,k,r)
%Give the values for x and y for plot a CIRCLE.
% [X,Y] = CIRCLE(H,K,R)
% This Example plot a CIRCLE:
% h=input('Type h: ');
% k=input('Type k: ');
% r=input('Type r: ');
% [x,y]=circle(h,k,r);
% plot(x,y),grid,axis equal,hold on
%
%@autor Jairo Corredor
%@Date 10/05/02

o=-pi:0.001:pi;
x=r*cos(o)+h;
y=r*sin(o)+k;