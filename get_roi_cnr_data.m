%% written by K. Garner, 2020
% extracting CNR data from ROIs using spm functionality
% -------------------------------------------------------------------------------------------------------------
function [] = get_roi_cnr_data(PLACE)
% PLACE = 'home'

%% define path and session variables
switch PLACE
    case 'home'       
        addpath('~/Documents/MATLAB/spm12');
    case 'qubes'
        addpath('/home/kgarner/Documents/MATLAB/spm12');
    case 'psych'    
        addpath('/home/kellygarner/Documents/spm12');
end

% file info
data_dir = '~/Dropbox/MC-Projects/imaging-value-cert-att/striwp1/CNR-data/';
TRs = {'700', '1510', '1920'};
subs = {'01', '02', '03', '04', '05'};
cdir = pwd;

% open text file to collect data
save_name = '~/Dropbox/MC-Projects/imaging-value-cert-att/striwp1/CNR-data/CNR_aggregated.csv';
fid=fopen(save_name, 'w');
fprintf(fid, '%s,%s,%s,%s,%s\n', 'sub', 'TR', 'roi', 'contrast', 'R');

%% go through each subject x TR x ROI x contrast
for iSub = 1:length(subs)
    
    fprintf('extracting CNR data for sub 0%s \n', subs{iSub});
    
    for iTR = 1:length(TRs)
        
        % navigate to participant's folder
        cd(sprintf([data_dir 'sub-%s/TR%s/'], subs{iSub}, TRs{iTR}));
        
        [masks, CNRs] = unzip_files; % get the list of mask and CNR files for that sub
        % for each CNR and mask, first get the xyz coordinates of the mask,
        % and then use that info to extract the required info from the CNR
        % files
        for iMasks = 1:length(masks)
            xyz = get_roi_xyz(masks(iMasks)); % get co-ordinates
            for iContrasts = 1:length(CNRs)
                R = get_RMS(CNRs(iContrasts), xyz);
                % print data to results file
                sub_data = [str2num(subs{iSub}), str2num(TRs{iTR}), iMasks, iContrasts, R];
                fprintf(fid, '%d,%d,%d,%d,%f\n', sub_data);
            end
        end
       % delete files that were unzipped for the operation
       delete('*.nii');
       delete('CNR/*.nii');
    end 
    cd(cdir);
    
end

fclose(fid); % close the data file


    function [masks, CNRs] = unzip_files()
        % unzip the mask files
        gunzip('MASKS/*.gz');
        % get the list of masks
        masks = dir('MASKS/*.nii');
        
        % gunzip and get the list of CNR files
        gunzip('FLGLM/CNR_*.gz');
        CNRs = dir('FLGLM/CNR_*.nii');
    end

    function [xyz] = get_roi_xyz(mask_info)
        volInf = spm_vol([mask_info.folder '/' mask_info.name]);
        Y = spm_read_vols(volInf, 1);
        idx = find(Y > 0);
        [x, y, z] = ind2sub(size(Y), idx);
        xyz = [x y z]';
    end

    function [R] = get_RMS(CNR_info, xyz)
        Y = spm_get_data([CNR_info.folder '/' CNR_info.name], xyz);
        Y = mean(Y.^2);
        R = sqrt(Y);
    end

end

