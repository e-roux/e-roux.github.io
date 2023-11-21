#  SPDX-FileCopyrightText: 2023-present Emmanuel Roux
#  SPDX-License-Identifier: MIT
"""Just an example module
"""

from __future__ import annotations

import re
from typing import TYPE_CHECKING

from docutils import nodes
from docutils.nodes import Element, Inline
from docutils.parsers.rst import Directive
from sphinx.util.docutils import SphinxRole

if TYPE_CHECKING:
    from docutils.nodes import Node, system_message
    from sphinx.application import Sphinx
    from sphinx.writers.html5 import HTML5Translator

from .__version__ import __version__

GH_REGEX = re.compile(r'\w+\/\w+')


class GhStars(Inline, Element):
    tagname = "div"


class Span(Inline, Element):
    tagname = "span"


class Img(Inline, Element):
    """Some great documentation on Img"""

    tagname = "img"


class _GHSTARs(SphinxRole):
    gh_re = re.compile(r'\w+\/\w+')

    def run(self) -> tuple[list[Node], list[system_message]]:
        if self.gh_re.match(self.text):
            node = GhStars(repo=self.text)
            node.attributes['repo'] = self.text

            # node = nodes.inline(rawtext=self.rawtext, classes=[self.name])
            # spans = self.amp_re.split(self.text)
            # node += nodes.Text(spans.pop(0))
            # for span in spans:
            #     span = span.replace('&&', '&')
            #
            #     letter = nodes.Text(span[0])
            #     accelerator = nodes.inline('', '', letter, classes=['accelerator'])
            #     node += accelerator
            #     node += nodes.Text(span[1:])
            #
            return [node], []

        return [], []

        # msg = inliner.reporter.warning(
        #     f"{text} did not pass github regex validation", line=lineno
        # )
        # return [
        #     nodes.system_message(
        #         msg.msg, level=msg.level, line=lineno, source=rawtext
        #     )
        # ], []


class HelloWorld(Directive):
    def run(self):
        paragraph_node = nodes.paragraph(text='Hello World!')
        return [paragraph_node]


def visit_ghstars_html(self: HTML5Translator, node: GhStars):
    print(node.attributes)
    print(type(node))
    print(type(self))
    # elt = self.starttag(node, 'span')

    self.body.append(
        f"<span class='font-bold'>{node.get('repo').split('/')[-1]} </span>"
    )
    elt = self.starttag(node, "gh-stars", repo=node.get('repo'))
    self.body.append(elt)


def depart_ghstars_html(self, _):
    self.body.append('</gh-stars>')


def setup_extension(app: Sphinx) -> None:
    # app.connect()
    app.add_directive("helloworld", HelloWorld)
    app.add_node(GhStars, html=(visit_ghstars_html, depart_ghstars_html))
    app.add_role("ghstars", _GHSTARs())


def setup(app: Sphinx):
    setup_extension(app)
    return {
        "version": __version__,
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
