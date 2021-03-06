
%% Add path

if isunix
    addpath /network/lustre/iss01/charpier/analyses/stephen.whitmarsh/EpiCode/projects/hspike/
    addpath /network/lustre/iss01/charpier/analyses/stephen.whitmarsh/EpiCode/shared/
    addpath /network/lustre/iss01/charpier/analyses/stephen.whitmarsh/EpiCode/external/
    addpath /network/lustre/iss01/charpier/analyses/stephen.whitmarsh/EpiCode/external/fieldtrip/
    addpath /network/lustre/iss01/charpier/analyses/stephen.whitmarsh/fieldtrip
    addpath(genpath('/network/lustre/iss01/charpier/analyses/stephen.whitmarsh/scripts/releaseDec2015/'));
    addpath(genpath('/network/lustre/iss01/charpier/analyses/stephen.whitmarsh/epishare-master'));
end

if ispc
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\EpiCode\projects\hspike
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\EpiCode\shared
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\EpiCode\external
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\EpiCode\external\fieldtrip\  
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\fieldtrip
    addpath \\lexport\iss01.charpier\analyses\stephen.whitmarsh\MatlabImportExport_v6.0.0 % to read neuralynx files faster
    addpath(genpath('\\lexport\iss01.charpier\analyses\stephen.whitmarsh\epishare-master'));
end

%% config

% set data directory
datasavedir     = '\\lexport\iss01.charpier\analyses\stephen.whitmarsh\data\dcx';
imagesavedir    = '\\lexport\iss01.charpier\analyses\stephen.whitmarsh\images\dcx';

% set filename
fname_rl        = 'Pat_2_T6EEG_3_VIS';

% read ripplelab data
[dat, tbl]      = readRippleLab(fullfile(datasavedir,[fname_rl '.rhfe'])); % dat = fieldtrip data structure, tbl = matlab table

% write results to xls file
writetable(tbl,fullfile(datasavedir,[fname_rl,'.xls']));

% remove label field and replace with a single one (the one you used)
dat             = rmfield(dat,'label');
dat.label{1}    = 'T6';

% TFR analysis 
cfg             = [];
cfg.output      = 'pow';
cfg.channel     = 'all';
cfg.method      = 'mtmconvol';
cfg.taper       = 'hanning';
cfg.pad         = 'nextpow2';
cfg.foi         = 1:1:100;                         % try with steps of 1 hertz:
cfg.t_ftimwin   = 7./cfg.foi;                       % 7 cycles per time window, can try with 5
cfg.toi         = 'all';
TFR             = ft_freqanalysis(cfg,dat);

% plot timecourses
fig             = figure; 
cfg             = [];
cfg.trials      = 2; % average by defining cfg.trials = 'all' 
ft_singleplotER(cfg, dat);

% print to file
set(fig,'PaperOrientation','landscape');
set(fig,'PaperUnits','normalized');
set(fig,'PaperPosition', [0 0 1 1]);
print(fig, '-dpdf', fullfile(imagesavedir,['fname_rl','_avg.pdf']));
print(fig, '-dpng', fullfile(imagesavedir,['fname_rl','_avg.png']),'-r300');

                
fig = figure; 

% plot TFR relative baseline
subplot(2,1,1);
cfg = [];
cfg.trials = 'all'; % average by defining cfg.trials = 'all' 
cfg.baseline = [-1 1];
cfg.baselinetype = 'relative';
cfg.zlim = 'absmax';
ft_singleplotTFR(cfg, TFR);

% plot TFR absolute baseline 
subplot(2,1,2);
cfg = [];
cfg.trials = 'all'; % average by defining cfg.trials = 'all' 
cfg.zlim = 'maxmin';
ft_singleplotTFR(cfg, TFR);

% print to file
set(fig,'PaperOrientation','landscape');
set(fig,'PaperUnits','normalized');
set(fig,'PaperPosition', [0 0 1 1]);
print(fig, '-dpdf', fullfile(imagesavedir,['fname_rl','_TFR.pdf']));
print(fig, '-dpng', fullfile(imagesavedir,['fname_rl','_TFR.png']),'-r300');

