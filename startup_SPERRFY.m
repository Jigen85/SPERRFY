% startup.m
projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(projectRoot, 'src')));
addpath(genpath(fullfile(projectRoot, 'data')));
disp('Paths set. Ready to run SPERRFY.');