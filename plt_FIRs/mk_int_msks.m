function info = mk_int_msks(PLACE, info)
%% written by K.Garner, 2020
% make masks that are the intersection of the anatomical and the
% distribution of the mean peak info

% idea of this function is to take the peaks image, and iterate through
% masks (anatomical), for each brain region the distribution of mean peak
% values is selected, and is then segmented according to x criteria. These
% criteria are then used to make n new mask files.

% inputs
% PLACE = where is your data? give the name of your data storage system to
% load the correct template file paths and to load library functions
% info = the information structure generated by mu_images.m (see in this
% folder) 

%% start here by defining path parameters et al
switch PLACE
    case 'inode'
        %spms = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/SPM.mat';
        dat =  '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glmFIR/sub-%s/TR%s/FLGLM/PARAMS/';
        msks = '/scratch/qbi/uqkgarn1/STRIWP1/derivatives/glm/sub-%s/TR%s/MASKS/';
        addpath('/scratch/qbi/uqkgarn1/spm12/spm12')
end

peaks = info.mupeak;
sub = info.sub;
TR = info.TR;

%% get list of masks
ms = dir([sprintf(msks, sub, TR), '*.nii.gz']); %

%% for each mask, create new masks that are the intersection of relation to the peak, 
% and the anatomical mask
% while troubleshooting, read in the volume data and plot a density
% first unzip the peaks file
p = gunzip(peaks);
p = p{1};
p = spm_vol(p); % make a structure that leads with the peak image
verbose = 1; % plot densities of peaks in each region?

for iMs = 1:length(ms)
    
    %% get the mask name
    msfn = [ms(iMs).folder, '/', ms(iMs).name];
    m = gunzip(msfn);
    m = m{1};
     % read in the two images, and make a new image that is the
     % intersection of the two    
    p(2) = spm_vol(m);
    
    %% now mask p(1)
    f = 'i1.*i2';
    flg.dtype = 16; % to keep data as single, see spm_type
    out_file = [sprintf(dat, sub, TR) 'tmp.nii'];
    t = spm_imcalc(p, out_file, f, flg); 
    V = niftiread(t.fname);
    V = V(~isnan(V)&V>0);    
    reg = regexp(ms(iMs).name, '_');
    if verbose % then print a histogram of the values in the ROI
        h = figure;
        histogram(V);       
        print(h, [sprintf(dat, sub, TR), ms(iMs).name(1:(reg-1)) '_peaks'], '-dpdf');
        clf('reset');
        close(gcf);
    end
    
    %% now compute the 33rd and 66th prctiles
    criteria = prctile(V, [33, 66]);
    
    % and now make the mask image for each third of peak data
    f = {sprintf('(i1<%.2f).*i2', min(criteria)),...
         sprintf('(i1>%.2f).*(i1<%.2f).*i2', min(criteria), max(criteria)),...
         sprintf('(i1>%.2f).*i2', max(criteria))};
    
    for iF = 1:length(f)
        % first print the output name
        oname = [sprintf(dat, sub, TR), ms(iMs).name(1:(reg-1)), sprintf('_%d.nii', iF)];
        outims(iF) = spm_imcalc(p, oname, f{iF}, flg);
        gzip(oname);
        delete(oname);
        info.betamsks(iMs).name(iF).crits = [oname, '.gz'];
    end
    %% clean up
    clear V;
    % now remove .nii files
    msnii = dir([sprintf(msks, sub, TR), '*.nii']);
    delete([msnii.folder '/' msnii.name]);
    delete([sprintf(dat, sub, TR), 'tmp.nii']);   
    
end 
% don't forget to delete peaks *.nii file!
delete(peaks(1:end-3));

end


