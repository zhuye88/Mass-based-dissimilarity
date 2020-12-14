function Tree = GenericArrayTree(CurtIndex,TreeData,Paras)

Tree.MaxNumberOfNodes = Paras.NumberOfTreeNodes;

Tree.SplitAttribute = zeros(Tree.MaxNumberOfNodes,1);
Tree.SplitPoint = zeros(Tree.MaxNumberOfNodes,1);
Tree.TerminationMatix = zeros(Paras.NumSub,1);
Tree.MaxMass = 0;

Tree.Nodes = zeros(Tree.MaxNumberOfNodes,1);
Tree.Nodes(1) = Paras.NumSub;

Tree.DataDistribution = cell(Tree.MaxNumberOfNodes,1);
Tree.DataDistribution{1} = (1:Paras.NumSub);

for node = 1:Tree.MaxNumberOfNodes
    height = floor(log2(node));
    if Tree.Nodes(node) <= 1 || height == Paras.HeightLimit
        if Tree.Nodes(node) > 0
 
            if height == Paras.HeightLimit
                Tree.TerminationMatix(Tree.Nodes(node) + 1) = Tree.TerminationMatix(Tree.Nodes(node) + 1) + 1;
            else
                Tree.TerminationMatix(1) = Tree.TerminationMatix(1) + 1;
            end
 
            if Tree.MaxMass < Tree.Nodes(node)
                Tree.MaxMass = Tree.Nodes(node);
            end
            Tree.DataDistribution{node} = CurtIndex(Tree.DataDistribution{node});
        end
        continue;
    end
    
    %% Split Attribute Selection
    attempts = 0;
    data_diff = 0;
    
    while attempts < 10
        
        Tree.SplitAttribute(node) = randi(Paras.NumDim);
        CurtData = TreeData(Tree.DataDistribution{node}, Tree.SplitAttribute(node));
        attempts = attempts + 1;
        
        %% Split Point Selection
        
        data_diff = max(CurtData) - min(CurtData);
        
        if data_diff >= 0.0000000000000001
            attempts = 10;
        end
        Tree.SplitPoint(node) = min(CurtData) + data_diff * rand(1); % Random       
        
    end
    if data_diff < 0.0000000000000001
        continue;  % if cannot split
    end
    
    %%
    LeftChild = node * 2;
    RightChild = LeftChild + 1;
    
    Tree.DataDistribution{LeftChild} = Tree.DataDistribution{node}(CurtData < Tree.SplitPoint(node));
    Tree.Nodes(LeftChild) = size (Tree.DataDistribution{LeftChild},2);
    
    Tree.DataDistribution{RightChild} = setdiff(Tree.DataDistribution{node}, Tree.DataDistribution{LeftChild});
    Tree.Nodes(RightChild) = size (Tree.DataDistribution{RightChild},2);
    
    Tree.Nodes(node) = 0;
    Tree.DataDistribution{node} = [];
end
 