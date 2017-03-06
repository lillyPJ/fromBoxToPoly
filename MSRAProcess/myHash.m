function keySet = myHash(dtBox)

if isempty(dtBox)
    keySet = [];
    return;
end
tempKey = (dtBox(:, 1) - dtBox(:, 2)) * 5 ...
    + (dtBox(:, 3) + dtBox(:, 4)) * 2;
keySet = sum(tempKey, 2);