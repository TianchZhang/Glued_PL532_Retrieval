function [fh] = show_RCS_color(mTime, height, RCS, varargin)
%show_RCS_color display range corrected signal colorplot.
%Example:
%   [fh] = display_RCS_colorplot(ax, mTime, height, RCS, varargin)
%Inputs:
%   mTime: array
%       measurement time.
%   height: array
%       height above ground. (km)
%   RCS: matrix (height * time)
%       range corrected signal.
%Keywords:
%   scale: char
%       'linear' or 'log'
%   tRange: 2-element array
%       temporal range.
%   hRange: 2-element array
%       spatial range. (km)
%   cRange: 2-element array
%       color range for range corrected signal.

%   cmap: char
%       colormap.
%Outputs:
%   fh: figure
%       figure handle.
%History:
%   2020-05-28. First Edition by Zhenping/display_RCS_colorplot
%   2021-07-29 edited by Zhangtc


p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'mTime', @isnumeric);
addRequired(p, 'height', @isnumeric);
addRequired(p, 'RCS', @isnumeric);
addParameter(p, 'scale', 'linear', @ischar);
addParameter(p, 'tRange', [0, 1], @isnumeric);
addParameter(p, 'hRange', [0, 100], @isnumeric);
addParameter(p, 'cRange', [0, 1e6], @isnumeric);

addParameter(p, 'cmap', 'myjet', @ischar);

parse(p, mTime, height, RCS, varargin{:});
ax = gca;
if strcmpi(p.Results.scale, 'linear')
    % linear scale
    p1 = pcolor(mTime, height, RCS);
    p1.EdgeColor = 'None';
    hold on;

    caxis(p.Results.cRange)
elseif strcmpi(p.Results.scale, 'log')
    % logarithm scale
    RCS(RCS <= 0) = NaN;
    p1 = pcolor(mTime, height, log10(RCS));
    p1.EdgeColor = 'None';
    hold on;

    caxis(log10(p.Results.cRange));
else
    error('Wrong range corrected signal scale mode');
end

if (~ isempty(p.Results.Temp)) && (numel(p.Results.Temp) == numel(RCS)) && ...
    (any(any((~ isnan(p.Results.Temp)), 1), 2))
    [c1, h] = contour(mTime, height, p.Results.Temp, [0, -40.0], ...
                      'LineColor', 'w', 'LineWidth', 2, 'LineStyle', '--');
    clabel(c1, h, 'FontSize', 10, 'Color', 'w', 'FontWeight', 'bold');
end

hold off;

xlabel('');
ylabel('Height (km)');
title('range-corrected signal @ 532 nm');

xlim(p.Results.tRange);
ylim(p.Results.hRange);

colormap(gca, load_colormap(p.Results.cmap));

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.tRange(1), p.Results.tRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'Box', 'on', 'LineWidth', 1.5, 'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);
ax.XAxis.MinorTickValues = linspace(p.Results.tRange(1), p.Results.tRange(end), 25);

datetick(gca, 'x', 'HH:MM', 'KeepTicks', 'KeepLimits');

cb = colorbar('Position', [0.93, 0.11, 0.02, 0.82], 'Units', 'Normalized');
titleHandle = get(cb, 'Title');
set(titleHandle, 'String', '[a.u.]');
set(cb, 'TickDir', 'in', 'Box', 'on', 'TickLength', 0.02);

end