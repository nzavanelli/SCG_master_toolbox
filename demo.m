close all
warning off
clear

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

%% Load Data

T1 = readtable('scg_data.csv'); %Read CSV of data
T1Arr = table2array(T1); %Break into arrays
%Create individual arrays
tm = T1Arr(:,1); %time
ax = T1Arr(:,2); % x acc
ay = T1Arr(:,3); % y acc
az = T1Arr(:,4); % z acc
%Set sampling rate
Fs = 250;
% Get rid of any infintie or nan values
ind = find(isfinite(az));
az = az(ind);
ay = ay(ind);
ax = ax(ind);
tm = tm(ind);
ind = isnan(az);
az = az(~ind);
az = az(~ind);
ax = ax(~ind);
tm = tm(~ind);

%% Section to look at
ax = ax(1:5.5e5);
ay = ay(1:5.5e5);
az = az(1:5.5e5);
tm = tm(1:5.5e5);

%% Filter
cutoff = [4 20]; %BPF for SCG
[bh, ah] = butter(4, cutoff*2/Fs, 'bandpass');
ax_f = filtfilt(bh, ah, ax);
ay_f = filtfilt(bh, ah, ay);
az_f = filtfilt(bh, ah, az);

%resperation
cutoff = [0.01 0.4]; %BPF for PPG
Fs = 250;
[bh, ah] = butter(1, cutoff*2/Fs, 'bandpass');
resp = filtfilt(bh, ah, az);

%% Plot Signals

figure %SCG signals
plot(tm, az)
title('Raw Dorsoventricular SCG Signal (Z)')
xlabel('Time (s)')
ylabel('G force (m/s2)')

figure %SCG signals
plot(tm, az_f)
title('Filtered Dorsoventricular SCG Signal (Z)')
xlabel('Time (s)')
ylabel('G force (m/s2)')

figure %SCG signals
plot(tm, resp)
title('Filtered Respiratory Signal (Z)')
xlabel('Time (s)')
ylabel('G force (m/s2)')


%% Ensemble averaging

% Ensemble average for the entire time period
[mean_scg, sdSCG, SCGar,t] = segment_scg(az_f, Fs,0);

figure
plot(t,mean_scg,'b');
hold on
plotFillAlpha(t,mean_scg,sdSCG,'r',0.2);
ylabel('AU')
title('Ensembled SCG Signals')
set(gcf,'color','w');
set(gca,'FontSize',10);
box on;

% Ensemble average for a random window
[mean_scg, sdSCG, temp, t] = segment_scg(az_f(1e5:1e5+7500), Fs,1);
ylabel('AU')
xlabel('Time (s)')
title('Ensembled SCG Signals')
set(gcf,'color','w');
set(gca,'FontSize',10);

figure
plot(t,mean_scg,'b');
hold on
plotFillAlpha(t,mean_scg,sdSCG,'r',0.2);
ylabel('AU')
title('Ensembled SCG Signals')
set(gcf,'color','w');
set(gca,'FontSize',10);
box on;

%% Template beat generation

[meanTemplate] = gen_template(az_f, SCGar,Fs, 1);

%% array of SCG beats based on difference from template

[beatAvs] = diff_array(meanTemplate, az_f, SCGar, Fs, 2);

%% Create waterfall plot

[scg_reform] = scg_wfall(az_f(1e5:1e5+7500), SCGar,Fs, 1, 10, 12);

%% Generate  advanced features

% d is a matrix of the SCGarray repeated 6 times
d = [];
for w = 1:length(beatAvs(1,:))
        d = [d, repmat(beatAvs(:,w)-meanTemplate,6,1)];
end
d = d';

% paramaters for the feature models
timeWindow = 460;
ARorder = 4;
MODWPTlevel = 4;

[fts,temp, featureindices] = ...
    helperExtractFeatures(d,d,timeWindow,ARorder,MODWPTlevel);

% Plot the singularity spectrum for two different beats, here 10 and 15
figure
[dh1,h1,cp1, tauq1] = dwtleader(d(10,:));
plot(h1,dh1,'b-o', 'linewidth', 3) 

title({'Singularity Spectrum'; ['First Cumulant ' num2str(cp1(1))]})
hold on
[dh2,h2,cp2, tauq2] = dwtleader(d(15,:));
plot(h2,dh2,'r-^', 'linewidth', 3) 
set(gcf,'color','w');

title({'Singularity Spectrum'; ['First Cumulant ' num2str(cp2(1))]})
legend('Beat 1','Beat 2')

% 
figure
plot(-5:5,tauq1,'b-o',-5:5,tauq2,'r-^', 'linewidth', 3)
hold on
title('Scaling Coefficient Comparison')
set(gcf,'color','w');
legend('Beat 1','Beat 2')
