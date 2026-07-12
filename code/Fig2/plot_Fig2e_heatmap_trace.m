% plot_Fig2e_heatmap_trace
% Recreates Fig. 2e heatmap plus aligned swim traces.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(scriptDir));
dataFile = fullfile(rootDir, 'data', 'Fig2', 'Fig2e_heatmap_trace_plot_data.mat');
resultDir = fullfile(rootDir, 'results', 'Fig2');

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

S = load(dataFile, 'plot_data');
plot_data = S.plot_data;

fig = figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 10.8 8.4]);

heatAx = axes(fig, 'Position', [0.14 0.12 0.17 0.80]);
imagesc(heatAx, 1:size(plot_data.heatmap.matrix_percent, 2), ...
    1:size(plot_data.heatmap.matrix_percent, 1), plot_data.heatmap.matrix_percent);
colormap(heatAx, rdYlBuBlueWhiteRed(256));
clim(heatAx, plot_data.heatmap.clim_percent);
set(heatAx, 'YDir', 'reverse', 'XTick', [], 'YTick', [], ...
    'Box', 'on', 'LineWidth', 1.0, 'TickDir', 'out');
hold(heatAx, 'on');
plot(heatAx, [plot_data.heatmap.align_col plot_data.heatmap.align_col], ...
    [0.5 size(plot_data.heatmap.matrix_percent, 1) + 0.5], ...
    'k--', 'LineWidth', 1.0);
text(heatAx, -14.0, size(plot_data.heatmap.matrix_percent, 1) / 2, ...
    '\DeltaF/F_0 (%)', 'Rotation', 90, 'Clipping', 'off', ...
    'FontName', 'Arial', 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

cb = colorbar(heatAx, 'westoutside');
cb.Ticks = plot_data.heatmap.clim_percent;
cb.TickLabels = {'0', '6'};
cb.FontName = 'Arial';
cb.FontSize = 9;
cb.LineWidth = 0.8;
cb.Position = [0.055 0.15 0.035 0.17];
cb.Label.String = '';

traceAx = axes(fig, 'Position', [0.37 0.12 0.58 0.80]);
hold(traceAx, 'on');
for i = 1:numel(plot_data.traces)
    plot(traceAx, plot_data.traces(i).time_s, plot_data.traces(i).value, ...
        'k', 'LineWidth', 1.0);
end
xlim(traceAx, plot_data.xlim_s);
allY = [];
for i = 1:numel(plot_data.traces)
    allY = [allY, plot_data.traces(i).value]; %#ok<AGROW>
end
yMin = min(min(allY) - 1.5, plot_data.scale_bar.y - 3.0);
ylim(traceAx, [yMin, max(allY) + 1.5]);
axis(traceAx, 'off');

barX = [plot_data.scale_bar.x_start, plot_data.scale_bar.x_start + plot_data.scale_bar.seconds];
barY = [plot_data.scale_bar.y, plot_data.scale_bar.y];
plot(traceAx, barX, barY, 'k-', 'LineWidth', 1.4);
text(traceAx, mean(barX), barY(1) - 1.8, sprintf('%d s', plot_data.scale_bar.seconds), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
    'FontName', 'Arial', 'FontSize', 10, 'Color', 'k');

outPng = fullfile(resultDir, 'Fig2e_heatmap_trace.png');
outPdf = fullfile(resultDir, 'Fig2e_heatmap_trace.pdf');

if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, outPng, 'Resolution', 600);
    exportgraphics(fig, outPdf, 'ContentType', 'vector');
else
    print(fig, outPng, '-dpng', '-r600');
    print(fig, outPdf, '-dpdf', '-painters');
end

close(fig);
