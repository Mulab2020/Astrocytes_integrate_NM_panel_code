clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'Fig4', 'Fig4f_distribution_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'Fig4');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
plot_data = loaded.plot_data;

ctrl_color = plot_data.colors.control;
pki_color = plot_data.colors.pki;

fig = figure('Color', 'white', 'Units', 'pixels', 'Position', [100 100 760 260]);
tl = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

for b = 1:plot_data.n_rank_bins
    ax = nexttile(tl);
    hold(ax, 'on');

    histogram(ax, plot_data.bin(b).control_values, ...
        'FaceColor', ctrl_color, 'EdgeColor', 'none', 'FaceAlpha', 0.16, ...
        'Normalization', 'pdf', 'NumBins', plot_data.hist_num_bins);
    histogram(ax, plot_data.bin(b).pki_values, ...
        'FaceColor', pki_color, 'EdgeColor', 'none', 'FaceAlpha', 0.20, ...
        'Normalization', 'pdf', 'NumBins', plot_data.hist_num_bins);

    plot(ax, plot_data.bin(b).control_x_density, plot_data.bin(b).control_density, ...
        '-', 'Color', ctrl_color, 'LineWidth', 2.0);
    plot(ax, plot_data.bin(b).pki_x_density, plot_data.bin(b).pki_density, ...
        '-', 'Color', pki_color, 'LineWidth', 2.0);

    xlim(ax, plot_data.axis.xlim);
    ylim(ax, plot_data.axis.ylim);
    xticks(ax, plot_data.axis.xticks);
    xticklabels(ax, {'0', '0.5', '1'});

    if b == 1
        yticks(ax, plot_data.axis.yticks);
        yticklabels(ax, {'0', '4'});
    else
        yticks(ax, []);
        yticklabels(ax, {});
        ax.YColor = 'none';
    end

    set(ax, 'Box', 'off', 'TickDir', 'out', 'FontName', 'Arial', ...
        'FontSize', 15, 'LineWidth', 1.0, 'Layer', 'top');
end

xlabel(tl, 'Norm. \DeltaF/F0', 'FontName', 'Arial', 'FontSize', 18);
ylabel(tl, plot_data.labels.y, 'FontName', 'Arial', 'FontSize', 18);

png_file = fullfile(results_dir, 'Fig4f_distribution.png');
pdf_file = fullfile(results_dir, 'Fig4f_distribution.pdf');
exportgraphics(fig, png_file, 'Resolution', 600);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');
