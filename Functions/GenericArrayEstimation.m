function EstData = GenericArrayEstimation(Data,Forest)

EstData.NumInst = size(Data,1);
EstData.NumTree = Forest.NumTree;
EstData.NumberOfTreeNodes = Forest.NumberOfTreeNodes;

EstData.TreeNode = zeros(EstData.NumInst, Forest.NumTree);
EstData.TreeNodeMass = zeros(Forest.NumTree, Forest.NumberOfTreeNodes);


for k = 1:Forest.NumTree
    TreeNodeIndx = cell(Forest.Trees{k}.MaxNumberOfNodes,1);
    TreeNodeIndx{1} = (1:EstData.NumInst);
    TreeNodeMass = zeros(1,Forest.NumberOfTreeNodes);
    for node = 1:Forest.Trees{k}.MaxNumberOfNodes
        TreeNodeMass(1,node) = TreeNodeMass(1,node) + size(TreeNodeIndx{node},2);        
        EstData.TreeNodeMass(k,node) = TreeNodeMass(1,node);                
        if TreeNodeMass(1,node) == 0
            continue;
        end
        
        if Forest.Trees{k}.Nodes(node) > 0
            EstData.TreeNode(TreeNodeIndx{node},k) = node;
        else
            TreeNodeIndx{2*node} = TreeNodeIndx{node}(Data(TreeNodeIndx{node}, Forest.Trees{k}.SplitAttribute(node)) <  Forest.Trees{k}.SplitPoint(node));
            TreeNodeIndx{2*node + 1} = setdiff(TreeNodeIndx{node} , TreeNodeIndx{2*node});
        end
    end
end
end

