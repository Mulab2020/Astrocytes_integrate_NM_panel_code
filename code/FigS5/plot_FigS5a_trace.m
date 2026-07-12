% plot_FigS5a_trace.m
% Three-row aligned plot: NE Struggle (blue) / NE trials (green) / Control trials (gray)
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS5/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS5', 'FigS5a_trace_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS5');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

spacing = double(plot_data.row_spacing);
n_trials = double(plot_data.n_trials);

row1_xlines = double(plot_data.row1_xlines);
row2_xlines = double(plot_data.row2_xlines);
row3_xlines = double(plot_data.row3_xlines);

% Master alignment grid (use Row 2/3 fixed spacing as reference)
master_x = row2_xlines;

% Row offsets (Row 1 top, Row 2 middle, Row 3 bottom)
y1 = 0;
y2 = -spacing;
y3 = -2 * spacing;

fig = figure('Color', 'white', 'Position', [100 100 1000 400]);
ax = axes(fig);
hold(ax, 'on');

% ========== ROW 1: NE Struggle (blue, #036eb8) ==========
for i = 1:n_trials
    t_rel = double(plot_data.row1_t_rel{i});
    ca = double(plot_data.row1_ca{i});
    shift_x = master_x(i) - row1_xlines(i);
    plot(ax, t_rel + shift_x, ca + y1, ...
        'Color', double(plot_data.row1_color), 'LineWidth', 1.5);
end

% ========== ROW 2: NE stage 3 (green) ==========
row2_t = double(plot_data.row2_t_rel);
row2_c = double(plot_data.row2_ca);
for i = 1:n_trials
    plot(ax, row2_t(i, :), row2_c(i, :) + y2, ...
        'Color', double(plot_data.row2_color), 'LineWidth', 1.5);
end

% ========== ROW 3: Control stage 5 (gray) ==========
row3_t = double(plot_data.row3_t_rel);
row3_c = double(plot_data.row3_ca);
for i = 1:n_trials
    plot(ax, row3_t(i, :), row3_c(i, :) + y3, ...
        'Color', double(plot_data.row3_color), 'LineWidth', 1.5);
end

% ========== Dashed onset lines (spanning all rows) ==========
for i = 1:n_trials
    xline(ax, master_x(i), '--k', 'LineWidth', 1.0, 'Alpha', 0.4);
end

% ========== Scale bar ==========
xl = xlim; yl = ylim;
scale_x = double(plot_data.scale_x);
scale_y = double(plot_data.scale_y);

x_corner = xl(2) - (xl(2) - xl(1)) * 0.03;
y_corner = yl(2) - (yl(2) - yl(1)) * 0.25;

plot(ax, [x_corner - scale_x, x_corner], [y_corner, y_corner], ...
    'k-', 'LineWidth', 2.5);
plot(ax, [x_corner, x_corner], [y_corner, y_corner + scale_y], ...
    'k-', 'LineWidth', 2.5);

text(ax, x_corner - scale_x, y_corner + (yl(2)-yl(1))*0.03, '5 s', ...
    'FontSize', 10, 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom', 'FontName', 'Arial', 'Color', 'k');

text(ax, x_corner + (xl(2)-xl(1))*0.01, y_corner + scale_y * 0.5, ...
    {'10 %', '\DeltaF/F_0'}, ...
    'FontSize', 10, 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'middle', 'FontName', 'Arial');

% ========== Formatting ==========
ax.Visible = 'off';
ax.XColor = 'none';
ax.YColor = 'none';
hold(ax, 'off');

png_file = fullfile(results_dir, 'FigS5a_trace.png');
pdf_file = fullfile(results_dir, 'FigS5a_trace.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS5a exported to:\n  %s\n  %s\n', png_file, pdf_file);
