# SPDX-FileCopyrightText: 2023-present Emmanuel Roux
# SPDX-License-Identifier: MIT

from typing import Mapping

from colorama import Fore, Style


def _log(text, *, colour):
    print(f"{Fore.GREEN}[manux] {colour}{text}{Style.RESET_ALL}")


def log(*, context=None, msg=None):
    """Show context and command-to-be-executed, with nice formatting and colors."""
    if context is not None:
        _log(context, colour=Fore.CYAN)
    if msg is not None:
        assert isinstance(msg, (Mapping))
        _log(f"> {msg.get('repo')}", colour=Fore.BLUE)
