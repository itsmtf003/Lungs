# Skin Lesion FYP: Milestones 1, 2, and 3
# Run `make help` to list targets. No GPU and no data are needed for check/test.

.PHONY: help check test audit split train-baseline demo clean

help:
	@echo "Targets:"
	@echo "  make check          py_compile every Python file"
	@echo "  make test           run pytest (synthetic fixtures only)"
	@echo "  make audit          audit the manifest (needs research/data/manifest.csv)"
	@echo "  make split          build the frozen split (needs a clean manifest)"
	@echo "  make train-baseline train EfficientNet seed 42 (needs data + GPU)"
	@echo "  make demo           run the Milestone 3 teacher demo (synthetic, no data needed)"
	@echo "  make up             start the Milestone 4 demo (not built yet)"

check:
	find research -name "*.py" -print0 | xargs -0 python3 -m py_compile
	@echo "py_compile passed for all Python files under research/"

test:
	cd research && python3 -m pytest tests/ -v

audit:
	cd research && python3 -m lesion_fyp.cli audit --manifest data/manifest.csv --report artifacts/audit_report.json

split:
	cd research && python3 -m lesion_fyp.cli split --manifest data/manifest.csv --out data/split_manifest.csv

train-baseline:
	cd research && python3 -m lesion_fyp.cli train --config configs/efficientnet.yaml --seed 42

demo:
	python3 research/scripts/demo_milestone3.py

up:
	@echo "Milestone 4 is not built yet. See backend/README.md and frontend/README.md."
	@exit 1

clean:
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete
