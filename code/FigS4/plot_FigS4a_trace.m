% plot_FigS4a_trace.m
% Independent plotting script for FigS4a — ephys swim trace + drug onset line
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS4/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS4', 'FigS4a_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS4');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x = double(plot_data.x_scale);
y = double(plot_data.filtdata_scaled);
xline_pos = double(plot_data.xline_pos);
trace_color = double(plot_data.trace_color);
xline_color = double(plot_data.xline_color);
x_lim = double(plot_data.xlim);
y_lim = double(plot_data.ylim);
sx_start = double(plot_data.scale_x_start);
sx_len = double(plot_data.scale_x_len);
sy_start = double(plot_data.scale_y_start);
sy_len = double(plot_data.scale_y_len);

fig = figure('Color', 'white', 'Position', [100 100 800 250]);
ax = axes(fig);
hold(ax, 'on');

% Ephys trace
plot(ax, x, y, 'Color', trace_color, 'LineWidth', 1);

% Drug onset line
xline(ax, xline_pos, 'Color', xline_color, 'LineWidth', 10);

% Scale bars
plot(ax, [sx_start, sx_start + sx_len], [sy_start, sy_start], ...
    'Color', 'k', 'LineWidth', 5);

% Formatting
xlim(ax, x_lim);
ylim(ax, y_lim);
ax.XColor = 'none';
ax.YColor = 'none';
ax.Color = 'w';
fig.Color = 'w';
axis(ax, 'off');
hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS4a_trace.png');
pdf_file = fullfile(results_dir, 'FigS4a_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS4a exported to:\n  %s\n  %s\n', png_file, pdf_file);
