# Decisions

Status: RECOMMENDATIONS. All 5 need supervisor sign-off before Week 1 ends.
Nothing here is final until the supervisor agrees. If the supervisor changes one, update this file and the configs that depend on it, and note the date and reason.

## D1. Dataset: ISIC 2017

- Decision: Use ISIC 2017 training images with matching classification labels and lesion segmentation masks.
- Why: It has both labels and masks for the same images. That is needed for the IoU work. It is a clean, small starting set: 2,000 images.
- Source: https://challenge.isic-archive.com/data/
- Risk if changed: A different ISIC release may have different classes, different mask coverage, or no masks at all. Re-audit before training.
- Needs sign-off: Yes.

## D2. Classes: 3 classes

- Decision: melanoma, nevus, seborrheic keratosis.
- Why: These are the 3 native classes in ISIC 2017. The counts are 374 melanoma, 254 seborrheic keratosis, 1,372 nevi.
- Note: The proposal gave BCC (basal cell carcinoma) as an example class. BCC does not exist in ISIC 2017. Do not add BCC unless a different dataset with verified BCC labels and masks is found and audited first.
- Needs sign-off: Yes. Ask the supervisor: is 3 classes enough, or is a 4th class compulsory?

## D3. ViT size: ViT-Small

- Decision: ViT-Small, patch size 16, input 224 x 224.
- Why: It fits in a free Kaggle or Colab GPU (about 12 to 16 GB VRAM) with batch size 16. A larger ViT would need more memory and more time.
- Hybrid detail: EfficientNet final features are B x 1280 x 7 x 7. A 1x1 projection makes 384 channels. Flatten to 49 tokens. The ViT-Small encoder keeps its pretrained class token. Its 14x14 positional grid is interpolated to 7x7. This is documented in `research/src/lesion_fyp/models/hybrid.py`.
- Needs sign-off: Yes. Ask the supervisor: is ViT-Small acceptable, or is exact reproduction of the base paper required?

## D4. Demo scope: single-user local demo

- Decision: The web app (Milestone 4) is a single-user demo that runs locally on one laptop with Docker Compose.
- Why: It is the safest setup for a defence. No internet, no hosting, no login system to break. The supervisor or examiner can still upload an image, see a prediction and a heatmap, and export a report.
- What is left out for now: shared accounts, saved history for many users, public registration, hospital integration. These are later extensions, not part of this FYP.
- Needs sign-off: Yes.

## D5. GPU and training platform: Kaggle first, Colab as backup

- Decision: Train on Kaggle Notebooks first. Google Colab free is the backup.
- Why: Kaggle gives about 30 free GPU hours per week, with sessions up to 12 hours, and the quota is more predictable than Colab free. Colab free GPU access is not guaranteed and its limits change.
- Cost: Rs 0. No credit card is needed for either free tier.
- Rule: Save every checkpoint and run log outside the notebook session, to `research/artifacts/`, before the session ends. A notebook session is temporary.
- Needs sign-off: No, this is a practical choice. Tell the supervisor, do not wait for approval. If the university gives a GPU, use that instead and note it here.

## Decision log

| Date | Decision | Changed by | Reason |
|---|---|---|---|
| 2026-10-27 | D1 to D5 written as recommendations | Student + Muse | First draft from proposal and complete plan |
| | | | |
