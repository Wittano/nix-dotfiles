import json
import os.path
from typing import Dict


def get_theme(theme: str = "catppuccin_macchiato") -> Dict[str, str]:
    dir = os.path.dirname(os.path.realpath(__file__))
    path = f"{dir}/colors/{theme}.json"

    if not os.path.isfile(path):
        raise FileNotFoundError(f"File {path} not found in {dir}/colors")

    with open(path, "r") as f:
        return json.load(f)
