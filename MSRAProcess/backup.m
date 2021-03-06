% showMultiAngleDtDemo

clear all;

%% dirs and files
datasetName = 'MSRATD500';
testDataBase = fullfile('/home/lili/datasets/VOC/VOCdevkit', datasetName);
testListName = fullfile(testDataBase, 'ImageSets/Main/test.txt');
imgDir = fullfile(testDataBase,'JPEGImages');
[imgName] = textread(testListName,'%s');
ssdDir = '/home/lili/codes/ssd/caffe-ssd/data/';
dtDir = fullfile(ssdDir, datasetName, 'test_bb');

nImg = length(imgName);
for i = 1:nImg
%     if i < 4
%         continue;
%     end
%         if ~strcmp(imgName{i}, 'IMG_0607')
%             continue;
%         end
    fprintf('%d:%s\n', i, imgName{i});
    dtFile = fullfile(dtDir, ['res_', imgName{i}, '.txt']);
    dtBox = importdata(dtFile); % x1, y1, x2, y2
    if ~isempty(dtBox)
        dtBox(:, 3) = dtBox(:, 3) - dtBox(:, 1);
        dtBox(:, 4) = dtBox(:, 4) - dtBox(:, 2);
    end
    image = imread(fullfile(imgDir, [imgName{i}, '.jpg'])  );
    nDt = size(dtBox, 1);
    [imgH, imgW, D] = size(image);
    
    %% get polys and angleBoxes
    polys = zeros(nDt, 8);
    centerAngleBoxes = zeros(nDt, 5);
    for j = 1: nDt
        box = dtBox(j, :);
        [eightBox, poly] = rotateBoxPoly(box(1:4), box(5)/180*pi, [imgW/2, imgH/2]);
        polys(j, :) = poly;
  
%         imshow(image);
%         displayBox(fromPolyToAngleBox(poly, [imgW/2, imgH/2]));
%         imgRotate = imrotate(image, box(5), 'crop');
%         imshow(imgRotate);
%         displayBox(box);
    end
    
    %% polys nms
    % map dtBox (random hash)
    angleBoxes = fromPolyToAngleBox(polys, [imgW/2, imgH/2]);
    angleBoxes(:, 5) = angleBoxes(:, 5) ;
    imshow(image);
    displayAngleBox(dtBox, 'g');
    displayAngleBox(angleBoxes, 'b');
    displayAngleBox(dtBox, 'm');
    sum(sum(dtBox(:, 1:5) - angleBoxes(:, 1:5)))
    %angleBoxes = dtBox;
    if ~isempty(dtBox)
        keySet = myHash(angleBoxes);
        valueSet = 1:nDt; % idx
        idxMap = containers.Map(keySet, valueSet);
        
        % nms on dtBox
        tempBox = angleBoxes;
        tempBox(:, 5) = 1./tempBox(:, 4);
%         imshow(image);
%         displayBox(tempBox);
        tempBox = bbNms(tempBox,'type','cover','overlap', 0.7);
        nmsBox = bbNms(tempBox,'type','max','overlap', 0.5);
        
        % get angles of nmsBox
        keys = myHash(nmsBox);
        nKey = length(keys);
        values = zeros(nKey, 1);
        for j = 1: nKey
            values(j) = idxMap(keys(j));
        end
        % get new polys
        if ~isempty(nmsBox)
            angleB = [nmsBox(:, 1:4), values];
            newPolys = fromAngleBoxToPoly(angleB, [imgW/2, imgH/2]);
        else
            newPolys = [];
        end
    else
        newPolys = [];
    end
    %% show images and polys
%     imshow(image);
%     %displayPoly(polys, 'g');
%     displayPoly(newPolys, 'r');
end
