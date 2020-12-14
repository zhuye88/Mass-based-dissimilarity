function Forest = GenericArrayForest(Paras,Data)
% Generating axis-parallel spit iForest
Forest.Trees = cell(Paras.NumTree, 1);

Forest.NumInst = size(Data,1);
Forest.DimInst = size(Data,2);
Forest.generated_trees = 0;
Forest.NumberOfTreeNodes = (2^(Paras.HeightLimit + 1)) - 1;
Paras.NumberOfTreeNodes = Forest.NumberOfTreeNodes;

tree = 0;

if Paras.NumSub > size(Data,1)
    Paras.NumSub=size(Data,1);
end

rng('shuffle','multFibonacci')
while tree < Paras.NumTree
    tree = tree + 1;
    Forest.generated_trees = Forest.generated_trees + 1;
    CurtIndex=datasample(1:Forest.NumInst,Paras.NumSub,'Replace',false);
    TreeData = Data(CurtIndex,:);    
    Forest.Trees{tree} = GenericArrayTree(CurtIndex,TreeData,Paras);    
    %    disp (strcat('tree created',num2str(tree)));
    
end
Forest.NumTree = tree;

end
