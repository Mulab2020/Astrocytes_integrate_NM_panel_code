% plot_FigS12.m
% Futile-swim rank vs astroglial calcium scatter (PKI blue, Control gray)
% Reads processed plot_data, outputs PNG and PDF to ../results/FigS12/

clear; clc;

script_dir = fileparts(mfilename('fullpath'));
root_dir = fileparts(fileparts(script_dir));
data_file = fullfile(root_dir, 'data', 'FigS12', 'FigS12_plot_data.mat');
results_dir = fullfile(root_dir, 'results', 'FigS12');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

loaded = load(data_file);
x_rank = double(loaded.valid_swim_ids(:));
y_pki  = double(loaded.X_pos(:)) * 100;
y_neg  = double(loaded.X_neg(:)) * 100;

valid = ~isnan(x_rank) & ~isnan(y_pki) & ~isnan(y_neg);
x_rank = x_rank(valid);
y_pki  = y_pki(valid);
y_neg  = y_neg(valid);

% Colors
col_PKI  = [0.10 0.45 0.75];
col_ctrl = [0.50 0.50 0.50];

% Jitter
rng(1);
x_jitter_neg = 0.10 * randn(size(x_rank));
x_jitter_pki = 0.10 * randn(size(x_rank));

fig = figure('Color', 'w', 'Position', [200 200 520 430]);
hold on;

% Scatter
scatter(x_rank + x_jitter_neg, y_neg, 42, ...
    'MarkerFaceColor', col_ctrl, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceAlpha', 0.65, 'MarkerEdgeAlpha', 0.35, ...
    'DisplayName', 'Control');

scatter(x_rank + x_jitter_pki, y_pki, 42, ...
    'MarkerFaceColor', col_PKI, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceAlpha', 0.65, 'MarkerEdgeAlpha', 0.35, ...
    'DisplayName', 'PKI');

% Linear fit + 95% CI
x_fit = linspace(min(x_rank), max(x_rank), 200)';

% Control
mdl_neg = fitlm(x_rank, y_neg);
[yfit_neg, yci_neg] = predict(mdl_neg, x_fit);
fill([x_fit; flipud(x_fit)], [yci_neg(:,1); flipud(yci_neg(:,2))], ...
    col_ctrl, 'FaceAlpha', 0.18, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(x_fit, yfit_neg, '-', 'Color', col_ctrl, 'LineWidth', 2.2, 'HandleVisibility', 'off');

% PKI
mdl_pki = fitlm(x_rank, y_pki);
[yfit_pki, yci_pki] = predict(mdl_pki, x_fit);
fill([x_fit; flipud(x_fit)], [yci_pki(:,1); flipud(yci_pki(:,2))], ...
    col_PKI, 'FaceAlpha', 0.18, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(x_fit, yfit_pki, '-', 'Color', col_PKI, 'LineWidth', 2.2, 'HandleVisibility', 'off');

% Annotation
r_pki = mdl_pki.Rsquared.Ordinary;
r_neg = mdl_neg.Rsquared.Ordinary;
p_pki = mdl_pki.Coefficients.pValue(2);
p_neg = mdl_neg.Coefficients.pValue(2);

x_text = min(x_rank) + 0.05 * range(x_rank);
y_top  = max([y_neg; y_pki]);
y_rng  = range([y_neg; y_pki]);

% text(x_text, y_top - 0.05*y_rng, ...
%     sprintf('Control: R = %.2f, p = %.2g', sqrt(r_neg), p_neg), ...
%     'Color', col_ctrl, 'FontSize', 12, 'FontWeight', 'bold');
% 
% text(x_text, y_top - 0.17*y_rng, ...
%     sprintf('PKI: R = %.2f, p = %.2g', sqrt(r_pki), p_pki), ...
%     'Color', col_PKI, 'FontSize', 12, 'FontWeight', 'bold');

% Formatting
xlabel('Futile-swim rank');
ylabel('\DeltaF/F (%)');
legend('Location', 'best', 'Box', 'off');
set(gca, 'Box', 'off', 'TickDir', 'out', 'FontSize', 12, 'LineWidth', 1.1);
xlim([min(x_rank)-0.8, max(x_rank)+0.8]);

hold off;

png_file = fullfile(results_dir, 'FigS12.png');
pdf_file = fullfile(results_dir, 'FigS12.pdf');
exportgraphics(fig, png_file, 'Resolution', 300);
exportgraphics(fig, pdf_file, 'ContentType', 'vector');

fprintf('FigS12 exported to:\n  %s\n  %s\n', png_file, pdf_file);
