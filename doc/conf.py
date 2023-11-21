import os
import re
from datetime import datetime
from os import environ
from typing import TYPE_CHECKING

from docutils.nodes import Element, Inline
from sphinx.util.docutils import SphinxRole

if TYPE_CHECKING:
    from docutils.nodes import Node, system_message
    from sphinx.application import Sphinx
    from sphinx.writers.html5 import HTML5Translator

environ["SPHINX_AUTODOC_RELOAD_MODULES"] = "1"

coverage_statistics_to_report = coverage_statistics_to_stdout = True
exclude_patterns = ["_build"]

# Project informations
author = "Emmanuel Roux"
project = "e-roux"
copyright = f"{datetime.today().year}, {author}"
__version__ = version = release = "0.1.3"

# General configuration
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.doctest",
    "sphinx.ext.todo",
    "sphinx.ext.autosummary",
    "sphinx.ext.extlinks",
    "sphinx.ext.intersphinx",
    "sphinx.ext.viewcode",
    "sphinx.ext.inheritance_diagram",
    "sphinx.ext.coverage",
    "sphinx_design",
    "myst_parser",
    "sphinx_tippy",
    "manux",
]

show_authors = True

templates_path = ["_templates"]

# Internationlization
language = "en"

# ··························································
# Extension: automodule
# ··························································
autodoc_member_order = "groupwise"

# ··························································
# Extension: autosummary
# ··························································
autosummary_generate = False

# ··························································
# Extension: extlinks
# ··························································
extlinks = {
    "duref": (
        "https://docutils.sourceforge.io/docs/ref/rst/"
        "restructuredtext.html#%s",
        "%s",
    ),
    "durole": (
        "https://docutils.sourceforge.io/docs/ref/rst/" "roles.html#%s",
        "%s",
    ),
    "dudir": (
        "https://docutils.sourceforge.io/docs/ref/rst/" "directives.html#%s",
        "%s",
    ),
}

# ··························································
# Extension: intersphinx
# ··························································
intersphinx_mapping = {
    'airflow': ('https://airflow.apache.org', None),
    "jinja2": ("https://jinja.palletsprojects.com/en/3.1.x", None),
    "python": ("https://docs.python.org/3", None),
    "markdown_it": ("https://markdown-it-py.readthedocs.io/en/latest", None),
    "requests": ("https://requests.readthedocs.io/en/latest/", None),
    'sphinx': ('https://www.sphinx-doc.org/en/master', None),
}

# ··························································
# Extension: myst
# ··························································
myst_enable_extensions = ["colon_fence"]

myst_url_schemes = {
    "http": None,
    "https": None,
    "wiki": "https://en.wikipedia.org/wiki/{{path}}#{{fragment}}",
    "jinapi": {
        "url": "https://jinja.palletsprojects.com/en/3.1.x/api/#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
    "sphapi": {
        "url": "https://www.sphinx-doc.org/en/master/extdev/appapi.html#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
}

# ··························································
# Tippy
#
# https://sphinx-tippy.readthedocs.io/en/latest
# ··························································
tippy_rtd_urls = [
    "https://jinja.palletsprojects.com/en/3.1.x",
    "https://www.sphinx-doc.org/en/master/",
    "https://docs.readthedocs.io/en/stable/",
]

# ··························································
# Extension: todo
# ··························································
todo_include_todos = True

# ··························································
# Builder: HTML builder options
#
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
# ··························································
html_theme = "furo"
html_theme_options = {"light_css_variables": {}}
html_extra_path = []
html_theme_path = ["_theme"]
html_static_path = ["_static"]  # Site custom css and js
html_css_files = [
    "css/tippy.css",
]
html_js_files = ["js/extra.js"]
html_title = "My documentation"

# ··························································
# Builder: linkcheck
# ··························································
linkcheck_timeout = 5


# ··························································
# Application interface
# ··························································
class GhStars(Inline, Element):
    pass


class _GHSTARs(SphinxRole):
    gh_re = re.compile(r'\w+\/\w+')

    def run(self) -> tuple[list[Node], list[system_message]]:
        if self.gh_re.match(self.text):
            node = GhStars(repo=self.text)
            node.attributes['repo'] = self.text

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


def visit_ghstars_html(self: HTML5Translator, node: GhStars):
    self.body.append(
        f"<span class='font-bold'>{node.get('repo').split('/')[-1]} </span>"
    )
    elt = self.starttag(node, "gh-stars", repo=node.get('repo'))
    self.body.append(elt)


def depart_ghstars_html(self, _):
    self.body.append('</gh-stars>')


def setup_extension(app: Sphinx) -> None:
    # app.connect()
    ...
    # Does not work:
    # app.add_node(GhStars, html=(visit_ghstars_html, depart_ghstars_html))
    # app.add_role("ghstars", _GHSTARs())


def setup(app):
    setup_extension(app)

    return {
        "version": __version__,
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
