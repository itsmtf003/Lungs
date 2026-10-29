# Checklists and Pass Gates

Use these gates. Do not move to the next milestone until the gate passes.
A gate that is skipped is a risk the thesis will have to explain later.

## Milestone 1 gate: data is clean

- [ ] Supervisor sign-off is recorded in `DECISIONS.md`, with date.
- [ ] `research/data/raw/DOWNLOAD_LOG.json` exists, with source URL, date, and hashes.
- [ ] Manifest is clean:
  - [ ] 0 images that fail to open
  - [ ] 0 labels outside melanoma, nevus, seborrheic keratosis
  - [ ] 0 duplicate image ids with conflicting labels
  - [ ] Exact duplicates found by hash are grouped, not silently dropped
- [ ] Masks matched by ISIC id:
  - [ ] Mask count and coverage counted per class and per split
  - [ ] Masks are binary, same size as the image, not empty
  - [ ] Missing masks are counted and excluded from IoU only, not hidden
- [ ] Split is frozen:
  - [ ] 70/15/15, group-aware (patient, lesion, duplicate)
  - [ ] 0 shared image ids across splits
  - [ ] 0 shared groups across splits
  - [ ] 0 shared duplicates across splits
  - [ ] Same split file is used for all 3 models
- [ ] Data card written at `research/data/DATA_CARD.md`
- [ ] `make check` passes
- [ ] `make test` passes

## Milestone 2 gate: models are trained fairly

- [ ] 3 shape tests pass: EfficientNet output (batch, 3), ViT output (batch, 3), Hybrid output (batch, 3)
- [ ] Pilot: loss is finite, gradients are finite and not zero, for all 3 models
- [ ] Checkpoint save, reload, and resume work, and reload gives the same prediction
- [ ] Baselines trained before the hybrid
- [ ] Tuning is limited to the 2 learning rates in `research/configs/train.yaml`, picked by validation macro F1
- [ ] Configs are frozen before final test evaluation
- [ ] 9 final runs exist (E01, E02, E03 x seeds 42, 123, 2026), each with config, environment, history, best checkpoint, metrics
- [ ] Total runs, including tuning, are at most 15 (see `research/experiments/RUN_MATRIX.csv`)
- [ ] Test metrics reported as mean and standard deviation across seeds, with per-class results and confusion matrices
- [ ] Test set used once, after the freeze. No test-set tuning.
- [ ] No invented accuracy number anywhere in the repo, docs, or thesis draft

## Milestone 3 gate: explainability is measured, not just shown

- [ ] Grad-CAM runs for all 3 models, with nonzero gradients checked
- [ ] IoU is measured for all 3 models on the same annotated test cohort
- [ ] Per-image CSV and summary JSON exist for each model (see research/experiments/EXPLAINABILITY_RUN_TEMPLATE.csv)
- [ ] Failure gallery exists: lowest IoU 10 and highest IoU 10, with overlays
- [ ] Excluded masks are counted, with reasons, in summary.json
- [ ] Threshold policy is fixed: primary 0.5, sensitivity 0.3 and 0.7
- [ ] Teacher demo runs in 5 minutes (`python research/scripts/demo_milestone3.py`), with the honest warning shown
- [ ] No IoU number is written anywhere unless it came from a real run or the labelled synthetic demo

## What blocks real training

These are not code problems. They are the real blockers, and they are honest:

1. Dataset download: ISIC 2017 has not been downloaded yet. No `research/data/raw/` files exist.
2. GPU session: No Kaggle or Colab GPU session is running. Training needs one, with about 30 GPU hours per week on Kaggle.
3. Supervisor sign-off: The 5 decisions in `DECISIONS.md` are recommendations until the supervisor agrees.

When those 3 are done, the code in this repo is ready to run.

## What blocks real Milestone 3 evaluation

1. Dataset download: ISIC 2017 has not been downloaded yet. No real masks exist.
2. Training: no checkpoints exist yet. No best.pt in any run folder.
3. The teacher demo is synthetic. It proves the code runs. It is not a real IoU result.
