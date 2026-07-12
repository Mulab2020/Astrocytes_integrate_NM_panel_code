% plot_FigS14.m
% 4x3 grid: NE+DA reference vs each delay stage (0s through -10s) + combined
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS14/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS14', 'FigS14_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS14');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
pd = loaded.plot_data;

x_base = double(pd.x_opto_base);
ref_mean = double(pd.ref_mean);
ref_sem = double(pd.ref_sem);
ref1_mean = double(pd.ref1_mean);
ref1_sem = double(pd.ref1_sem);
fnames = cellstr(pd.panel_labels);
disp_names = cellstr(pd.panel_labels_display);
x_lim = double(pd.xlim);
y_lim = double(pd.ylim);
col_ref = [0.1216 0.4667 0.7059];  % slanCM('tab20') stage 1 (NE+DA ref)

% slanCM('tab20') rows for stages 2..12 (0s through -10s)
stage_colors = [
    1.0000 0.7333 0.4706;   % 0s
    0.5961 0.8745 0.5412;   % 1s
    0.8392 0.1529 0.1569;   % 2s
    0.5804 0.4039 0.7412;   % 3s
    0.5490 0.3373 0.2941;   % 5s
    0.7686 0.6118 0.5804;   % 10s
    0.9686 0.7137 0.8235;   % -1s
    0.4980 0.4980 0.4980;   % -2s
    0.7373 0.7412 0.1333;   % -3s
    0.0902 0.7451 0.8118;   % -5s
    0.6196 0.8549 0.8980;   % -10s
];

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [50 50 1050 1150]);
tl = tiledlayout(fig, 4, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

for pi = 1:12
    ax = nexttile(tl, pi);
    hold(ax, 'on');

    if pi == 1
        % Panel 1: all modes combined
        x_fill = [x_base, fliplr(x_base)];
        y_upper = ref1_mean + ref1_sem;
        y_lower = ref1_mean - ref1_sem;
        fill(ax, x_fill, [y_upper, fliplr(y_lower)], col_ref * 0.9, ...
            'FaceAlpha', 0.3, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        plot(ax, x_base, ref1_mean, '-', 'Color', col_ref, 'LineWidth', 2, ...
            'DisplayName', 'NE+DA');

        for si = 1:11
            fn = fnames{si};
            sm = double(pd.([fn '_mean']));
            ss = double(pd.([fn '_sem']));
            sc = stage_colors(si, :);
            y_upper = sm + ss;
            y_lower = sm - ss;
            fill(ax, x_fill, [y_upper, fliplr(y_lower)], sc * 0.9, ...
                'FaceAlpha', 0.3, 'EdgeColor', 'none', 'HandleVisibility', 'off');
            plot(ax, x_base, sm, '-', 'Color', sc, 'LineWidth', 1.5, ...
                'HandleVisibility', 'off');
        end
        title(ax, 'All delays');

    else
        si = pi - 1;
        fn = fnames{si};
        dn = disp_names{si};
        sm = double(pd.([fn '_mean']));
        ss = double(pd.([fn '_sem']));
        sc = stage_colors(si, :);

        % Determine x-axis for stage (negative delays have shifted x)
        if contains(dn, '-')
            shift = double(pd.([fn '_shift']));
            x_stage = x_base - shift;
        else
            x_stage = x_base;
        end

        % NE+DA reference
        x_fill_r = [x_base, fliplr(x_base)];
        y_upper_r = ref_mean + ref_sem;
        y_lower_r = ref_mean - ref_sem;
        fill(ax, x_fill_r, [y_upper_r, fliplr(y_lower_r)], col_ref * 0.9, ...
            'FaceAlpha', 0.3, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        plot(ax, x_base, ref_mean, '-', 'Color', col_ref, 'LineWidth', 2, ...
            'DisplayName', 'NE+DA');

        % Stage trace
        x_fill_s = [x_stage, fliplr(x_stage)];
        y_upper_s = sm + ss;
        y_lower_s = sm - ss;
        fill(ax, x_fill_s, [y_upper_s, fliplr(y_lower_s)], sc * 0.9, ...
            'FaceAlpha', 0.3, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        plot(ax, x_stage, sm, '-', 'Color', sc, 'LineWidth', 1.5, ...
            'DisplayName', dn);

        title(ax, dn);
        legend(ax, 'Location', 'northeast', 'Box', 'off', 'FontSize', 8);
    end

    xlim(ax, x_lim);
    ylim(ax, y_lim);
    xlabel(ax, 'Time (s)');
    ylabel(ax, 'Astrocytes dFF');
    set(ax, 'FontSize', 9, 'LineWidth', 1, 'TickDir', 'out');
    box(ax, 'off');
    hold(ax, 'off');
end

png_file = fullfile(results_dir, 'FigS14.png');
pdf_file = fullfile(results_dir, 'FigS14.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS14 exported to:\n  %s\n  %s\n', png_file, pdf_file);
