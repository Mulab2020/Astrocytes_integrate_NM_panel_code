% plot_FigS9a_gfap_rflamp1.m
% Exp fish — struggle-aligned cAMP shaded error bar
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS9/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS9', 'FigS9a_gfap_rflamp1_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS9');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x = double(plot_data.x_scale_trial);
dff_mean = mean(double(plot_data.struggle_align), 1);
dff_sem = std(double(plot_data.struggle_align), 0, 1) / sqrt(double(plot_data.n_trials));
color_line = double(plot_data.color_line);
color_area = double(plot_data.color_area);
alpha_val = double(plot_data.alpha);
xline_pos = double(plot_data.xline_pos);
xline_color = double(plot_data.xline_color);
x_lim = double(plot_data.xlim);

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

% Struggle onset
xline(ax, xline_pos, '--', 'Color', xline_color, 'LineWidth', 1);

% Scale bars
sx_start = double(plot_data.scale_x_start);
sx_len = double(plot_data.scale_x_len);
sy_start = double(plot_data.scale_y_start);
sy_len = double(plot_data.scale_y_len);
plot(ax, [sx_start - sx_len, sx_start], [sy_start, sy_start], ...
    'k-', 'LineWidth', 1);
plot(ax, [sx_start, sx_start], [sy_start, sy_start + sy_len], ...
    'k-', 'LineWidth', 1);

% Formatting
xlim(ax, x_lim);
ax.XColor = 'none';
ax.YColor = 'none';
axis(ax, 'off');

hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS9a_gfap_rflamp1.png');
pdf_file = fullfile(results_dir, 'FigS9a_gfap_rflamp1.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS9a_gfap_rflamp1 exported to:\n  %s\n  %s\n', png_file, pdf_file);
