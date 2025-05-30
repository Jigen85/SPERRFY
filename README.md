# SPERRFY: A Data-driven Framework for Realizing Sperry's Chemoaffinity Theory in the Neural Connectome


## Overview

This repository provides a complete framework of SPERRFY (Koike et al., 2025). It implements data-driven models including canonical correlation analysis (CCA), connectome reconstruction, gene similarity analysis, and null model testing. For more information, please see the paper.

## File Structure

| File | Description |
|------|-------------|
| `main_script.m` | Main pipeline for running real mouse connectome analysis and null model evaluation |
| `demonstrations.m` | Lightweight demo script that produces main figures (Figure 3–5 and light version of figure 6) |
| `startup_SPERRFY.m` | Path setup script for MATLAB |
|`+src/` | Source code: analysis runners, result containers, null model generators, etc. |
|`+data/` | Data for analysis: only preprocessed data are published on this github.|




## How to Use

### 1. **Run demonstration**

Use `demonstrations.m` to quickly run a smaller version (25 samples per null model) and generate publication-quality figures.


### 2. **Run full analysis**

Use `main_script.m` for a full analysis run. It will take several hours to complete. This reproduces all the results of (Koike et al., 2025) figures, though there's some dependencies on random numbers. Note thet the signs of the CCA results (e.g. Figure 3e) may be reversed depending on random numbers, though it does not affect the essence of the outcome.




## Requirements

- MATLAB R2024a or newer
- All `.m` classes and functions under `+SPERRFY/`
- Processed data `.mat` files

## Citation

If you use this code, please cite the associated paper (preprint under submission).
