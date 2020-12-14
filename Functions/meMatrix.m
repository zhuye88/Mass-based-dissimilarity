function [ Matrix,TreeNode,TreeNodeMass,LCA,Forest,Paras] = meMatrix( data,NumTree,HeightLimit,e)
% Calculating mass-based dissimilarity

disp('iTrees building...');
tic

Paras.NumTree=NumTree;
Paras.HeightLimit=HeightLimit;
Paras.NumSub=2^Paras.HeightLimit; %subsampling size
Paras.NumDim=size(data,2);


Forest = GenericArrayForest(Paras,data);
EstData = GenericArrayEstimation(data,Forest);
[EstData.Relationship,EstData.LCA] = GetCommonPathMatrixLCA(Paras.HeightLimit);

TreeNode= EstData.TreeNode;
TreeNodeMass=EstData.TreeNodeMass;
LCA=EstData.LCA;
toc
disp('iTrees complete...');

disp('Dissimilarity Matrix building...');
n=size(TreeNode,1);
Matrix=zeros(n,n);

tic

m=triu(true(size(TreeNode,1)),0);
[posc,posr]=find(m==1);
p=zeros(size(posc,1),1);

parfor k=1:size(posc,1)
    p(k)=DisScoreM(posc(k),posr(k),TreeNode,TreeNodeMass,LCA,e);
end

for k=1:size(posc,1)
    Matrix(posc(k),posr(k))=p(k);
end

Matrix=Matrix'+Matrix;
for i=1:n
    Matrix(i,i)=Matrix(i,i)/2;
end

Matrix=Matrix./(max(max(Matrix)));

toc
disp('Dissimilarity Matrix complete...');

end

