function label = affineOrientation_old( affMatrix )
%THIS CODE IS FAULTY, AS DEMONSTRATED WITH THIS TEST:
% % function affineFcnTest
% % %test MRIcroS affineOrientation function
% % %  https://github.com/nipy/nibabel/blob/master/nibabel/orientations.py
% % %To generate datasets to test the TrackVis.org DiffusionToolkit
% % %  https://github.com/neurolabusc/spmScripts/blob/master/nii_makeDTI.m
% % 
% % mtx= [3 0 0 -12; 0 3 0 -12; 0 0 3 -12; 0 0 0 1]; %RAS, created with nii_makeDTI
% % testSub(mtx);
% % mtx = [0 3 0 -12; 3 0 0 -12; 0 0 3 -12; 0 0 0 1]; %ARS, created with nii_makeDTI(1)
% % testSub(mtx);
% % mtx = [-3 0 0 12; 0 3 0 -12; 0 0 3 -12; 0 0 0 1]; %LAS, created with nii_makeDTI(2)
% % testSub(mtx);
% % mtx = [0 3 0 -12; 0 0 3 -12; 3 0 0 -12; 0 0 0 1]; %SRA, created with nii_makeDTI(3)
% % testSub(mtx);
% % mtx = eye(4);
% % testSub(mtx);
% % mtx(1,1) = -1;
% % testSub(mtx);
% % mtx = [0 1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1];
% % testSub(mtx);
% % mtx = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1];
% % testSub(mtx);
% % mtx = [0 0 1 0; 0 1 0 0; 1 0 0 0; 0 0 0 1];
% % testSub(mtx);
% % mtx = [0 0 1 0; 0 2 0 0; -3 0 0 0; 0 0 0 1];
% % testSub(mtx);
% % %end affineFcnTest()
% % 
% % function testSub(mtx)
% % old = utils.trk.affineOrientation(mtx); %OK: RAS
% % new = affineOrientationSub(mtx);
% % fprintf('vox_to_ras = [%g %g %g %g; %g %g %g %g; %g %g %g %g; 0 0 0 1]\n',...
% %     mtx(1,1), mtx(1,2), mtx(1,3), mtx(1,4),...
% %     mtx(2,1), mtx(2,2), mtx(2,3), mtx(1,4),...
% %     mtx(3,1), mtx(3,2), mtx(3,3), mtx(1,4));
% % vox = [0 1 2];
% % RASmm = [vox 1] * mtx';
% % fprintf('vox = [%g %g %g]; RASmm=[%g %g %g]; %%vx * vox_to_ras''\n',...
% %      vox(1), vox(2), vox(3), ...
% %      RASmm(1), RASmm(2), RASmm(3));
% %  
% % if ~isempty(find(old ~= new))
% %     fprintf(' !!!!ERROR %s ~= %s\n', old, new);
% % else
% %     fprintf(' %s == %s\n', old, new);
% % end
% % %end testSub

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
