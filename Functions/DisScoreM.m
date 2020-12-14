function [ SimiScore ] = DisScoreM(A,B,TreeNode,TreeNodeMass,LCA,e)
% Calculating dissimilarity score between A and B over iTrees


n=size(TreeNode,2);
score=zeros(1,n);

for i=1:n       
    score(i)=TreeNodeMass(i,LCA(TreeNode(A,i),TreeNode(B,i)))^e;    
end
SimiScore=(mean(score))^(1/e);

end