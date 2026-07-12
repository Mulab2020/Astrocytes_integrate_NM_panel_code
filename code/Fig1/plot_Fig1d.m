% plot_Fig1d
% Recreates Fig. 1d activation traces from processed plotting summaries.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(scriptDir));
dataFile = fullfile(rootDir, 'data', 'Fig1', 'Fig1d_plot_data.mat');
resultDir = fullfile(rootDir, 'results', 'Fig1');

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

S = load(dataFile, 'plot_data');
plot_data = S.plot_data;

fig = figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 5.2 10.5]);
rowLabels = {'DA', 'NE', 'Ctrl'};
rowCenters = [0.80, 0.515, 0.23];

for i = 1:3
    ax = axes(fig, 'Position', [0.39, 0.71 - (i - 1) * 0.285, 0.54, 0.19]);
    hold(ax, 'on');

    tr = plot_data.traces(i);
    x = tr.time_s;
    y = tr.mean_percent;
    e = tr.sem_percent;

    patch(ax, [plot_data.activation_window_s(1), plot_data.activation_window_s(1), ...
        plot_data.activation_window_s(2), plot_data.activation_window_s(2)], ...
        [plot_data.ylim_percent(1), plot_data.ylim_percent(2), ...
        plot_data.ylim_percent(2), plot_data.ylim_percent(1)], ...
        plot_data.colors.activation, 'EdgeColor', 'none', 'FaceAlpha', 0.85);

    fill(ax, [x, fliplr(x)], [y + e, fliplr(y - e)], plot_data.colors.area, ...
        'EdgeColor', 'none', 'FaceAlpha', 0.25);
    plot(ax, x, y, 'Color', plot_data.colors.line, 'LineWidth', 1.3);

    xlim(ax, plot_data.xlim_s);
    ylim(ax, plot_data.ylim_percent);
    box(ax, 'off');
    set(ax, 'FontName', 'Arial', 'FontSize', 9, 'LineWidth', 0.7, ...
        'TickDir', 'out', 'XTick', [0 10 20], 'YTick', [0 10], ...
        'YTickLabel', {'0', '10'}, 'YMinorTick', 'off', 'Layer', 'top');
    ax.YAxis.Exponent = 0;
    ax.YAxis.SecondaryLabel.String = '';
    ax.YAxis.SecondaryLabel.Visible = 'off';

    if i < 3
        set(ax, 'XTickLabel', []);
    else
        xlabel(ax, 'Time (s)', 'FontName', 'Arial', 'FontSize', 10);
    end

    if i == 2
        yl = ylabel(ax, 'Astrocytic \DeltaF/F_0 (%)', 'FontName', 'Arial', 'FontSize', 9);
        yl.Units = 'normalized';
        yl.Position = [-0.35, 0.5, 0];
    end

    annotation(fig, 'textbox', [0.02, rowCenters(i) - 0.025, 0.10, 0.05], ...
        'String', rowLabels{i}, 'Color', plot_data.colors.label, ...
        'FontName', 'Arial', 'FontSize', 10, 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'LineStyle', 'none');
end

annotation(fig, 'textbox', [0.39, 0.92, 0.54, 0.05], 'String', 'Activation', ...
    'Color', plot_data.colors.label, 'FontName', 'Arial', 'FontSize', 10, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'LineStyle', 'none');

outPng = fullfile(resultDir, 'Fig1d_activation_traces.png');
outPdf = fullfile(resultDir, 'Fig1d_activation_traces.pdf');

if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, outPng, 'Resolution', 600);
    exportgraphics(fig, outPdf, 'ContentType', 'vector');
else
    print(fig, outPng, '-dpng', '-r600');
    print(fig, outPdf, '-dpdf', '-painters');
end

close(fig);
