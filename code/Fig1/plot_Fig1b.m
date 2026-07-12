% plot_Fig1b
% Recreates Fig. 1b trace panel from processed plotting data.
% The script uses only data/Fig1/Fig1b_plot_data.mat and writes outputs to results/Fig1.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(scriptDir));
dataFile = fullfile(rootDir, 'data', 'Fig1', 'Fig1b_plot_data.mat');
resultDir = fullfile(rootDir, 'results', 'Fig1');

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

S = load(dataFile, 'plot_data');
plot_data = S.plot_data;

fig = figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 10.5 7.0]);
ax = axes(fig);
hold(ax, 'on');

% Draw swim first so the neuromodulator traces sit above it.
plot(ax, plot_data.swim.time_s, plot_data.swim.value, ...
    'Color', plot_data.colors.swim, 'LineWidth', 0.35);
plot(ax, plot_data.ne.time_s, plot_data.ne.value, ...
    'Color', plot_data.colors.NE, 'LineWidth', 2.2);
plot(ax, plot_data.da.time_s, plot_data.da.value, ...
    'Color', plot_data.colors.DA, 'LineWidth', 2.2);

xlim(ax, plot_data.xlim_seconds);
ylim(ax, [-2.2 7.1]);
axis(ax, 'off');
set(ax, 'Position', [0.04 0.04 0.92 0.90]);

% Time scale bar.
scaleSeconds = plot_data.scale_bar.seconds;
x0 = plot_data.xlim_seconds(1) + 2.5;
y0 = 5.75;
plot(ax, [x0 x0 + scaleSeconds], [y0 y0], 'k-', 'LineWidth', 1.4);
text(ax, x0 + scaleSeconds / 2, y0 + 0.22, sprintf('%d s', scaleSeconds), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
    'FontName', 'Arial', 'FontSize', 11, 'Color', 'k');

outPng = fullfile(resultDir, 'Fig1b_trace.png');
outPdf = fullfile(resultDir, 'Fig1b_trace.pdf');

if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, outPng, 'Resolution', 600);
    exportgraphics(fig, outPdf, 'ContentType', 'vector');
else
    print(fig, outPng, '-dpng', '-r600');
    print(fig, outPdf, '-dpdf', '-painters');
end

close(fig);
