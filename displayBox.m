function displayBox(box, color, pos, dimscore)
m = size(box,  1);
showScore = 0;
if nargin == 1
    color = 'g';
else if nargin > 2 
        showScore = 1;
        if nargin < 4
            dimscore = 5;
        end
    end
end
for i = 1:m
    rectangle('position', box(i, 1:4), 'edgecolor', color, 'linewidth', 2);
    if( showScore )
        switch(pos)
            case 'u'
                text(box(i, 1)+box(i, 3)/2-10, box(i, 2)-10, sprintf('%.f', box(i, dimscore)), 'BackgroundColor', 'w', 'Color', 'm', 'FontWeight', 'demi');
            case 'm'
                text(box(i, 1)+box(i, 3)/2-10, box(i, 2)+box(i, 4)/2, sprintf('%.2f', box(i, dimscore)), 'BackgroundColor', 'w', 'Color', 'r', 'FontWeight', 'demi');
            case 'd'
                text(box(i, 1)+box(i, 3)/2-10, box(i, 2)+box(i, 4)-10, sprintf('%.2f', box(i, dimscore)), 'BackgroundColor', 'w', 'Color', 'b', 'FontWeight', 'demi');
            otherwise
        end
    end
    
end