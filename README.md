# Astrocytes integrate neuromodulators — Code and example data

This repository contains the source code and example datasets used to reproduce the figures in the paper, “Astroglia integrate sequential norepinephrine–dopamine signals to drive behavioral state transitions.”

## Directory structure

```
.
├── code/          # Independent MATLAB plotting scripts (one per panel)
├── data/          # Lightweight processed plotting data (.mat)
└── results/       # Rendered figures (.png and .pdf)
```

Each panel has its own subfolder under `code/`, `data/`, and `results/`.

## How to use

1. All scripts were developed and tested on **Windows 11** (MATLAB R2024a).
2. Open MATLAB R2024 and navigate to the panel's `code/` directory, e.g. `code/Fig1/`.
3. Run the corresponding `plot_*.m` script.
4. Outputs are written to `../results/` relative to the script.

All scripts are **self-contained**: they read only the processed `.mat` files in `data/` and do not depend on raw data paths, interactive file selection, or absolute directory references.

## Panel index

### Main figures

| Panel | Script | Description |
|-------|--------|-------------|
| Fig1b | `plot_Fig1b.m` | Multi-neuromodulator calcium traces (Swim / NE / DA) |
| Fig1d | `plot_Fig1d.m` | DA / NE / Ctrl activation traces |
| Fig2c | `plot_Fig2c_heatmap.m` | Three-fish heatmap |
| Fig2d | `plot_Fig2d_trace.m` | DA / NE / NE&DA fish-average traces |
| Fig2e | `plot_Fig2e_heatmap_trace.m` | Heatmap + swim traces |
| Fig3e | `plot_Fig3e_distribution.m` | Swim distribution |
| Fig3f | `plot_Fig3f_trace.m` | NE / DA decoding plot |
| Fig4f | `plot_Fig4f_distribution.m` | PKI / Control distribution |
| Fig4g | `plot_Fig4g_distribution.m` | PKI / WT GU duration distribution |
| Fig4j | `plot_Fig4j_trace.m` | Integration index vs NE-DA interval |

### Supplementary figures

| Panel | Script | Description |
|-------|--------|-------------|
| FigS1b | `plot_FigS1b_DA_trace.m`, `plot_FigS1b_NE_trace.m` | Single-cell + mean calcium traces (DA / NE) |
| FigS1d | `plot_FigS1d_DA_trace.m`, `plot_FigS1d_NE_trace.m` | Neuromodulator release traces (DA / NE) |
| FigS2a | `plot_FigS2a_trace.m` | Astrocytic calcium trace (under DA bath) |
| FigS2b | `plot_FigS2b_trace.m` | Astrocytic calcium trace (under capsaicin bath) |
| FigS4a | `plot_FigS4a_trace.m` | Swim trace (under DA bath) |
| FigS4b | `plot_FigS4b_trace.m` | Swim trace (under capsaicin bath) |
| FigS5a | `plot_FigS5a_trace.m` | NE calcium omparison between optogenetic and physiological condition |
| FigS6g_i | `plot_FigS6g_i.m` | Temporal profiles between DA and NE |
| FigS8a_i | `plot_FigS8a_i.m` | SNR comparison between DA and NE |
| FigS9a | `plot_FigS9a_gfap_rflamp1.m`, `plot_FigS9a_gfap_rflamp1_mut.m` | cAMP struggle-aligned traces (gflamp vs gflamp-mut) |
| FigS10a | `plot_FigS10a.m` | Computational odeling traces (NE / DA / IP3 / PKA / Calcium) |
| FigS11 | `plot_FigS11.m` | Sensitivity test of integration window |
| FigS12 | `plot_FigS12.m` | Astrocytic encoding of Futile-swim rank (PKI vs Control) |
| FigS13 | `plot_FigS13_PKA.m`, `plot_FigS13_calcium.m` | Computational modeling of PKI (PKA / Calcium) |
| FigS14 | `plot_FigS14.m` | Astrocytic calcium under sequential activation |

## Data provenance

- All `data/` files contain only lightweight plotting variables (means, SEMs, axis limits, colors), extracted from the original raw data.

## Colormap

Several heatmap panels share the custom colormap defined in `code/Fig2/rdYlBuBlueWhiteRed.m`. Scripts that depend on it add this directory to the MATLAB path automatically.

## Notes

- Final rendering and visual QA should be performed by the user after running each script.
- Figure formatting (tick spacing, label placement, font sizes) follows the original source scripts but may require minor manual adjustment for publication-ready output.
- The code and data in this repository are associated with an unpublished manuscript.
