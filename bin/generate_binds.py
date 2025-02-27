#! /bin/python3
import json
import os

# Define a mapping from modmask values to key names
MODMASK_MAPPING = {
    1: "SHIFT",
    2: "CAPS_LOCK",
    4: "CONTROL",
    8: "ALT",
    16: "NUM_LOCK",
    32: "SUPER",
    64: "SUPER",
    65: "SHIFT+SUPER",
    128: "META"
}

KEYS_MAPPING = {
    'mouse:272': 'LEFT CLICK',
    'mouse:273': 'RIGHT CLICK',
    'mouse:274': 'MIDDLE CLICK',
}


def process_binds():
    hyprbinds_path = os.path.expanduser("~/.tmp/hyprbinds")
    with open(hyprbinds_path, 'r') as f:
        binds = json.load(f)

    hyprland_output_path = os.path.expanduser("~/.tmp/bindings/hyprland")
    os.makedirs(os.path.dirname(hyprland_output_path), exist_ok=True)
    
    with open(hyprland_output_path, 'w') as file:
        for bind in binds:
            key = bind.get('key', 'N/A')
            key = KEYS_MAPPING.get(key, key)
            arg = bind.get('arg', '')
            modmask_value = bind.get('modmask', 0)
            dispatcher = bind.get('dispatcher', '')
            modmask_keys = MODMASK_MAPPING.get(modmask_value, "")
            formatted_line = f"::{modmask_keys} {key}::{arg}::{dispatcher}::\n"
            file.write(formatted_line)

if __name__ == '__main__':
    process_binds()
