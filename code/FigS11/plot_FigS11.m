clear; clc;

% Add Fig2 path for shared colormap
addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Fig2'));

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS11', 'FigS11_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS11');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

fig = figure('Color', 'white', 'Units', 'pixels', 'Position', [100 100 720 620]);
tl = tiledlayout(fig, 2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:numel(plot_data.heatmap)
    ax = nexttile(tl);
    item = plot_data.heatmap(i);

    h = imagesc(ax, item.r5p, item.v_beta, item.matrix);
    set(h, 'AlphaData', ~isnan(item.matrix));
    set(ax, 'Color', plot_data.nan_color);
    set(ax, 'YDir', 'normal');
    axis(ax, 'tight');
    axis(ax, 'square');
    colormap(ax, rdYlBuBlueWhiteRed(256));
    clim(ax, item.clim);

    cb = colorbar(ax);
    cb.Label.String = plot_data.colorbar_label;
    cb.Label.FontSize = 11;
    cb.FontSize = 10;

    title_parts = split(string(item.title), '|');
    title(ax, title_parts, 'FontWeight', 'normal', 'FontSize', 11);
    xlabel(ax, plot_data.x_label, 'FontSize', 10);
    ylabel(ax, plot_data.y_label, 'FontSize', 10);

    xticks(ax, [3 4 5]);
    yticks(ax, [6 8 10]);
    xlim(ax, [min(item.r5p), max(item.r5p)]);
    ylim(ax, [min(item.v_beta), max(item.v_beta)]);
    set(ax, 'Box', 'on', 'TickDir', 'out', 'FontName', 'Arial', 'FontSize', 10, 'LineWidth', 0.8);

    text(ax, -0.16, 1.10, item.id, 'Units', 'normalized', ...
        'FontName', 'Arial', 'FontSize', 15, 'FontWeight', 'normal');
end

png_file = fullfile(results_dir, 'FigS11.png');
pdf_file = fullfile(results_dir, 'FigS11.pdf');
exportgraphics(fig, png_file, 'Resolution', 600);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS11 exported to:\n  %s\n  %s\n', png_file, pdf_file);
