% testShowBoxDemo
CASE = 'train'; % choose test or train
%% dirs
dataBase = fullfile('datasets', 'MSRATD500');
imgDir = fullfile(dataBase, 'img', CASE);
gtDir = fullfile(dataBase, 'gt', CASE, 'txt');

%% show each image
imgFiles = dir(fullfile(imgDir, '*.jpg'));
nImg = numel(imgFiles);
for i = 1:nImg
    % read image and gt file
    imgName = imgFiles(i).name;
    fprintf('%d:%s\n', i, imgName);
    image = imread(fullfile(imgDir, imgName));
    gtFile = fullfile(gtDir, [imgName(1:end-3), 'txt']);
    box = loadGTFromTxtFile(gtFile);
    % show image and gt
    imshow(image);
    displayBox(box);
end
    