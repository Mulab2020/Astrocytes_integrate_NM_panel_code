% plot_FigS6g_i.m
% 2x3 3D scatter: NE (green) / DA (purple) — Centroid vs Peak vs Off time
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS6/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS6', 'FigS6g_i_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS6');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

color_ne = double(plot_data.color_ne);
color_da = double(plot_data.color_da);
fill_alpha = double(plot_data.fill_alpha);
fish_ids = plot_data.fish_ids;

fig = figure('Color', 'white', 'Position', [50 50 1400 900]);

for fi = 1:6
    ax = subplot(2, 3, fi);
    hold(ax, 'on');

    % Load this fish's data
    x = double(plot_data.(['fish' num2str(fi) '_x']));
    y = double(plot_data.(['fish' num2str(fi) '_y']));
    x_lim = double(plot_data.(['fish' num2str(fi) '_xlim']));
    y_lim = double(plot_data.(['fish' num2str(fi) '_ylim']));
    z_lim = double(plot_data.(['fish' num2str(fi) '_zlim']));

    % NE points (green)
    scatter3(ax, x(1,:), x(3,:), x(2,:), 100, ...
        'MarkerFaceColor', color_ne, 'MarkerEdgeColor', color_ne, ...
        'MarkerFaceAlpha', fill_alpha, 'MarkerEdgeAlpha', 1.0);

    % DA points (purple)
    scatter3(ax, y(1,:), y(3,:), y(2,:), 100, ...
        'MarkerFaceColor', color_da, 'MarkerEdgeColor', color_da, ...
        'MarkerFaceAlpha', fill_alpha, 'MarkerEdgeAlpha', 1.0);

    % View and limits
    view(ax, 70, 30);
    xlim(ax, x_lim);
    ylim(ax, y_lim);
    zlim(ax, z_lim);
    pbaspect(ax, [1.4 2 1]);
    axis(ax, 'vis3d');
    camproj(ax, 'orthographic');

    % Half-step ticks (X axis)
    xt = ax.XTick;
    xt_extra = xt(1:end-1) + diff(xt)/2;
    xt_combined = sort([xt, xt_extra(xt_extra > x_lim(1) & xt_extra < x_lim(2))]);
    ax.XTick = xt_combined;
    xlbl = cell(size(xt_combined));
    for j = 1:length(xt_combined)
        if ismember(xt_combined(j), xt)
            xlbl{j} = num2str(xt_combined(j));
        else
            xlbl{j} = '';
        end
    end
    ax.XTickLabel = xlbl;

    % Half-step ticks (Y axis)
    yt = ax.YTick;
    yt_extra = yt(1:end-1) + diff(yt)/2;
    yt_combined = sort([yt, yt_extra(yt_extra > y_lim(1) & yt_extra < y_lim(2))]);
    ax.YTick = yt_combined;
    ylbl = cell(size(yt_combined));
    for j = 1:length(yt_combined)
        if ismember(yt_combined(j), yt)
            ylbl{j} = num2str(yt_combined(j));
        else
            ylbl{j} = '';
        end
    end
    ax.YTickLabel = ylbl;

    % Half-step ticks (Z axis)
    zt = ax.ZTick;
    zt_extra = zt(1:end-1) + diff(zt)/2;
    zt_combined = sort([zt, zt_extra(zt_extra > z_lim(1) & zt_extra < z_lim(2))]);
    ax.ZTick = zt_combined;
    zlbl = cell(size(zt_combined));
    for j = 1:length(zt_combined)
        if ismember(zt_combined(j), zt)
            zlbl{j} = num2str(zt_combined(j));
        else
            zlbl{j} = '';
        end
    end
    ax.ZTickLabel = zlbl;

    % Labels
    xlabel(ax, 'Centroid (s)');
    ylabel(ax, 'Peak time (s)');
    zlabel(ax, 'Off time (s)');

    % Title = fish N
    title(ax, ['fish' num2str(fi)], 'Interpreter', 'none');

    % Grid
    grid(ax, 'on');
    ax.XMinorGrid = 'off';
    ax.YMinorGrid = 'off';
    ax.ZMinorGrid = 'off';
    ax.GridLineStyle = '-';
    ax.LineWidth = 1.2;
    ax.GridAlpha = 0.25;
    
    view(ax, 70, 18)
    hold(ax, 'off');
end

png_file = fullfile(results_dir, 'FigS6g_i.png');
pdf_file = fullfile(results_dir, 'FigS6g_i.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS6g_i exported to:\n  %s\n  %s\n', png_file, pdf_file);
