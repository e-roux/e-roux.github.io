from datetime import datetime
from os import environ
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from sphinx.application import Sphinx

environ["SPHINX_AUTODOC_RELOAD_MODULES"] = "1"

coverage_statistics_to_report = coverage_statistics_to_stdout = True
exclude_patterns = ["_build", "blog"]

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
    "sphinxcontrib.svgbob",
    "sphinx_togglebutton",
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
    "sphext": (
        "https://www.sphinx-doc.org/en/master/usage/extensions/%s.html",
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
myst_enable_extensions = ["colon_fence", "deflist"]

myst_url_schemes = {
    "http": None,
    "https": None,
    "wiki": "https://en.wikipedia.org/wiki/{{path}}#{{fragment}}",
    "git": {
        "url": "https://git-scm.com/docs/{{path}}#{{fragment}}",
        "title": "Git: #{{fragment}}",
    },
    "jinapi": {
        "url": "https://jinja.palletsprojects.com/en/3.1.x/api/#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
    "jintpl": {
        "url": "https://jinja.palletsprojects.com/en/3.1.x/templates/#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
    "nushell": {
        "url": "https://www.nushell.sh/book/{{path}}.html#{{fragment}}",
        "title": "NuShell: #{{fragment}}",
    },
    "sphmarkapi": {
        "url": "https://www.sphinx-doc.org/en/master/extdev/markupapi.html#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
    "sphapi": {
        "url": "https://www.sphinx-doc.org/en/master/extdev/appapi.html#{{fragment}}",
        "title": "API: #{{fragment}}",
    },
    "pytapi": {
        "url": "https://docs.pytest.org/en/stable/reference/reference.html#{{fragment}}",
        "title": "Pytest API: {{path}}",
    },
    "zshmod": {
        "url": "https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002f{{fragment}}-Module",
        "title": "ZSH module : {{fragment}}",
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
    "https://sphinx-tippy.readthedocs.io/en/latest/",
    "https://docs.pytest.org/en/stable/",
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
html_theme_options = {
    "light_css_variables": {},
}
html_extra_path = []
html_theme_path = ["_theme"]
html_static_path = ["_static"]  # Site custom css and js
html_css_files = [
    "css/override.css",
    "css/tailwind.css",
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


def setup_extension(app: Sphinx) -> None:
    ...


def setup(app):
    setup_extension(app)

    return {
        "version": __version__,
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
