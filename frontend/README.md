# Frontend: Milestone 4 only

Do not build this now. Milestones 1 and 2 come first.

## Planned stack

TypeScript, React, Vite. HTML and CSS through React. Responsive, works on laptop and phone.

## Planned screens

- Home at / - purpose, accepted input, start an analysis
- Analyze at /analyze - file picker, preview, model selector
- Result at /analyses/:id - image, class scores, heatmap, model version
- Experiments at /experiments - 3-model comparison, class metrics, sample counts
- Run at /experiments/:id - curves, confusion matrix, ROC, IoU summaries
- History at /history - saved analyses, only if accounts are enabled
- Methodology at /methodology - dataset, model, and metric explanations
- Sign in at /login - only if shared access is enabled
- Admin at /admin - releases, imports, failed jobs

## Rules for Milestone 4

- Show the model version and class scores on every result.
- Show that IoU is not available for a normal upload. IoU is a research metric, from Milestone 3.
- Do not use heatmap colour alone to show the class or the job status.
- Keep every action usable with a keyboard.
- Do not show invented performance numbers. Show only numbers from real run folders.
