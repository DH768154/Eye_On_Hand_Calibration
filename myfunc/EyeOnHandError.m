function [err,str,frames] = EyeOnHandError(E,X,S)
% v1.0, 09-26-2023, Ding, Hao-sheng
% v1.1, 12-28-2023, Modify method
% 
% err: [avg,max,std]

ptnum = size(E,3);
EX = pagemtimes(E,X); % Base to Eye
EXS = pagemtimes(EX,S); % Base to Checker Board

[R_EXS,P_EXS] = mxparts(EXS);
EXS_m = AvgSE3(R_EXS,P_EXS);

e_mag = diffSE3(EXS_m,EXS,'world');

err = [mean(e_mag,2),max(e_mag,[],2),std(e_mag,0,2)];

scale = [1000;180/pi];
str = cell(5,1);
str{1} = sprintf('Calibration Error (Compare to Mean Frame)\n');
str{2} = sprintf('%.0f Measurements\n',ptnum);
str{3} = sprintf('Avg Tran / Rot: %5.2f mm / %5.2f deg',err(:,1).*scale);
str{4} = sprintf('Max Tran / Rot: %5.2f mm / %5.2f deg',err(:,2).*scale);
str{5} = sprintf('Std Tran / Rot: %5.2f mm / %5.2f deg',err(:,3).*scale);

frames.EX = EX;
frames.EXS = EXS;
frames.EXS_m = EXS_m;
end
