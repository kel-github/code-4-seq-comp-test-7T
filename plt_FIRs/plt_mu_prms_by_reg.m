function info = plt_mu_prms_by_reg(PLACE, info)
%% written by K.Garner, 2020
% for each region, extract the 3 parameter x voxels x condition matrices
% (one for each third of the data)
% plot the mean response across voxels along the time dimension, to examine
% the HRF, with one line per condition

% inputs
% PLACE = where is your data? give the name of your data storage system to
% load the correct template file paths and to load library functions
% info = the information structure generated by mk_int_msks.m (see in this
% folder)

%% set paths and define variables

switch PLACE
    case 'inode'
        %spms = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/SPM.mat';
        datloc =  '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/PARAMS/';
        addpath('/scratch/qbi/uqkgarn1/spm12/spm12')
end

sub = info.sub;
TR = info.TR;
betamsks = info.betamsks; % where the data is stored
nreg = length(betamsks);
ndiv = length(betamsks(1).name);
order = length(info.muparams)/2;

% plotting variables:
ncol = ndiv; % one for each third of the data
nrow = 1; % one for each condition
sup_title_tex = 'sub-%s-TR-%s-reg-%s-mu';
x=2:2:(order*2);

%% create plots for each region
for iReg = 1:nreg
    for iDiv = 1:ndiv
        
        if iDiv == 1 % then get the string ID for the region
            ssidx = regexp(betamsks(iReg).name(iDiv).crits, 'r[A-Z]');
            esidx = regexp(betamsks(iReg).name(iDiv).crits, '_1');
            reg_str = betamsks(iReg).name(iDiv).crits((ssidx+1):(esidx-1));
        end
        
        % now get the data
        tmp = betamsks(iReg).name(iDiv).dat;
        subplot(nrow, ncol, iDiv) 
        plot(x, mean(squeeze(tmp(:,:,1)),1)');        
        hold on
        plot(x, mean(squeeze(tmp(:,:,2)),1)');        
        legend('tgt l','tgt r');           
    end
    suptitle(sprintf(sup_title_tex, sub, TR, reg_str));
    print(sprintf([datloc, sup_title_tex '.pdf'], sub, TR, sub, TR, reg_str), '-dpdf', '-fillpage');
    clf('reset');
    close(gcf);
end