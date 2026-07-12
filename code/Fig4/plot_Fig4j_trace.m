% plot_Fig4j_trace.m
% Independent plotting script for Fig4j — NE-DA interval vs Integration index
% Reads processed plot_data, outputs PNG and PDF to ../results/Fig4/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'Fig4', 'Fig4j_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'Fig4');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

delay_s     = plot_data.delay_s;
mean_ratio  = plot_data.mean_ratio;
sem_ratio   = plot_data.sem_ratio;
significance = cellstr(plot_data.significance);
axis_info   = plot_data.axis;
style       = plot_data.style;

fig = figure('Color', 'white', 'Position', [100 100 600 450]);
ax = axes(fig);
hold(ax, 'on');

errorbar(ax, delay_s, mean_ratio, sem_ratio, 'o-', ...
    'Color',              style.color, ...
    'LineWidth',          style.line_width, ...
    'MarkerFaceColor',    style.color, ...
    'MarkerSize',         style.marker_size, ...
    'CapSize',            style.cap_size);

xline(ax, axis_info.xline);
yline(ax, axis_info.yline);

for i = 1:length(delay_s)
    sig_mark = significance{i};
    y_pos = mean_ratio(i) + sem_ratio(i) + 0.2;

    if strcmp(sig_mark, 'ns')
        text(ax, delay_s(i), y_pos, 'n.s.', ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 10, ...
            'Color', [0.5 0.5 0.5]);
    else
        text(ax, delay_s(i), y_pos, sig_mark, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 12, ...
            'FontWeight', 'bold');
    end
end

xlabel(ax, axis_info.xlabel, 'FontSize', 14);
ylabel(ax, axis_info.ylabel, 'FontSize', 14);
xlim(ax, axis_info.xlim);
ylim(ax, axis_info.ylim);

hold(ax, 'off');

png_file = fullfile(results_dir, 'Fig4j_trace.png');
pdf_file = fullfile(results_dir, 'Fig4j_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('Fig4j exported to:\n  %s\n  %s\n', png_file, pdf_file);
