%
% GIMC: Graph-based Incomplete Multi-view Clustering
%%
clc;  close all; clear all;

%%========================================================================
%% settings (Choice method here)
%
runtimes = 1; % run-times on each dataset
choice_graph = 2; % 1: 'Complete', and 2: 'k-nearest'
choice_metric = 4; % 1: 'Binary', 2: 'Cosine', 3: 'Gaussina-kernel', and 4: 'Our-method'
lambda = 1; %  initial parameter, which is tuned automatically

%%
dataname = {'Yale','COIL20-1','ORL','leaves'};
numdata = length(dataname);

currentFolder = pwd;
addpath(genpath(currentFolder));
resultdir = 'Results/';
if(~exist('Results','file'))
    mkdir('Results');
    addpath(genpath('Results/'));
end


for cdata = 1:numdata
%% read dataset
disp(char(dataname(cdata)));
datadir = 'Dataset/';
dataf = [datadir, cell2mat(dataname(cdata))];
load(dataf);

% Incomplete Multi-view Construction
X = IMC(data);
y0 = truelabel{1};
c = length(unique(truelabel{1}));

%% iter ...
for rtimes = 1:runtimes
% Multi-view clustering method on graph-based system
[F, y, U, S0, evs, obj_value] = G_Cluster(X, c, choice_graph, choice_metric, lambda); % c: the # of clusters

acc=valid_CA(y,y0);
nmi=C_nmi(y0,y);
fprintf('...Runtime %d> ACC:%.4f\tNMI:%.4f\n',rtimes,acc,nmi);

end;

end;
