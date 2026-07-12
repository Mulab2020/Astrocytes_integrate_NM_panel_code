% plot_Fig3e_distribution
% Recreates Fig. 3e futile swim onset time distributions.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(fileparts(scriptDir));
dataFile = fullfile(rootDir, 'data', 'Fig3', 'Fig3e_distribution_plot_data.mat');
resultDir = fullfile(rootDir, 'results', 'Fig3');

if ~exist(resultDir, 'dir')
    mkdir(resultDir);
end

S = load(dataFile, 'plot_data');
plot_data = S.plot_data;

fig = figure('Color', 'w', 'Units', 'centimeters', 'Position', [2 2 16.2 8.2]);
ax = axes(fig, 'Position', [0.18 0.25 0.78 0.65]);
hold(ax, 'on');

for i = 1:numel(plot_data.groups)
    g = plot_data.groups(i);
    c = g.color;
    for j = 1:numel(g.hist_density)
        if isnan(g.hist_density(j)) || g.hist_density(j) <= 0
            continue
        end
        xPatch = [g.hist_edges(j), g.hist_edges(j + 1), g.hist_edges(j + 1), g.hist_edges(j)];
        yPatch = [0, 0, g.hist_density(j), g.hist_density(j)];
        patch(ax, xPatch, yPatch, c, ...
            'EdgeColor', 'none', 'FaceAlpha', plot_data.hist_face_alpha);
    end
end

for i = 1:numel(plot_data.groups)
    g = plot_data.groups(i);
    if all(isnan(g.gamma_pdf))
        continue
    end
    plot(ax, g.gamma_x, g.gamma_pdf, ...
        'Color', g.color, 'LineWidth', plot_data.gamma_line_width);
end

xlim(ax, plot_data.xlim_s);
ylim(ax, plot_data.ylim_density);
xticks(ax, [0 10 20 30]);
yticks(ax, [0 0.4 0.8]);
yticklabels(ax, {'0', '0.4', '0.8'});
xlabel(ax, 'Futile swim onset time (s)', 'FontName', 'Arial', 'FontSize', 18);
ylabel(ax, 'Probability density', 'FontName', 'Arial', 'FontSize', 18);
set(ax, 'FontName', 'Arial', 'FontSize', 18, ...
    'LineWidth', 1.0, 'TickDir', 'out', 'Box', 'off', ...
    'Layer', 'top');

outPng = fullfile(resultDir, 'Fig3e_distribution.png');
outPdf = fullfile(resultDir, 'Fig3e_distribution.pdf');

if exist('exportgraphics', 'file') == 2
    exportgraphics(fig, outPng, 'Resolution', 600);
    exportgraphics(fig, outPdf, 'ContentType', 'vector');
else
    print(fig, outPng, '-dpng', '-r600');
    print(fig, outPdf, '-dpdf', '-painters');
end

close(fig);
