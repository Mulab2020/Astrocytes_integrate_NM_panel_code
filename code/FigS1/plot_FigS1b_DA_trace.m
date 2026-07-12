% plot_FigS1b_DA_trace.m
% Independent plotting script for FigS1b DA — single-cell and mean calcium traces
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS1/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS1', 'FigS1b_DA_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS1');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x_scale_frames = double(plot_data.x_scale_frames);
single_ca = double(plot_data.single_ca);
mean_ca = double(plot_data.mean_ca);
amp = double(plot_data.amplified_factor);
x_dur = double(plot_data.x_dur);
color_full = double(plot_data.color);
color_light = double(plot_data.color_light);

fig = figure('Color', 'white', 'Position', [100 100 500 350]);
ax = axes(fig);
hold(ax, 'on');

% Single-cell traces (light gray, no vertical offset)
for i = 1:size(single_ca, 1)
    plot(ax, x_scale_frames, single_ca(i, :) * amp + 0.5, ...
        'Color', color_light, 'LineWidth', 0.5);
end

% Mean trace (modulator color)
mean_offset = -1;
plot(ax, x_scale_frames, mean_ca * amp + 0.5, ...
    'Color', color_full, 'LineWidth', 1.5);

% Scale bars
y_start = 0.1;
y_len = 0.1 * amp;
x_start = x_dur(2) - 11;
x_len = 10;

plot(ax, [x_start, x_start], [y_start, y_start + y_len], ...
    'Color', 'k', 'LineWidth', 2);
plot(ax, [x_start, x_start + x_len], [y_start, y_start], ...
    'Color', 'k', 'LineWidth', 2);

% Formatting
xlim(ax, x_dur);
ylim(ax, [mean_offset - 1, amp * max(single_ca(:)) + 0.5]);
ax.XColor = 'none';
ax.YColor = 'none';
ax.Color = 'w';
fig.Color = 'w';
axis(ax, 'off');
hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS1b_DA_trace.png');
pdf_file = fullfile(results_dir, 'FigS1b_DA_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS1b DA exported to:\n  %s\n  %s\n', png_file, pdf_file);
