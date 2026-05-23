# Helper script used by Jenkins to update image tags in Helm values files during CI/CD.

import re
import sys
from pathlib import Path


if len(sys.argv) != 3:
    raise SystemExit("Usage: update_helm_values.py <environment> <image-tag>")

environment = sys.argv[1]
image_tag = sys.argv[2]
values_file = Path(f"helm/platform-stack/values-{environment}.yaml")
content = values_file.read_text(encoding="utf-8")
content = re.sub(r"image: acme/([\w-]+):[\w.-]+", rf"image: acme/\1:{image_tag}", content)
values_file.write_text(content, encoding="utf-8")
