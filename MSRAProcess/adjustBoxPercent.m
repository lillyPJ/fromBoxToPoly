function newBox = adjustBoxPercent(box, percent)
% [input] box(n*k): [x, y, w, h, ...]
% [input] percent(1*2): [percentx, percenty] (eg: [0.1, 0.1]
% [output] newBox(n*k): x', y', w', h', ...

nBox = size(box, 1);
newBox = box;
if nBox < 1
    return;
end

if nargin < 2
    percent = [0.1, 0.15];
end
xEtra = newBox(:,3).* percent(1);
yExtra = newBox(:,4).* percent(2);

newBox(:, 1) = round(max(1, newBox(:, 1) - xEtra));
newBox(:, 2) = round(max(1, newBox(:, 2) - yExtra));
newBox(:, 3) = round(newBox(:, 3) + 2.* xEtra);
newBox(:, 4) = round(newBox(:, 4) + 2.* yExtra);