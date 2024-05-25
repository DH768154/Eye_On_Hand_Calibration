clc;clear;close all

%% Input

setname = 'test1';

%% Read Data File

mname = mfilename("fullpath");
[filepath,~,~] = fileparts(mname);
datapath = fullfile(filepath,'data');
addpath(fullfile(filepath,'myfunc'))

% File Name
fileH = fullfile(datapath,[setname,'_tool.txt']); % Hand Pose File
fileM = fullfile(datapath,[setname,'_tag.txt']); % Marker Pose File

% Read File
TH = readpose(fileH); 
TM = readpose(fileM);

if TH.size~=TM.size
    error('Measurements Number not Match !');
else
    ptnum = TH.size;
end

% Force to Rotation Matrix (Remove Round Off Error from Data Collection)
RH = ForceRot(Q2R(TH.rot),'m'); 
RM = ForceRot(Q2R(TM.rot),'m');

E = R2T(RH,TH.tran');
S = R2T(RM,TM.tran');

%% Calibration

X = EyeOnHand(E,S);
[xrot,xtran] = mxparts(X);
qX = R2Q(ForceRot(xrot,'m'));

qX = [qX(2:4), qX(1)]; % For ROS q Type
pX = xtran';

%% Error Analysis
% Check the Checker Board Pose

[err,str,frames] = EyeOnHandError(E,X,S);
h = warndlg(str(2:5),str{1}); waitfor(h);

fprintf(' \n')
for i = 1:length(str)
    fprintf('%s\n',str{i})
end
fprintf(' \n')
fprintf(['PosX: ', repmat('\t%8.4f',[1,3]),'\n'],pX);
fprintf(['RotX: ', repmat('\t%8.4f',[1,4]),'\n'],qX);


%% Plot to Check Error

[EX,EXS,EXS_m] = deal(frames.EX, frames.EXS, frames.EXS_m);
fixture = [E(1:3,4,:),EX(1:3,4,:)];
loc_target = reshape(EXS(1:3,4,:),[3,ptnum]); % Location of the AR Tag
loc_camera = reshape(EX(1:3,4,:),[3,ptnum]); % Location of the Camera

scale = mean(sum([E(1:3,4,:),EX(1:3,4,:),EXS(1:3,4,:)].^2).^0.5,'all')/12;

f = figure;
for i =1:ptnum
    PlotFrame(E(:,:,i),'scale',scale/1.1,'linewidth',1,...
        'style','-','colorind',1,'text','off');hold on
    PlotFrame(EX(:,:,i),'scale',scale/1.5,'linewidth',1,...
        'style','-','colorind',3,'text','off');hold on   
    pp=plot3(fixture(1,:,i),fixture(2,:,i),fixture(3,:,i),...
        '-k','LineWidth',3); hold on
    pp.Color(4) = 0.2;
    PlotFrame(EXS(:,:,i),'scale',scale/1.5,'linewidth',1,...
        'style','-','colorind',2,'text','off');hold on
end
PlotFrame(eye(4),'scale',scale*1.2,'linewidth',2,'style','-',...
    'arrowsize',1/5,'colorind',1,'text','on','frameind','_{base}');hold on
PlotFrame(EXS_m,'scale',scale*1.2,'linewidth',1.5,'style','-',...
    'arrowsize',1/5,'colorind',2,'text','on','frameind','_{tag}');hold on

pt(1) = plot3(TH.tran(:,1),TH.tran(:,2),TH.tran(:,3),'*r','LineWidth',1);
hold on; % Plot Hand Frame
pt(2) = plot3(loc_camera(1,:),loc_camera(2,:),loc_camera(3,:),...
    '*b','LineWidth',1);hold on % Plot Camera Frame
pt(3) = plot3(loc_target(1,:),loc_target(2,:),loc_target(3,:),...
    '*k','LineWidth',1);hold on % Plot AR Tag

grid on; axis equal; xlabel('x'); ylabel('y'); zlabel('z')
legend(pt,{'F_{hand}','F_{camera}','F_{AR Tag}'})

set(f,'Units','normalized','Position',[0,0,1,1])
errm = err(:,1)'.*[1000,180/pi];
title({'Error for AR Tag Location (Compare to Mean Frame)',...
    sprintf('Error: %.2fmm / %.2fdeg',errm) })