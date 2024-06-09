Installation:
```bash
pip install --upgrade "skypilot-nightly[aws,cudo,fluidstack,gcp,runpod,azure]"
```

```bash
sky launch --down -c mycluster test-gpu.yaml
sky show-gpus A100-80GB --all-regions
```