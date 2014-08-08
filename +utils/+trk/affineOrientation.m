function label = affineOrientation( affMatrix )
%function label = affineOrientation( affMatrix )
%   returns implied label (LPS, LAS, etc...)  based on affMatrix
%   Code based on nibabel orientations 
%   https://github.com/nipy/nibabel/blob/master/nibabel/orientations.py
    
    [q, p] = size(affMatrix);
    q = q - 1;
    p = p - 1;
    
    rzs = affMatrix(1:q, 1:p);
    
    zooms = sqrt(sum(rzs.^2));
    zooms(zooms == 0) = 1;
    
    rs = zeros(size(rzs));
    rows = length(zooms);
    for i =1: rows
        rs(i,:) = rzs(i,:)./zooms;
    end
    
    [P, S, Q] = svd(rs);
    Qs = Q';
    
    R = P * Qs;
    
    orientation = zeros(p,2) * NaN;
    for i =1:p
        col = R(:,i);
        if(sum(abs(col)) == 0)
            return;
        else
            [~, maxRow] = max(abs(col));
            orientation(i) = sign(col(maxRow));
            R(maxRow, :) = 0;
        end
    end
        
    lpi = 'LPI';
    ras = 'RAS';
    label = '';
    
    for i = 1:length(orientation)
        direction = orientation(i);
        if(direction == -1)
            label = strcat(label, lpi(i));
        else
            label = strcat(label, ras(i));
        end
    end
end
