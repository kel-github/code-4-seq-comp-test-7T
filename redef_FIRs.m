%% written by K. Garner, 2020
% redefine FIR regressors so that they are not orthogonalised within
% condition
% -------------------------------------------------------------------------------------------------------------
function [] = redef_FIRs(PLACE)
% PLACE = 'home' - where is your data?
% thrsh = threshold value (can be a single value or a percentage)
% thrsh_meth = 'p' - get values above the percentile, 't' = its a t stat so
% take above that value, 'none' = don't thrshold

switch PLACE
    case 'inode'
        %        data_dir = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmTDFAST/';
        spms = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/SPM.mat';
        addpath('/opt/ohpc/pub/apps/spm12/spm12');
        %addpath('/scratch/qbi/uqkgarn1/spm12');
end

TRs = {'700', '1510', '1920'};
subs = {'01', '02', '03', '04', '05'};

%% go through each subject x TR x ROI x contrast
for iSub = 1:length(subs)
    
    
    for iTR = 1:length(TRs) % go through each TR
        
        fprintf('redefining regressors for sub 0%s, TR %s \n', subs{iSub}, TRs{iTR});
        
        % get subjects SPM structure, and run function to redefine
        % regressor
        % overwrite SPM.mat file with new structure
        cf = sprintf(spms, subs{iSub}, TRs{iTR});
        SPM = load(cf);
        SPM = SPM.SPM;
        SPM = spm_fMRI_design_copy(SPM);
        save(cf, 'SPM');
        clear SPM
        
    end
    
end

end
