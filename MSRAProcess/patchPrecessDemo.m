% patchPrecessDemo

clear all;

%% dirs and files
datasetName = 'MSRATD500';
testDataBase = fullfile('/home/lili/datasets/VOC/VOCdevkit', datasetName);
testListName = fullfile(testDataBase, 'ImageSets/Main/test.txt');
imgDir = fullfile(testDataBase,'JPEGImages');
[imgName] = textread(testListName,'%s');
ssdDir = '/home/lili/codes/ssd/caffe-ssd/data/';
dtDir = fullfile(ssdDir, datasetName, 'test_bb_big');

%% 
nImg = length(imgName);
for i = 1:nImg
    fprintf('%d:%s\n', i, imgName{i});
    dtFile = fullfile(dtDir, ['res_', imgName{i}, '.txt']);
    dtBox = importdata(dtFile); % x1, y1, x2, y2
    image = imread(fullfile(imgDir, [imgName{i}, '.jpg'])  );
    nDt = size(dtBox, 1);
    grayImg = rgb2gray(image);
    se = strel('disk', 5);
    for j = 1:nDt
        imPatch = grayImg(dtBox(j, 2):dtBox(j, 4), dtBox(j, 1):dtBox(j, 3), :);
        binaryPatch = im2bw(imPatch, graythresh(imPatch));
        closePatch = imclose(binaryPatch, se);
        imshow(closePatch);
    end
end
