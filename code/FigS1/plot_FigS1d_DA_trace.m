% plot_FigS1d_DA_trace.m
% Independent plotting script for FigS1d DA — shaded error bar (mean +- SEM)
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS1/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS1', 'FigS1d_DA_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS1');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x = double(plot_data.x_scale_trial);
dff_mean = double(plot_data.dff_mean);
dff_sem = double(plot_data.dff_sem);
color_line = double(plot_data.color_line);
color_area = double(plot_data.color_area);
alpha_val = double(plot_data.alpha);
xline_pos = double(plot_data.xline_pos);
x_lim = double(plot_data.xlim);
sx_start = double(plot_data.scale_x_start);
sx_len = double(plot_data.scale_x_len);
sy_start = double(plot_data.scale_y_start);
sy_len = double(plot_data.scale_y_len);

fig = figure('Color', 'white', 'Position', [100 100 500 300]);
ax = axes(fig);
hold(ax, 'on');

% Shaded SEM area
x_fill = [x, fliplr(x)];
y_fill = [dff_mean + dff_sem, fliplr(dff_mean - dff_sem)];
fill(ax, x_fill, y_fill, color_area, ...
    'FaceAlpha', alpha_val, 'EdgeColor', 'none');

% Mean line
plot(ax, x, dff_mean, '-', 'Color', color_line, 'LineWidth', 1);

% Stimulus onset
xline(ax, xline_pos, 'k--', 'LineWidth', 1);

% Scale bars
plot(ax, [sx_start - sx_len, sx_start], [sy_start, sy_start], ...
    'Color', 'k', 'LineWidth', 2);
plot(ax, [sx_start, sx_start], [sy_start, sy_start + sy_len], ...
    'Color', 'k', 'LineWidth', 2);

% Formatting
xlim(ax, x_lim);
ax.XColor = 'none';
ax.YColor = 'none';
ax.Color = 'w';
fig.Color = 'w';
axis(ax, 'off');
hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS1d_DA_trace.png');
pdf_file = fullfile(results_dir, 'FigS1d_DA_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS1d DA exported to:\n  %s\n  %s\n', png_file, pdf_file);
