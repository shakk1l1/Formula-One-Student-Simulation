function [params_fit, NFY_fit] = magic_curve_fit(SA_i_avg, NFY_i_avg)
% Magic Formula 
magic_formula = @(params, x) params(3) * sin(params(2) * atan(params(1) * x - params(4) * (params(1) * x - atan(params(1) * x))));
% First guess: [B, C, D, E]
%The first guess of the B parameter can be improved by taking stiffness at
% the origin / (C*D)
params0 = [0.15, 1.5, 3, 0.9];
options = optimoptions('lsqcurvefit', 'Display', 'off');
params_fit = lsqcurvefit(magic_formula, params0, SA_i_avg, NFY_i_avg, [], [], options);
NFY_fit = magic_formula(params_fit, SA_i_avg); %fited points
end