#  SPDX-FileCopyrightText: 2023-present Emmanuel Roux
#  SPDX-License-Identifier: MIT
"""Just an example module
"""

from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from sphinx.application import Sphinx

from .__version__ import __version__
from .directives import Exa, Example, HelloWorld, SidePreview
from .roles import GhStars, GhStarsRole, depart_ghstars_html, visit_ghstars_html


def setup_extension(app: Sphinx) -> None:
    # app.connect()
    app.add_directive("helloworld", HelloWorld)
    app.add_directive("sidepreview", SidePreview)
    app.add_directive("example", Example)
    app.add_directive("exa", Exa)
    app.add_node(GhStars, html=(visit_ghstars_html, depart_ghstars_html))
    app.add_role("ghstars", GhStarsRole())


def setup(app: Sphinx):
    setup_extension(app)
    return {
        "version": __version__,
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
