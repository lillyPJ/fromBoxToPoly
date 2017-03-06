% adjustBoxBoundDemo
clear all;

%% dirs and files
datasetName = 'MSRATD500';
testDataBase = fullfile('/home/lili/datasets/VOC/VOCdevkit', datasetName);
testListName = fullfile(testDataBase, 'ImageSets/Main/test.txt');
imgDir = fullfile(testDataBase,'JPEGImages');
[imgName] = textread(testListName,'%s');
ssdDir = '/home/lili/codes/ssd/caffe-ssd/data/';
oriDtDir = fullfile(ssdDir, datasetName, 'test_bb');
destDtDir = fullfile(ssdDir, datasetName, 'test_bb_big');
mkdir(destDtDir);
%% process each image
nImg = length(imgName);
for i = 1: nImg
    fprintf('%d:%s\n', i, imgName{i});
    oriDtFile = fullfile(oriDtDir, ['res_', imgName{i}, '.txt']);
    dtBox = importdata(oriDtFile);
    if ~isempty(dtBox)
        dtBox(:, 3) = dtBox(:, 3) - dtBox(:, 1);
        dtBox(: ,4) = dtBox(:, 4) - dtBox(:, 2);
    end
    image = imread(fullfile(imgDir, [imgName{i}, '.jpg']));
    newBox = adjustBoxPercent(dtBox);
    [imgH, imgW, D] = size(image);
    newBox = checkBoxBound(newBox, imgW, imgH);
    if ~isempty(newBox)
        newBox(:, 3) = newBox(:, 3) + newBox(:, 1);
        newBox(:, 4) = newBox(:, 4) + newBox(:, 2);
    end
    % save to destDtFile
    destDtFile = fullfile(destDtDir, ['res_', imgName{i}, '.txt']);
    fp = fopen(destDtFile, 'wt');
    fprintf(fp, '%d,%d,%d,%d,%f\n', newBox'); %x1, y1, x2, y2
    fclose(fp);
    % show
    
%     imshow(image);
%     displayBox(dtBox);
%     displayBox(newBox, 'b');
end