% This script illustrates a contour of the scores produced by k-nearest
% neigbour anomaly detector using distance and m_e, as shown in Figure 8
% in the original paper.


% Please add the "Functrions" folder to search path before run this script


%% starting the parallel pool

parpool % (using 'matlabpool' for old Matlab version) 
% Please delete this section once you have started parallel pool

%% loading data
load('data.mat') % load a hard distribution data

F=1:1:1000;
k=100; % set k for KNN anomaly detector

%% anomaly score based on distance

[D,I] = pdist2(data,data,'euclidean','Smallest',k+1); % D is the distance matrix
FScore=D(k+1,:)';

[i,j]=sort(FScore); % rank instance anomaly score
ndata=data(j,:);

% plot contour
figure
scatter(ndata(:,1),ndata(:,2),10,F','filled')
box off
set(gcf,'color','w');
title('Contour based on distance');

%% anomaly score based on m_e (mass-based dissimilarity)

% Parameter settings for iForest
HeightLimit=8; % the height limit of each iTree, the subsample size = 2^HeightLimit
NumTree=100; % the number of iTrees
e=1; % 1 is average over each iTree (Arithmetic Mean)

% Calculating Dissimilarity Matrix
MassMatrix=meMatrix(data,NumTree,HeightLimit,e);  % MassMatrix is mass-based dissimilarity matrix

% MassMatrix can be used for various data mining tasks, here we only use it for KNN anomaly detection


% calculate KNN score
FScoreM=zeros(size(MassMatrix,1),1);
parfor i=1:size(MassMatrix,1)
    [D,index] = sort(MassMatrix(i,:),2,'ascend');
    FScore(i)=D(k+1);
end

[i,j]=sort(FScore);
ndata=data(j,:);

% plot contour
figure
scatter(ndata(:,1),ndata(:,2),10,F','filled')
box off
set(gcf,'color','w');
title('Contour based on m_e');

