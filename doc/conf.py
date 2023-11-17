# Sphinx documentation build configuration file

import os
import re
import time

os.environ["SPHINX_AUTODOC_RELOAD_MODULES"] = "1"

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
]

myst_enable_extensions = ["colon_fence"]

coverage_statistics_to_report = coverage_statistics_to_stdout = True
templates_path = ["_templates"]
exclude_patterns = ["_build"]

project = "e-roux"
copyright = f'2023-{time.strftime("%Y")}, E.R.'
version = "0.0.0"
release = version
show_authors = True

html_theme = "furo"
html_theme_path = ["_themes"]
html_css_files = []
# modindex_common_prefix = []
html_static_path = ["_static"]
html_title = "My documentation"
html_additional_pages = {}
html_use_opensearch = ""
html_baseurl = ""
html_favicon = "_static/favicon.svg"

htmlhelp_basename = "Sphinxdoc"

linkcheck_timeout = 5

autodoc_member_order = "groupwise"
autosummary_generate = False
todo_include_todos = True
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

intersphinx_mapping = {
    "python": ("https://docs.python.org/3/", None),
    "requests": ("https://requests.readthedocs.io/en/latest/", None),
}

# Sphinx document translation with sphinx gettext feature uses these settings:
locale_dirs = ["locale/"]
gettext_compact = False


# -- Extension interface -------------------------------------------------------

from sphinx import addnodes  # noqa: E402

event_sig_re = re.compile(r"([a-zA-Z-]+)\s*\((.*)\)")


def parse_event(env, sig, signode):
    m = event_sig_re.match(sig)
    if not m:
        signode += addnodes.desc_name(sig, sig)
        return sig
    name, args = m.groups()
    signode += addnodes.desc_name(name, name)
    plist = addnodes.desc_parameterlist()
    for arg in args.split(","):
        arg = arg.strip()
        plist += addnodes.desc_parameter(arg, arg)
    signode += plist
    return name


def linkify_issues_in_changelog(app, docname, source):
    """Linkify issue references like #123 in changelog to GitHub."""

    if docname == "changes":
        changelog_path = os.path.join(
            os.path.dirname(__file__), "../CHANGES.rst"
        )
        # this path trickery is needed because this script can
        # be invoked with different working directories:
        # * running make in docs/
        # * running tox -e docs in the repo root dir

        with open(changelog_path, encoding="utf-8") as f:
            changelog = f.read()

        def linkify(match):
            url = "https://github.com/sphinx-doc/sphinx/issues/" + match[1]
            return f"`{match[0]} <{url}>`_"

        linkified_changelog = re.sub(r"(?:PR)?#([0-9]+)\b", linkify, changelog)

        source[0] = source[0].replace(
            ".. include:: ../CHANGES.rst", linkified_changelog
        )


def setup(app):
    from sphinx.ext.autodoc import cut_lines
    from sphinx.util.docfields import GroupedField

    app.connect("autodoc-process-docstring", cut_lines(4, what=["module"]))
    app.connect("source-read", linkify_issues_in_changelog)
    app.add_object_type(
        "confval",
        "confval",
        objname="configuration value",
        indextemplate="pair: %s; configuration value",
    )
    fdesc = GroupedField(
        "parameter", label="Parameters", names=["param"], can_collapse=True
    )
    app.add_object_type(
        "event",
        "event",
        "pair: %s; event",
        parse_event,
        doc_field_types=[fdesc],
    )
