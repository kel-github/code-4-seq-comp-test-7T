%% Written by K. Garner 2021
% quality control 7T image data using UniQC toolbox functions
% for details of the toolbox, see: https://github.com/translationalneuromodeling/tapas/blob/master/UniQC/README.md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% add paths 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('/scratch/qbi/uqkgarn1/spm12/spm12')
addpath('/scratch/qbi/uqkgarn1/JSONio/')
% manually addpath('/scratch/qbi/uqkgarn1/UniQC')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% define path variables for reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%data_loc = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/';
data_loc = '/scratch/qbi/uqkgarn1/STRIWP1/';
%fstem = 'sub-0%s_ses-0%s_task-learnAtt_acq-TR%s*_space-T1w_desc-preproc_bold.nii.gz';
fstem = 'sub-0%s_ses-0%s_task-learnAtt_acq-TR%s*_bold.nii';
results_loc = '/scratch/qbi/uqkgarn1/qual-checks/';

sub_nums = 1:5;
ses_nums = 2:4;
TRs = [700, 1510, 1920];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% for each data set, load, display and save SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iSub = 1:length(sub_nums)
    
    for iSess = 1:length(ses_nums)
        
        for iTR = 1:length(TRs)
            
            % get sub codes and file list
            sub_str = num2str(sub_nums(iSub));
            ses_str = num2str(ses_nums(iSess));
            TR_str = num2str(TRs(iTR));
                                                               
            fs = dir(fullfile(data_loc, sprintf('sub-0%s', sub_str), ...
                                        sprintf('ses-0%s', ses_str), ...
                                        'func', ...
                                        sprintf(fstem, sub_str, ses_str, TR_str)));
            % loop through files and plot and save the tSNR plots
            for iF = 1:length(fs)
               
                I = MrImage([fs(iF).folder '/' fs(iF).name]);
                h = I.snr.plot('displayRange', [0 40]);
                
                snm = split(fs(iF).name, '.');
                % get file name for saving
                print(h, sprintf([results_loc, snm{1}], sub_str, ses_str, TR_str), '-dpdf', '-bestfit');
            end           
        end       
    end
end
%% for each data set, check mask overlays

%% for each data set and roi, plot snr as a histogram and save