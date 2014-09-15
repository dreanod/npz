function [ y ] = linear_rot( x, theta1, theta2 )
%LINEAR_ROT Summary of this function goes here
%   Detailed explanation goes here
    R1 = [[cos(theta1), -sin(theta1), 0]
          [sin(theta1),  cos(theta1), 0]
          [0          , 0           , 1]];

    R2 = [[1,           0,            0]
          [0, cos(theta2), -sin(theta2)]
          [0, sin(theta2),  cos(theta2)]];

    M = R1 * R2;
    y = M * x;
end

