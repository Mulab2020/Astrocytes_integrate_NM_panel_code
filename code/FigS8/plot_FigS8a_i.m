% plot_FigS8a_i.m
% 3x3 grid: per-fish SNR mean + SEM shading (NE green, DA purple)
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS8/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS8', 'FigS8a_i_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS8');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

n_fish = double(plot_data.n_fish);
n_cols = double(plot_data.n_cols);
n_rows = ceil(n_fish / n_cols);
color_NE = double(plot_data.color_NE);
color_DA = double(plot_data.color_DA);

fig = figure('Position', [50, 50, 1200, 300 * n_rows], 'Color', 'white');

for fi = 1:n_fish
    ax = subplot(n_rows, n_cols, fi);
    hold(ax, 'on');

    ne_mean = double(plot_data.(['fish' num2str(fi) '_NE_mean']));
    ne_sem  = double(plot_data.(['fish' num2str(fi) '_NE_sem']));
    da_mean = double(plot_data.(['fish' num2str(fi) '_DA_mean']));
    da_sem  = double(plot_data.(['fish' num2str(fi) '_DA_sem']));

    % Ensure column vectors
    ne_mean = ne_mean(:); ne_sem = ne_sem(:);
    da_mean = da_mean(:); da_sem = da_sem(:);

    n_NE = (1:length(ne_mean))';
    n_DA = (1:length(da_mean))';

    % NE SEM shading
    x_fill = [n_NE; flipud(n_NE)];
    y_fill = [ne_mean + ne_sem; flipud(ne_mean - ne_sem)];
    fill(ax, x_fill, y_fill, color_NE, 'FaceAlpha', 0.2, ...
        'EdgeColor', 'none', 'HandleVisibility', 'off');

    % DA SEM shading
    x_fill = [n_DA; flipud(n_DA)];
    y_fill = [da_mean + da_sem; flipud(da_mean - da_sem)];
    fill(ax, x_fill, y_fill, color_DA, 'FaceAlpha', 0.2, ...
        'EdgeColor', 'none', 'HandleVisibility', 'off');

    % NE dots + connecting line
    plot(ax, n_NE, ne_mean, 'o', 'MarkerSize', 4, ...
        'Color', color_NE, 'MarkerFaceColor', color_NE, ...
        'MarkerEdgeColor', color_NE, 'LineStyle', 'none', ...
        'DisplayName', 'NE');
    plot(ax, n_NE, ne_mean, '-', 'LineWidth', 1.5, ...
        'Color', color_NE, 'HandleVisibility', 'off');

    % DA dots + connecting line
    plot(ax, n_DA, da_mean, 'o', 'MarkerSize', 4, ...
        'Color', color_DA, 'MarkerFaceColor', color_DA, ...
        'MarkerEdgeColor', color_DA, 'LineStyle', 'none', ...
        'DisplayName', 'DA');
    plot(ax, n_DA, da_mean, '-', 'LineWidth', 1.5, ...
        'Color', color_DA, 'HandleVisibility', 'off');

    xlabel(ax, 'Cell Number', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel(ax, 'SNR', 'FontSize', 11, 'FontWeight', 'bold');
    title(ax, ['fish' num2str(fi)], 'FontSize', 12, 'FontWeight', 'bold');
    legend(ax, 'FontSize', 10, 'Location', 'best', 'Box', 'off');
    set(ax, 'GridAlpha', 0.2, 'FontSize', 10);

    hold(ax, 'off');
end

png_file = fullfile(results_dir, 'FigS8a_i.png');
pdf_file = fullfile(results_dir, 'FigS8a_i.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS8a_i exported to:\n  %s\n  %s\n', png_file, pdf_file);
