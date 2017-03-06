function displayPoly(poly, color)
% box: [x1, y1, x2, y2, x3, y3, x4, y4]
if nargin < 2
    color = 'g';
end
if isempty(poly)
    return;
end
hold on
nPoly = size(poly, 1);
for i = 1:nPoly
    patch('XData', poly(i, 1:2:8), 'YData', poly(i, 2:2:8), ...
        'EdgeColor', color,'FaceColor','none','LineWidth',2);
end
