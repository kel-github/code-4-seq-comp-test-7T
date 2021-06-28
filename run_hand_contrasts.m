%% run hand contrasts 
% written by K. Garner 
% note that the use of run_contrasts_job.m allows you to run N=3 contrasts
% only!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define path things
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('/scratch/qbi/uqkgarn1/spm12/spm12')
jobfile = {'/scratch/qbi/uqkgarn1/hand_contrasts_job.m'};
jobs = repmat(jobfile, 1, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define subject things
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subs = [1, 2, 3, 4, 5];
TRs = [700, 1510, 1920];
glmFolder = 'glmTDFAST_HANDS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run contrasts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputs = cell(1, 1);

for iSub = 1:length(subs)
    for iTR = 1:length(TRs)
        
        inputs{1,1} = {sprintf(['/scratch/qbi/uqkgarn1/STRIWP1/derivatives/', glmFolder, '/sub-0%d/TR%d/FLGLM/SPM.mat'], subs(iSub), TRs(iTR))};        
        spm('defaults', 'FMRI');
        spm_jobman('run', jobs, inputs{:});
    end
end

