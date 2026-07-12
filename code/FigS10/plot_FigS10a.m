% plot_FigS10a.m
% 5-panel column: NE / DA / IP3 / PKA / Calcium modeled traces at 5 time offsets
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS10/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS10', 'FigS10a_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS10');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

species_list = cellstr(plot_data.species);
ylabels = cellstr(plot_data.ylabels);
scales = double(plot_data.scales);
ylims_arr = double(plot_data.ylims);
colors = double(plot_data.colors);
lw = double(plot_data.line_width);
offset_names = cellstr(plot_data.offset_names);
display_names = {'-10s', '-5s', '0s', '5s', '10s'};

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [100 50 420 900]);
tl = tiledlayout(fig, 5, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:5
    ax = nexttile(tl, i);
    hold(ax, 'on');

    sp = species_list{i};
    scale = scales(i);

    % Time axis
    n_pts = size(plot_data.([sp '_p0s']), 2);
    temp = (1:n_pts) / 130;

    for j = 1:5
        off = offset_names{j};
        trace_data = double(plot_data.([sp '_' off]));
        plot(ax, temp, trace_data * scale, 'LineWidth', lw, ...
            'Color', colors(j, :), 'DisplayName', display_names{j});
    end

    xlim(ax, [0 50]);
    xticks(ax, 0:10:50);
    ylim(ax, ylims_arr(i, :));
    ylabel(ax, ylabels{i}, 'FontSize', 12);

    if i < 5
        ax.XTickLabel = [];
    else
        xlabel(ax, 'Time (s)', 'FontSize', 12);
    end

    if i == 1
        legend(ax, 'Location', 'northeast', 'Box', 'off');
    end

    set(ax, 'FontSize', 12, 'LineWidth', 1, 'TickDir', 'out');
    box(ax, 'off');
    hold(ax, 'off');
end

png_file = fullfile(results_dir, 'FigS10a.png');
pdf_file = fullfile(results_dir, 'FigS10a.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS10a exported to:\n  %s\n  %s\n', png_file, pdf_file);
