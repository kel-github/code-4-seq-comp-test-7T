function [info] = def_pars(PLACE, sub, TR)
%% written by K. Garner, 2020
% concept is to load the participant's .mat file, and identify specific
% information required for plotting the FIR params, including the number of
% parameters fit for each condition, which reflect onsets, and which follow
% the onset event

%%% INPUTS
% PLACE = where is your data? give the name of your data storage system to
% load the correct template file paths and to load library functions
% sub = which subject number? string of format '0N'
% TR = looking at data from which TR? in ms, string
% nsess = total number of sessions (aka runs)
% 

%% start here by defining path parameters
switch PLACE
    case 'inode'
        spms = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/SPM.mat';
        dat =  '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/';
        addpath('/opt/ohpc/pub/apps/spm12')
end

%% load the spm glm info
cf = sprintf(spms, sub, TR);
SPM = load(cf);
SPM = SPM.SPM;

%% get the relevant beta images for each session and condition
% the idea here is to pattern match to the regressor names stored in the
% participant's SPM matrix to get indexes of the beta images that denote
% session [1:nsess], and condition [1:ncond]

% first get some relevant info from the SPM intel
nsess = size(SPM.Sess, 2); 
conds = [];
for iConds = 1:size(SPM.Sess(1).U,2)
    conds = [conds, SPM.Sess(1).U(iConds).name];
end
regs = SPM.xX.name; % get the regressor names
nregs = size(regs, 2);
sidx = zeros(1, size(regs,2));
cidx = sidx;
% now loop through sessions and regressors to build the index for which
% session a given beta image refers to
for iSess = 1:nsess
    for iReg = 1:nregs
        if any(regexp(regs{iReg}, sprintf('Sn(%d', iSess))) 
            sidx(iReg) = iSess;
        end
    end
end
% now do the same for the condition names
for iConds = 1:size(conds,2)
   for iReg = 1:nregs
       if any(regexp(regs{iReg}, conds{iConds}))
           cidx(iReg) = iConds;
       end
   end
end

%% basis function info
% by taking the length of the basis function and the order of the basis set, we can compute which
% FIR parameter subsequent to an event csonstitutes the point of the
% expected peak (4-6 seconds)
BF = SPM.xBF;
length = BF.length; % length of basis function in seconds
order = BF.order; % order of basis set - aka length is split into n [order] parameters
p = length/order; % each param lasts t = p
peak_ps = 4/p: 6/p; % these n of order params are the ones that should correspond to the peak

%% collate into an info structure for returning from the function
info.peaks = peak_ps;
info.conds = cidx;
info.sessions = sidx;
info.sub = sub;
info.TR = TR;

end