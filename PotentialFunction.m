function [ W ] = PotentialFunction( y, z, d, D, H )
%% Potential Function %%
%Eastern Nazarene College Earthquake Forcasting
%   This function computes the magnetic potential generated at a point y,z
%   away from the fault line usign the Uniform Vertical Strike-Slip Fault
%   of Infinite Length as set forth by Sasai (1980)
%This script and all of its components were written by Caleb Vatral

%% Function Definitions
%   Potential Functions as they appear in Appendix C of Sasai (1980)
if y==0         %not sure if we need this
    W=NaN(1);   %I don't know how matlab handles divide by 0
                %if its not here, then we have divide by 0 in the arctan
                %functions below at y=0
else
    % These are the piecewise potentials as they appear in Sasai (1980)
    W0 = 3*(atan((d-z)/y)-atan((D-z)/y)+atan((2*H+D-z)/y)-atan((2*H+d-z)/y));
    W1 = 3*(atan((d-z)/y)-atan((D-z)/y)-atan((2*H-D-z)/y)+atan((2*H-d-z)/y));
    W2 = 3*(atan((d-z)/y)-(2*atan((H-z)/y))+atan((2*H-d-z)/y));
    W3=0;
    
    % This block of if statements defines the piecewise nature of the
    % potential function depending on the fault geometry
    if H>=D
        W = (1.75*(10^-9))*(W0 + W1);
    elseif D>H && H>=d
        W = (1.75*(10^-9))*(W0 + W2);
    elseif d>H
        W = (1.75*(10^-9))*(W0 + W3);
    end
end
end

