#  SPDX-FileCopyrightText: 2023-present Emmanuel Roux
#  SPDX-License-Identifier: MIT
"""Just an example module
"""

from __future__ import annotations

import re
from typing import TYPE_CHECKING, Any

from docutils.nodes import Element, Inline, system_message
from docutils.parsers.rst.states import Inliner
from sphinx.util.docutils import SphinxRole
from sphinx.util.nodes import split_explicit_title

from .utils import log

if TYPE_CHECKING:
    from docutils.nodes import Node
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


class GhStarsRole(SphinxRole):
    """ """

    gh_re = re.compile(r'[\w-]+\/\w+')

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

        msg = self.inliner.reporter.warning(
            f"{self.text} did not pass github regex validation",
            line=self.lineno,
        )
        return [
            system_message(
                msg.msg, level=msg.level, line=self.lineno, source=self.rawtext
            )
        ], []


def visit_ghstars_html(self: HTML5Translator, node: GhStars):
    log(context=type(node), msg=node.attributes)

    self.body.append(
        f"<span class='font-bold'>{node.get('repo').split('/')[-1]} </span>"
    )
    elt = self.starttag(node, "gh-stars", repo=node.get('repo'))
    self.body.append(elt)


def depart_ghstars_html(self, _):
    self.body.append('</gh-stars>')


def http_role(
    role,
    rawtext: str,
    text: str,
    linenum: int,
    inliner: Inliner,
    options: dict[str, Any],
    content: list[str],
) -> tuple[list[Node], list[system_message]]:
    """Implementation of the :rst:role:`http` role.

    This is responsible for converting a HTTP status code to link pointing to
    the status documentation, with the full text for the status name.

    Args:
    :param rawtext: The raw text for the entire role.
    :text: The interpreted text content.
    :linenum: The current line number.
    :inliner: The inliner used for error reporting and document tree access.
    :options: options passed for the role (unused).
    :content: list of strings containing content for the role directive (unused).

    :returns: The result of the role. It's a tuple containing two items:

        1) A single-item list with the resulting node.
        2) A single-item list with the error message (if any).
    """

    has_explicit_title, title, target = split_explicit_title(text)

    try:
        status_code = int(target)

        if status_code not in HTTP_STATUS_CODES:
            raise ValueError
    except ValueError:
        msg = inliner.reporter.error(
            'HTTP status code must be a valid HTTP status; '
            '"%s" is invalid.' % target,
            line=linenum,
        )
        prb = inliner.problematic(rawtext, rawtext, msg)
        return [prb], [msg]

    env = inliner.document.settings.env
    http_status_codes_url = env.config.http_status_codes_url

    if not http_status_codes_url or '%s' not in http_status_codes_url:
        msg = inliner.reporter.error(
            'http_status_codes_url must be ' 'configured.', line=linenum
        )
        prb = inliner.problematic(rawtext, rawtext, msg)
        return [prb], [msg]

    ref = http_status_codes_url % status_code

    if has_explicit_title:
        status_code_text = title
    else:
        http_status_codes_format = (
            env.temp_data.get('http-status-codes-format')
            or env.config.http_status_codes_format
        )
        status_code_text = http_status_codes_format % {
            'code': status_code,
            'name': HTTP_STATUS_CODES[status_code],
        }

    node = nodes.reference(rawtext, status_code_text, refuri=ref, **options)

    return [node], []
