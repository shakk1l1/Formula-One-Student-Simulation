function [out] = magic_formula2(params,x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
out = params(3) * sin(params(2) * atan(params(1) * x - params(4) * (params(1) * x - atan(params(1) * x))));
end

