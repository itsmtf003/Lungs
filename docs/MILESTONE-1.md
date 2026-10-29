# Milestone 1: Foundation and Data

Goal: Prove the dataset is real, clean, and safe to train on. Nothing is trained in this milestone.

## What done looks like

- The 5 decisions in `DECISIONS.md` are signed off by the supervisor, or changed in writing.
- ISIC 2017 is downloaded, with source URL, date, and hashes recorded.
- Every image opens. Every label is one of the 3 classes. Every mask matches its image by ISIC id.
- The 70/15/15 split is built, frozen, and has zero overlap between train, validation, and test.
- The repo is set up: GitHub, Kaggle, Colab, and this folder structure.

## Steps

### Step 1.1 Lock the decisions (Week 1)

- Show `DECISIONS.md` to the supervisor.
- Ask the 5 questions in that file. Write the answers and the date in the decision log.
- If the supervisor changes the dataset or the classes, stop and re-plan. Do not train on a dataset the supervisor has not approved.

Owner: whole team. Evidence: signed decisions, updated `DECISIONS.md`.

### Step 1.2 Read the base paper and write the literature notes (Weeks 1-2)

- Read Hussain et al. 2025, EFFResNet-ViT, IEEE Access, vol. 13, pp. 54040-54068.
- Note what it did: 3-model fusion, brain MRI and retinal images, Grad-CAM shown only as pictures.
- Note what it did not do: no skin lesions, no numeric Grad-CAM score.
- Write 1 to 2 pages of notes in `docs/research/` (create that folder when you start). Keep the citation exact.
- Also read 2 to 3 skin lesion Grad-CAM or IoU studies, so the thesis does not claim to be first without checking.

Owner: research lead. Evidence: literature notes, reference list.

### Step 1.3 Set up the tools (Week 2)

- GitHub repo, free. Push this folder as the first commit.
- Kaggle account, free. Turn on GPU in a notebook and confirm a T4 is available.
- Google Colab account, free, as backup.
- Python 3.10 or newer on your laptop, for code checks only (no training on the laptop).
- Install the research package in editable mode on Kaggle or Colab, not on the laptop, for training:
  ```
  pip install -e research/
  ```

Owner: whole team. Evidence: repo URL, Kaggle notebook that runs `import lesion_fyp` without error.

### Step 1.4 Download ISIC 2017 (Weeks 2-3)

- Source: https://challenge.isic-archive.com/data/
- Run:
  ```
  python research/scripts/download_isic2017.py --out research/data/raw
  ```
- The script records the source URL, download date, and SHA256 hash of each file in `research/data/raw/DOWNLOAD_LOG.json`.
- If the download fails, the script reports the failure. Do not write that the download worked when it did not.
- Keep one untouched raw copy. Never edit files in `raw/`. Work on copies.

Owner: data lead. Evidence: `DOWNLOAD_LOG.json`, file counts: 2,000 training images expected.

### Step 1.5 Audit the data (Weeks 3-4)

Run the audit command. It checks, for each row:
- The image file exists and opens as RGB.
- The class label is exactly one of: melanoma, nevus, seborrheic keratosis.
- The mask file exists, matches the image by ISIC id, has the same size, is binary (0 or 1 only), and is not empty.
- No duplicate image id with a different label.
- Exact duplicates found by file hash and by decoded pixel hash.

```
cd research
python -m lesion_fyp.cli audit --manifest data/manifest.csv --report artifacts/audit_report.json
```

Fix the manifest first, not the images. If a mask is missing, that image can still be used for classification, but it is excluded from IoU and the exclusion is counted and reported. See `research/src/lesion_fyp/data/audit.py`.

Owner: data lead. Evidence: `audit_report.json` with zero unexplained failures.

### Step 1.6 Build the frozen split (Weeks 4-5)

- Split: about 70 percent train, 15 percent validation, 15 percent test.
- Group-aware: the same patient, the same lesion, and any duplicate images stay in the same split. Never split a group.
- If patient or lesion ids are missing for some images, say so in the data card. Image-level splitting alone cannot prove patient independence.
- Keep class balance close to the full set in each split.
- Save the split once, in `research/data/split_manifest.csv`, with a hash. Use the same split for all 3 models.
- Check overlap after the split: zero shared image ids, zero shared groups, zero shared duplicates across splits.

```
cd research
python -m lesion_fyp.cli split --manifest data/manifest.csv --out data/split_manifest.csv
```

Owner: data lead. Evidence: `split_manifest.csv`, split counts per class per split, overlap check result = 0.

### Step 1.7 Write the data card (Week 6)

One page. Include: source, release name, download date, class counts, mask coverage per class and per split, split sizes, known limits (for example, missing patient ids), licence, and citation.
Save it as `research/data/DATA_CARD.md` when you write it.

Owner: data lead. Evidence: data card file.

## Milestone 1 exit gate

All of these must be true before Milestone 2 starts. See `docs/CHECKLISTS.md`.

- [ ] Supervisor sign-off recorded in `DECISIONS.md`
- [ ] Manifest is clean: 0 images that fail to open, 0 labels outside the 3 classes, 0 duplicate ids with conflicting labels
- [ ] Masks matched by ISIC id, with mask coverage counted per class
- [ ] Split is frozen, group-aware, 70/15/15, with 0 overlap across splits
- [ ] Data card written
- [ ] `make check` and `make test` pass
