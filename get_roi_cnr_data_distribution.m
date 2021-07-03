%% written by K. Garner, 2020
% extracting CNR data from ROIs, extended from get_roi_cnr_data to pull out
% all the data rather than an average value
% -------------------------------------------------------------------------------------------------------------
function [] = get_roi_cnr_data_distribution(PLACE, save_name, thrsh, thrsh_meth, roi_exp)
% PLACE = 'home' - where is your data?
% save_name = what would you like the output csv file to be called?
% thrsh = threshold value (can be a single value or a percentage)
% thrsh_meth = 'p' - get values above the percentile, 't' = its a t stat so
% take above that value, 'none' = don't thrshold
% roi_exp = '_abs' or _tSNR'

switch PLACE
    case 'inode'
%        data_dir = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmTDFAST/';
        ims = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmTDFAST_HANDS/sub-%s/TR%s/THRSH/spmF*thresh.nii.gz';
end

TRs = {'700', '1510', '1920'};
subs = {'01', '02', '03', '04', '05'};
%cdir = pwd;

start_idx = 4; % from which letter to take the start of the ROI name (from the image
% file name)

if isempty(save_name)
    save_name = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmTDFAST_HANDS/HANDSs_tCNR_stat_vox_agg.csv';
end

fid=fopen(save_name, 'w');
fprintf(fid, '%s,%s,%s,%s,%s,%s\n', 'sub', 'TR', 'roi', 'contrast', 'tT', 'n');

%% go through each subject x TR x ROI x contrast
for iSub = 1:length(subs)
    fprintf('extracting thresh t-stat data for sub 0%s \n', subs{iSub});
    
    for iTR = 1:length(TRs) % go through each TR
        
        these_ims = dir(sprintf(ims, subs{iSub}, TRs{iTR}));
        
        for iIms = 1:length(these_ims)
            V = niftiread([these_ims(iIms).folder '/' these_ims(iIms).name]);
            V = abs(V);
            % now threshold the data if required
            switch thrsh_meth
                case 'none'
                   tmp=0;
                case 'p'    
                   tmp = prctile(V(V>0), thrsh, 'all');
                case 't'
                    tmp = thrsh;
            end
            n = sum(V>tmp, 'all');
            fprintf('extracting t-stat data: %d voxels for sub 0%s TR %s image %s\n', ...
                                            n, ...
                                            subs{iSub}, ...
                                            TRs{iTR}, ...
                                            these_ims(iIms).name);                                  
            tT = V(V>tmp);
            if isnan(tT)
                tT = 0;
            end
            
            % get the ROI name for the results file
            if strcmp(roi_exp, 'brain')
                ROI_str = 'brain';
            else                   
                ROIexp = roi_exp;        
                ROIidx = regexp(these_ims(iIms).name, ROIexp);
                ROI_str = these_ims(iIms).name(start_idx:(ROIidx-1));
            end
        
            % and the contrast number
            conexp = '_thresh';
            conidx = regexp(these_ims(iIms).name, conexp);
            con_str= [these_ims(iIms).name(conidx-2) these_ims(iIms).name(conidx-1)];
        
            % update the text file
            %sub_data = [subs{iSub}, TRs{iTR}, ROI_str, con_str, num2str(tT)];
            for iRow = 1:length(tT)
                fprintf(fid, '%s,%s,%s,%s,%s,%s\n', subs{iSub}, TRs{iTR}, ROI_str, con_str, num2str(tT(iRow)), num2str(n));
            end
        end
        
    end
end     
 fclose(fid); % close the data file       
            
    
