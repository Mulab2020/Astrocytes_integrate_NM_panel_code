% plot_FigS2b_trace.m
% Independent plotting script for FigS2b — astrocytic calcium trace
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS2/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS2', 'FigS2b_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS2');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

x = double(plot_data.x_scale_frames);
y = double(plot_data.cell_response);
color_line = double(plot_data.color);
x_lim = double(plot_data.xlim);
y_lim = double(plot_data.ylim);

fig = figure('Color', 'white', 'Position', [100 100 600 300]);
ax = axes(fig);
hold(ax, 'on');

plot(ax, x, y, 'Color', color_line, 'LineWidth', 2);

% Drug onset
xline(ax, 200, 'Color', [58 154 73]/255, 'LineWidth', 2);

xlabel(ax, 'Time (s)');
ylabel(ax, plot_data.ylabel);
xlim(ax, x_lim);
ylim(ax, y_lim);

% Shift x tick labels to start from 0
xt = xticks(ax);
xticklabels(ax, arrayfun(@(v) num2str(v - x_lim(1)), xt, 'UniformOutput', false));

hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS2b_trace.png');
pdf_file = fullfile(results_dir, 'FigS2b_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS2b exported to:\n  %s\n  %s\n', png_file, pdf_file);
