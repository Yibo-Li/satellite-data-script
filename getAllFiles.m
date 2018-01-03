function fileList = getAllFiles(dirName)
% Get all files in directory named dirName
% parameters:
%   dirName - directory name
% return:
%   fileList - filename list

% Updated by Yibo Li in 2018-1-13

% Get the data for the current directory
dirData = dir(dirName);
% Find the index for directories
dirIndex = [dirData.isdir];
% Get a list of the files
fileList = {dirData(~dirIndex).name}';
% Prepend path to files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x), ...
        fileList, 'UniformOutput', false);
end
% Get a list of the subdirectories
subDirs = {dirData(dirIndex).name};
% Find index of subdirectories that are not '.' or '..'
validIndex = ~ismember(subDirs,{'.','..'});
% Loop over valid subdirectories
for iDir = find(validIndex)
    % Get the subdirectory path
    nextDir = fullfile(dirName,subDirs{iDir});
    % Recursively call getAllFiles
    fileList = [fileList; getAllFiles(nextDir)];
end
