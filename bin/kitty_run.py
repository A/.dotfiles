#!/usr/bin/env python

'''
kitty-tmux script
@author Jongwook Choi <wookayin@gmail.com>
'''

import os
import sys
from typing import Any

import kitty.remote_control

# back up original remote_control.encode_send
kitty.remote_control._encode_send = kitty.remote_control.encode_send


def tmux_aware_encode_send(send: Any) -> bytes:
    """Wrap a encode_send control sequence with tmux pass-through seqeuence."""
    import kitty.remote_control
    b = kitty.remote_control._encode_send(send)
    assert b.startswith(b'\x1b')
    assert b.endswith(b'\x1b\\')
    b = b''.join([
        b'\x1bPtmux;\x1b\x1b',
        b.lstrip(b'\x1b').rstrip(b'\x1b\\'),
        b'\x1b\x1b\\',
        b'\x1b\\'
    ])
    return b

# monkey-patch encode_send()
if 'TMUX' in os.environ:
    kitty.remote_control.encode_send = tmux_aware_encode_send


if __name__ == '__main__':
    first_arg = '' if len(sys.argv) < 2 else sys.argv[1]

    # TODO: This is the first version, so only @remote_control is supported.
    assert first_arg.startswith('@'), (
        "Usage: {} @command args...".format(sys.argv[0])
    )

    from kitty.remote_control import main as rc_main
    rc_main(['@', first_arg[1:]] + sys.argv[2:])
