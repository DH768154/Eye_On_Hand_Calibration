function X_calc = EyeOnHand(E,S,varargin)
% v1.0 , 09-26-2023
% v1.1 , 09-28-2023, Add Quaternion Method for AX=XB, CIS Lecture
% v1.2 , 12-08-2023, class end, remove unnesseary part
% 
% Ding, Hao-sheng
% 
% Eye On Hand Calibration
% 
% E: Hand to Base, 4*4*n, n>=3
% S: Eye to Target, 4*4*n, n>=3
% 3rd Input: Optional, Select Pair Measurement Method, default 3
%
% Pair Method:
% 1. [1,2] [3,4] [5,6]
% 2. [1,2] [1,3] [1,4], At Least 1st Measure can be Good
% 3. [1,2] [2,3] [3,4], Incase Checker Board Moved during Calibration
%
% Example:
% X_calc = EyeOnHand(E,S); 
% X_calc = EyeOnHand(E,S);% Debuge on the 4th Pair
% X_calc = EyeOnHand(E,S,'Pair_Method',3); % Use 3rd Pair Method, 

p = inputParser;
addOptional(p,'Pair_Method',3)
parse(p,varargin{:});
pair_method = p.Results.Pair_Method;

ptnum = size(E,3);

%% Pair Method

if pair_method == 1     
    % [1,2] [3,4] [5,6]
    % sets = floor(ptnum/2);
    ind = [1:2:ptnum;2:2:ptnum];
elseif pair_method == 2 
    % [1,2] [1,3] [1,4], At Least 1st Measure can be Good
    sets = ptnum-1;
    ind = [ones([1,sets]);2:ptnum];
elseif pair_method == 3 
    % [1,2] [2,3] [3,4], Incase Checker Board Moved during Calibration
    % sets = ptnum-1;
    ind = [1:ptnum-1;2:ptnum];
end

%% Difference Matrix

As = pagemtimes( HomInv(E(:,:,ind(1,:))) , E(:,:,ind(2,:)) );
Bs = pagemtimes( S(:,:,ind(1,:)) , HomInv(S(:,:,ind(2,:))) );

%% Get Rotation

% Optional Input: Calculation method (default method 2)
% 1. Park & Martin Method From ASBR Lecture
% 2. Quaternion Method From CIS Lecture

R_calc = RAXXRB(As(1:3,1:3,:),Bs(1:3,1:3,:),2);

%% Get Translation

% tA = reshape(As(1:3,4,:),3,[]);
% tB = reshape(Bs(1:3,4,:),3,[]);
% RA = As(1:3,1:3,:);
% P_calc = solveTx( RA, [], tA, tB, R_calc );

P_calc = solveTx(As(1:3,1:3,:), As(1:3,4,:), Bs(1:3,4,:), R_calc);

X_calc = R2T(R_calc,P_calc);

end