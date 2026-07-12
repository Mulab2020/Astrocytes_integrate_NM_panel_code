% plot_Fig2d_trace
% Recreates Fig. 2d fish-average astrocytic response traces.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(scriptDir));
dataFile = fullfile(rootDir, 'data', 'Fig2', 'Fig2d_trace_plot_data.mat');
resultDir = fullfile(rootDir, 'results', 'Fig2');

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

S = load(dataFile, 'plot_data');
plot_data = S.plot_data;

fig = figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 7.8 4.2]);
ax = axes(fig, 'Position', [0.22 0.20 0.72 0.68]);
hold(ax, 'on');

patch(ax, [plot_data.activation_window_s(1), plot_data.activation_window_s(2), ...
    plot_data.activation_window_s(2), plot_data.activation_window_s(1)], ...
    [plot_data.ylim_percent(1), plot_data.ylim_percent(1), ...
    plot_data.ylim_percent(2), plot_data.ylim_percent(2)], ...
    [205 235 193] / 255, 'EdgeColor', 'none', 'FaceAlpha', 0.85);

plotOrder = [3 2 1]; % NE & DA, NE, DA
lineHandles = gobjects(1, numel(plotOrder));
for idx = 1:numel(plotOrder)
    tr = plot_data.traces(plotOrder(idx));
    x = plot_data.time_s;
    y = tr.mean_percent;
    e = tr.sem_percent;
    fill(ax, [x, fliplr(x)], [y + e, fliplr(y - e)], tr.color, ...
        'EdgeColor', 'none', 'FaceAlpha', 0.28);
    lineHandles(idx) = plot(ax, x, y, 'Color', tr.color, 'LineWidth', 1.2);
end

xlim(ax, plot_data.xlim_s);
ylim(ax, plot_data.ylim_percent);
box(ax, 'off');
set(ax, 'FontName', 'Arial', 'FontSize', 8.5, 'LineWidth', 0.75, ...
    'TickDir', 'out', 'XTick', [0 10 20 30], 'YTick', [0 10 20 30], ...
    'Layer', 'top');

xlabel(ax, 'Time (s)', 'FontName', 'Arial', 'FontSize', 8.5);
yl = ylabel(ax, 'Astrocytic \DeltaF/F_0 (%)', 'FontName', 'Arial', 'FontSize', 8.5);
yl.Units = 'normalized';
yl.Position = [-0.13, 0.5, 0];

text(ax, mean(plot_data.activation_window_s), plot_data.ylim_percent(2) + 1.3, 'Opto', ...
    'Color', [87 172 61] / 255, 'FontName', 'Arial', 'FontSize', 8.5, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Clipping', 'off');
text(ax, -2.65, 9.3, sprintf('n = %d fish', plot_data.n_fish), ...
    'Color', 'k', 'FontName', 'Arial', 'FontSize', 8, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');

leg = legend(ax, lineHandles, {'NE & DA', 'NE', 'DA'}, 'Box', 'off', ...
    'Location', 'northeast', 'FontName', 'Arial', 'FontSize', 8);
leg.ItemTokenSize = [12, 6];

outPng = fullfile(resultDir, 'Fig2d_trace.png');
outPdf = fullfile(resultDir, 'Fig2d_trace.pdf');

if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, outPng, 'Resolution', 600);
    exportgraphics(fig, outPdf, 'ContentType', 'vector');
else
    print(fig, outPng, '-dpng', '-r600');
    print(fig, outPdf, '-dpdf', '-painters');
end

close(fig);
