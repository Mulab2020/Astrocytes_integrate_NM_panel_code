clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'Fig4', 'Fig4g_distribution_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'Fig4');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

pki_color = plot_data.colors.pki;
wt_color = plot_data.colors.wt;

fig = figure('Color', 'white', 'Units', 'pixels', 'Position', [100 100 430 360]);
ax = axes(fig);
hold(ax, 'on');

histogram(ax, plot_data.pki_values, plot_data.hist_edges, ...
    'Normalization', 'pdf', 'FaceColor', pki_color, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.22);
histogram(ax, plot_data.wt_values, plot_data.hist_edges, ...
    'Normalization', 'pdf', 'FaceColor', wt_color, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.18);

plot(ax, plot_data.x_fit, plot_data.pki_lognormal_pdf, '-', ...
    'Color', pki_color, 'LineWidth', 2.0);
plot(ax, plot_data.x_fit, plot_data.wt_lognormal_pdf, '-', ...
    'Color', wt_color, 'LineWidth', 2.0);

text(ax, 18, 0.028, plot_data.sig_label, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
    'FontName', 'Arial', 'FontSize', 22, 'FontWeight', 'bold', 'Color', 'k');

xlabel(ax, plot_data.labels.x, 'FontName', 'Arial', 'FontSize', 16);
ylabel(ax, plot_data.labels.y, 'FontName', 'Arial', 'FontSize', 16);
xlim(ax, [plot_data.hist_edges(1), plot_data.axis.xlim(2)]);
ylim(ax, plot_data.axis.ylim);
xticks(ax, plot_data.axis.xticks);
yticks(ax, plot_data.axis.yticks);
yticklabels(ax, {'0', '0.05', '0.1'});

set(ax, 'Box', 'off', 'TickDir', 'out', 'FontName', 'Arial', ...
    'FontSize', 13, 'LineWidth', 1.0, 'Layer', 'top');

png_file = fullfile(results_dir, 'Fig4g_distribution.png');
pdf_file = fullfile(results_dir, 'Fig4g_distribution.pdf');
exportgraphics(fig, png_file, 'Resolution', 600);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');
