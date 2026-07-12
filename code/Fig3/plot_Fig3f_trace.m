clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'Fig3', 'Fig3f_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'Fig3');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x = plot_data.positions;
ne_color = plot_data.colors.ne;
da_color = plot_data.colors.da;

fig = figure('Color', 'white', 'Units', 'pixels', 'Position', [100 100 790 441]);
ax = axes(fig);
ax.Position = [0.13 0.18 0.82 0.76];
hold(ax, 'on');

fill(ax, [x, fliplr(x)], ...
    [plot_data.ne_mean + plot_data.ne_sem, fliplr(plot_data.ne_mean - plot_data.ne_sem)], ...
    ne_color, 'FaceAlpha', 0.14, 'EdgeColor', 'none', 'HandleVisibility', 'off');
fill(ax, [x, fliplr(x)], ...
    [plot_data.da_mean + plot_data.da_sem, fliplr(plot_data.da_mean - plot_data.da_sem)], ...
    da_color, 'FaceAlpha', 0.14, 'EdgeColor', 'none', 'HandleVisibility', 'off');

plot(ax, x, plot_data.ne_mean, '-o', ...
    'Color', ne_color, 'MarkerFaceColor', ne_color, 'MarkerEdgeColor', ne_color, ...
    'LineWidth', 2.0, 'MarkerSize', 7.5);
plot(ax, x, plot_data.da_mean, '-o', ...
    'Color', da_color, 'MarkerFaceColor', da_color, 'MarkerEdgeColor', da_color, ...
    'LineWidth', 2.0, 'MarkerSize', 7.5);

plot(ax, plot_data.axis.xlim, [plot_data.chance_level, plot_data.chance_level], ...
    'k--', 'LineWidth', 1.2, 'HandleVisibility', 'off');

draw_sig_bar(ax, 6.5, 24.1, 0.27, '***', da_color, 0.04);
draw_sig_bar(ax, 6.5, 12.4, 0.205, '***', ne_color, -0.045);
draw_sig_bar(ax, 12.7, 18.5, 0.205, '*', ne_color, -0.045);
draw_sig_bar(ax, 18.8, 24.1, 0.205, 'n.s.', ne_color, -0.045);

xlabel(ax, plot_data.labels.x, 'FontSize', 18);
ylabel(ax, plot_data.labels.y, 'FontSize', 18);
xlim(ax, plot_data.axis.xlim);
ylim(ax, plot_data.axis.ylim);
xticks(ax, plot_data.axis.xticks);
yticks(ax, plot_data.axis.yticks);
yticklabels(ax, {'0', '0.5', '1'});

set(ax, 'Box', 'off', 'TickDir', 'out', 'LineWidth', 0.8, ...
    'FontName', 'Arial', 'FontSize', 15, 'Layer', 'top');
ax.XAxis.Color = [0.25 0.25 0.25];
ax.YAxis.Color = [0.1 0.1 0.1];
fig.PaperPositionMode = 'auto';

png_file = fullfile(results_dir, 'Fig3f_trace.png');
pdf_file = fullfile(results_dir, 'Fig3f_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 600);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

function draw_sig_bar(ax, x1, x2, y, label, color, text_offset)
    plot(ax, [x1, x2], [y, y], '-', 'Color', color, 'LineWidth', 1.4, 'HandleVisibility', 'off');
    text(ax, (x1 + x2) / 2, y + text_offset, label, ...
        'Color', color, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'FontName', 'Arial', 'FontSize', 18);
end
