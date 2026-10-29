# Skin Lesion Classification FYP

Explainable EfficientNet-ViT Hybrid Model for Skin Lesion Classification with Quantitative Grad-CAM Evaluation.

## What this project does, in simple words

1. Take a dermoscopic photo of a skin lesion.
2. An AI model guesses the type: melanoma, nevus, or seborrheic keratosis.
3. The model also shows where it looked in the photo, with a Grad-CAM heatmap.
4. We measure, with a number, if it looked at the right place. That number is IoU, the overlap between the heatmap and the doctor's lesion mask.

## Base paper

EFFResNet-ViT, Hussain et al., IEEE Access, 2025.
The base paper used three models (EfficientNet-B0 + ResNet-50 + ViT) on brain MRI and retinal images, and showed Grad-CAM only as pictures.
This project uses two models (EfficientNet-B0 + ViT), on ISIC skin lesions, and measures Grad-CAM with IoU. That is the main new idea.

## Dataset

ISIC 2017, training set.
2,000 images: 374 melanoma, 254 seborrheic keratosis, 1,372 nevi.
Each image has a matching segmentation mask.
Input size: 224 x 224. Split: 70 percent train, 15 percent validation, 15 percent test.
The split is group-aware (patient, lesion, duplicate) and frozen in a manifest. See `research/data/README.md`.

## Models

Three models, same data, same split, same rules:
- E01 EfficientNet-B0 only (baseline)
- E02 ViT-Small only (baseline)
- E03 Hybrid: EfficientNet-B0 + ViT-Small (proposed)

Final runs: 9 in total (3 models x 3 seeds: 42, 123, 2026).
Tuning allowance: at most 15 runs in total, including tuning. See `research/experiments/RUN_MATRIX.csv`.

## Free stack, cost Rs 0

No paid API is used anywhere. No OpenAI, no Gemini, no paid cloud vision API.
- Dataset: ISIC 2017, free download from https://challenge.isic-archive.com/data/
- Training GPU: Kaggle Notebooks first (about 30 GPU hours per week, free), Google Colab free as backup
- Code: Python, PyTorch, timm, pytorch-grad-cam, scikit-learn, all free and open source
- Web app (Milestone 4): FastAPI backend, React + TypeScript + Vite frontend, PostgreSQL, Docker Compose, all free
- Demo: run locally on your own laptop. No hosting cost, no internet needed at defence time.

Your own API is FastAPI. You build it. It is not an outside service.

## Repo layout

```
skin-lesion-fyp/
  README.md, DECISIONS.md, Makefile, compose.yaml, .env.example
  docs/                  Milestone 1, Milestone 2, execution checklist
  research/
    configs/             data, train, model, eval settings (YAML)
    src/lesion_fyp/      the research package: data, models, training, evaluation, explainability, inference
    data/                manifest template only. Real data is NOT in git.
    scripts/             download_isic2017.py
    notebooks/           audit notebook, Kaggle training starter notebook
    tests/               pytest, synthetic fixtures only
    artifacts/           run outputs go here, not in git
    experiments/         RUN_MATRIX.csv, experiment log template
  backend/               Milestone 4 only. README now, code later.
  frontend/              Milestone 4 only. README now, code later.
```

## How to run Milestone 1, then Milestone 2

### Milestone 1: Foundation and Data (Weeks 1-6 in the 24-week plan)

1. Read `docs/MILESTONE-1.md` and `DECISIONS.md`. Get the 5 decisions signed off by the supervisor.
2. Create a GitHub repo and a Kaggle account. Both free.
3. Download ISIC 2017:
   ```
   python research/scripts/download_isic2017.py --out research/data/raw
   ```
   The script records the source URL, date, and file hashes. It reports if the download failed. It does not claim success it did not check.
4. Audit the data:
   ```
   cd research
   python -m lesion_fyp.cli audit --manifest data/manifest.csv --report artifacts/audit_report.json
   ```
5. Build the frozen split:
   ```
   python -m lesion_fyp.cli split --manifest data/manifest.csv --out data/split_manifest.csv
   ```
6. Check the Milestone 1 gate in `docs/CHECKLISTS.md`. Do not start Milestone 2 until it passes.

### Milestone 2: Models (Weeks 7-12)

1. Read `docs/MILESTONE-2.md`.
2. On Kaggle or Colab, open `research/notebooks/kaggle_train_starter.ipynb`. Run the tiny shape and gradient pilot first.
3. Run the baselines, then the hybrid, with the CLI:
   ```
   python -m lesion_fyp.cli train --config configs/efficientnet.yaml --seed 42
   python -m lesion_fyp.cli train --config configs/vit.yaml --seed 42
   python -m lesion_fyp.cli train --config configs/hybrid.yaml --seed 42
   ```
   Repeat for seeds 123 and 2026. That is the 9-run matrix.
4. Evaluate on the test set only once, after all training is locked:
   ```
   python -m lesion_fyp.cli evaluate --config configs/eval.yaml --run artifacts/runs/E03-hybrid-seed42
   ```
5. Check the Milestone 2 gate in `docs/CHECKLISTS.md`.

### Milestone 3: Grad-CAM and IoU (see docs/MILESTONE-3.md)

1. Read `docs/MILESTONE-3.md` and `docs/TEACHER-DEMO.md`.
2. Teacher demo, no dataset and no checkpoint needed (synthetic image, clearly labelled):
   ```
   python research/scripts/demo_milestone3.py
   ```
   Or from research/: `python -m lesion_fyp.cli explain-demo`
   Outputs go to `research/artifacts/demo_m3/`: overlay PNGs, `demo_summary.json`, `demo_report.md`.
   Honest warning: this proves the code runs. It does not prove the trained model is good.
3. Real evaluation, after Milestones 1 and 2 are done:
   ```
   python -m lesion_fyp.cli explain --manifest data/split_manifest.csv --model hybrid_efficientnet_vit --run artifacts/runs/E03-hybrid-seed42 --out artifacts/explain/E03-hybrid-seed42
   ```
   Repeat for the other 2 models, on the same cohort. Check the Milestone 3 gate in `docs/CHECKLISTS.md`.

### Quick checks on any machine (no GPU, no data needed)

```
make check
make test
```

`make check` runs `python3 -m py_compile` on every Python file.
`make test` runs pytest. Tests use small synthetic data only, and skip model tests if torch is not installed.

## What is NOT done yet

- No dataset has been downloaded. `research/data/` has a template manifest only.
- No model has been trained. No checkpoint exists. No accuracy number exists anywhere in this repo.
- Milestone 3 code is built (Grad-CAM, IoU, cohort runner, teacher demo). The real IoU is not done yet: no trained checkpoints and no real ISIC masks exist, so no real IoU number exists. The demo uses a synthetic image and is labelled as such.
- Milestone 4 (web app) is READMEs only. No backend or frontend code yet. `compose.yaml` is a draft for Milestone 4.
- The 5 decisions in `DECISIONS.md` are recommendations. They need supervisor sign-off.

## Rules for this repo

- Simple plain English in docs. Short sentences.
- No invented results. No accuracy numbers until a real run produces them.
- The test set is used once, after training is locked. Never tune on the test set.
- Large files (data, checkpoints, uploads) are never committed to git. See `.gitignore`.
