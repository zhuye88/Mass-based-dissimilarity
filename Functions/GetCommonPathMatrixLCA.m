function [Relationship,LCA] = GetCommonPathMatrixLCA( DepthLimit )
% Finding the smallest region covering different instances
 

NoOfNodes = (2^(DepthLimit + 1)) - 1 ;
Relationship = zeros(NoOfNodes);
LCA = ones(NoOfNodes);

for i = 1:NoOfNodes
    for j = 1:i        
        if (i==j)
            Relationship(i,j) = floor(log2(i));
            LCA(i,j) = i;
            continue;
        end
        height_i = floor(log2(i));
        height_j = floor(log2(j));        
        root_j = j;
        root_i = i;
        if(height_i ~= height_j)            
            root_i = floor(i /(2 ^(height_i - height_j)));
        end
        
        while root_i > 1 
            if (root_i == root_j)
                Relationship(i,j) = floor(log2(root_i));                
                Relationship(j,i) = Relationship(i,j);  
                LCA(i,j) = root_i;
                LCA(j,i) = LCA(i,j);
                break;
            end
            root_i = floor(root_i/2);
            root_j = floor(root_j/2);
        end
        
    end
end


end

