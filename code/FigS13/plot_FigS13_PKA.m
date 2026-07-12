% plot_FigS13_PKA.m
% PKA inhibition test — control (kpep0) vs PKI (kpep5)
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS13/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS13', 'FigS13_PKA_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS13');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

temp = double(plot_data.temp);
kpep0 = double(plot_data.kpep0);
kpep5 = double(plot_data.kpep5);
scale = double(plot_data.scale);
lw = double(plot_data.line_width);
col_control = double(plot_data.color_control);
col_pki = double(plot_data.color_pki);

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [100 100 560 380]);
ax = axes(fig);
hold(ax, 'on');

plot(ax, temp, kpep0 * scale, 'LineWidth', lw, 'Color', col_control, 'DisplayName', 'control');
plot(ax, temp, kpep5 * scale, 'LineWidth', lw, 'Color', col_pki, 'DisplayName', 'PKI');

xlabel(ax, 'Time (s)', 'FontSize', 12);
ylabel(ax, plot_data.ylabel, 'FontSize', 12);
xlim(ax, double(plot_data.xlim));
xticks(ax, 0:10:50);
ylim(ax, double(plot_data.ylim));
yticks(ax, double(plot_data.yticks));
xline(ax, double(plot_data.xline_pos), '--', 'Color', [0.35 0.35 0.35], 'LineWidth', 1.2, 'HandleVisibility', 'off');

set(ax, 'FontSize', 12, 'LineWidth', 1, 'TickDir', 'out');
box(ax, 'off');
legend(ax, 'Location', 'northeast', 'Box', 'off');
hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS13_PKA.png');
pdf_file = fullfile(results_dir, 'FigS13_PKA.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS13_PKA exported to:\n  %s\n  %s\n', png_file, pdf_file);
