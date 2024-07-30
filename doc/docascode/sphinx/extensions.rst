Extensions
==========

autodoc
    import a module for documention, and pull in documentation from docstrings in a semi-automatic way.

extlinks
   :sphext:`extlinks` enables the creation of custom hyperlink aliases, to
   define and use shorthand notations for external URLs within documentation.

   .. # TODO: this must be converted to example
   .. hint:: 

      Configuration example to use :issue: role with an alias name. 

      .. code-block:: python

         extlinks = {'issue': ('https://github.com/sphinx-doc/sphinx/issues/%s', 'issue %s')}

      For example, ``:issue:`123``` will display as a hyperlink to
      https://github.com/sphinx-doc/sphinx/issues/123.

intersphinx
  link to other projects 

   .. `rtd intersphinx`_.

tippy
    `enables <https://sphinx-tippy.readthedocs.io/en/latest/>`_ tooltip using `tippy.js <https://atomiks.github.io/tippyjs>`_.

    .. rst-class:: directive 

    .. container:: custom-container

        :tippy_add_class:
            Add a class name to all elements with tips

        :tippy_anchor_parent_selector:
            Only show tool tips for anchors within this select (default *""*)

        :tippy_custom_tips:
            A dictionary mapping URLs to HTML strings to create custom tips.

        :tippy_doi_api:
            API to use for DOI tooltips (default *https://api.crossref.org/works/*)

        :tippy_doi_template:
            Jinja template to use for formatting DOI data to tooltips

        :tippy_enable_doitips:
            Enable tooltips for DOI links (default *true*)

        :tippy_enable_mathjax:
            Enable tooltips for math equations (default *False*)

        :tippy_enable_wikitips:
            Enable tooltips for wikipedia links (default *true*)

        :tippy_js:
            The Javascript required to enable tooltips

        :tippy_props:
            Overrides for the tippy.js props to use

        :tippy_rtd_urls:
            List of URL prefixes to use for ReadTheDocs tooltips

        :tippy_skip_anchor_classes:
            Skip showing tooltips for anchors with defined classes

        :tippy_skip_urls:
            A list of URL regexes to skip

        :tippy_tip_selector:
            Elements for which tips are created for

