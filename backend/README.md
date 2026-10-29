# Backend: Milestone 4 only

Do not build this now. Milestones 1 and 2 come first.

## Planned stack

Python, FastAPI, PostgreSQL (SQLite allowed for a simple local demo), Docker Compose.

## Planned API, under /api/v1

- GET /health - service and model readiness
- GET /models - approved model releases
- POST /analyses - upload one JPEG or PNG, create a job, returns 202 with analysis id
- GET /analyses/{id} - status and result
- GET /analyses/{id}/report - export a PDF report
- GET /assets/{id} - authorised image or heatmap
- POST /admin/releases/{id}/activate - admin only

## Rules for Milestone 4

- Import the model from `research/src/lesion_fyp/inference.py`. Do not copy model code.
- Load only approved model bundles from `research/artifacts/releases/`.
- A normal upload has no IoU. IoU needs a verified reference mask, from Milestone 3.
- One Grad-CAM task at a time per loaded model, at first. Do not block the API loop with model work.
- Validate the real file content, not just the file name. Limit: 10 MB, JPEG or PNG only.
