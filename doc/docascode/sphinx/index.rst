Sphinx
======

.. toctree::
    :hidden:
    :maxdepth: 2

    docutils
    rst
    myst
    extensions
    referencing
    extending/index

.. grid::
   :gutter: 2 
   :margin: 1 0 0 0
   :padding: 0

   .. grid-item::
      :columns: auto

      .. button-link:: https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#substitution-definitions
         :color: secondary
         
         reST Specification

   .. grid-item::
      :columns: auto

      .. button-link:: https://sphinx-design.readthedocs.io/en/furo-theme/
         :color: secondary
         
         Sphinx{design}

   .. grid-item::
      :columns: auto

      .. button-link:: https://myst-parser.readthedocs.io/en/v0.17.1/syntax/syntax.html
         :color: secondary

         MyST


   .. grid-item::
      :columns: auto

      .. button-link:: https://coderefinery.github.io/sphinx-lesson/md-and-rst
         :color: secondary

         Sphinx-lesson


   .. grid-item::
      :columns: auto

      .. button-link:: https://sublime-and-sphinx-guide.readthedocs.io/en/latest/inline.html
         :color: secondary

         Sublime&Sphinx

.. inline-buttons::

   `link <https://python.org/>`_
   `link2 <https://python.org/>`_

Configuration
-------------

HTML builder output
...................

Custom CSS or JS
~~~~~~~~~~~~~~~~

.. code-block:: python

   # These folders are copied to the documentation's HTML output
   html_static_path = ['_static']

   # These paths are either relative to html_static_path
   # or fully qualified paths (eg. https://...)
   html_css_files = [ 'css/custom.css', ]
   html_js_files = [ 'js/custom.js', ]


Reference
---------

Cross referencing
.................

Cross-referencing in Sphinx comprises references (pointers or links
within documentation) and targets (destinations to which references
point), creating an interconnected documentation structure.

`rtd cross referencing`_


.. tab-set::

   .. tab-item:: reST
      :sync: reST
      :selected: 

      .. code-block:: rest

         .. _My target:

         Some text.

         Reference `My target`_.

         .. or 
         .. _target to paragraph:

         An easy way is just to use the final link of the page/section.
         This works, but it has :ref:`some disadvantages <target to paragraph>`:


   .. tab-item:: MyST
      :sync: reST

      .. code-block:: md

         (My_target)=
         Some text.

         Reference [](My_target).
      

.. _My target:

Some text.

Reference `My target`_.

.. or 
.. _target to paragraph:

An easy way is just to use the final link of the page/section.
This works, but it has :ref:`some disadvantages <target to paragraph>`:


Versioned docs
..............

`sphinx-multiversion <https://github.com/Holzhaus/sphinx-multiversion/tree/master>`_

MyST or RST?
------------

`rtd myst`_.

Advantages of ReST:

- powerful directives and roles
- indented code

Adavantages of MyST:

- tables  

Tables
......

- grid table syntax,
- simple table syntax,
- csv-table syntax,
- or list-table syntax.

Using Jupyter notebooks in sphinx
---------------------------------

`rtd jupyter`_.

API
---

Among the extensions capabilities:

Markup
......



Roles
~~~~~

Builders
........

- [`Builders`]() to support new output formats
- Custom [`Role`](sphapi:#sphinx.application.Sphinx.add_role) and [Directives](sphapi:#sphinx.application.Sphinx.add_directive)

- Hooks

Builders
........

<!-- ```{eval-rst} -->
<!-- .. include:: confluence/sphinx_builder.rst -->
<!-- ``` -->



Glossary
--------

.. glossary::

   Directives
      Generic block of explicit marktup. 

      .. code:: text

         +-------+-------------------------------+
         | ".. " | directive type "::" directive |
         +-------+ block                   |
               |                        |
               +-------------------------------+

   Domain
      Collection of markup (reStructuredText directives and roles) to
      describe and link objects belonging together. Markup elements have
      names like :code:`domain:name`, and typically keep an internal index of
      all entities to aid cross-referencing. Control of the latest can be
      made with the options flags :code:`:no-index:`, :code:`:no-index-entry:`,
      :code:`:no-contents-entry:` and :code:`:no-typesetting:`

      .. code:: rst

         # Python domain directive, in combination with `:no-typestting:` an anchor
         .. py:function:: spam(eggs)
            :no-typesetting:

         .. code::

            def spam(eggs):
               pass

         # role to link back to python objects descriptions
         The function :py:func:`spam` does nothing.

   Explicit Markup

      Used in reST for constructs that need special handling, such as footnotes, specially-highlighted paragraphs, comments, etc. An explicit markup block begins with :code:`..` followed by a whitespace and is terminated by the next paragraph of same indentation level. A block ends before an unindented line.

   Field Lists
      Sequences of field marked like :code:`:fieldname: Field content`. Common in python, e.g.

      .. code:: rst

         def my_function(my_arg, my_other_arg):
            """A function just for me.

            :param my_arg: The first of my arguments.
            :param my_other_arg: The second of my arguments.

            :returns: A message (just for me, of course).
            """

   Roles
      Inline piece of explicit markup, used to provide semantic markup and
      cross-referencing of identifiers. The general syntax is
      :code:`rolename:`content``. 

.. LINKS


.. _rtd cross referencing: https://docs.readthedocs.io/en/stable/guides/cross-referencing-with-sphinx.html
.. _rtd intersphinx: https://docs.readthedocs.io/en/stable/guides/intersphinx.html
.. _rtd jupyter: https://docs.readthedocs.io/en/stable/guides/jupyter.html
.. _rtd myst: https://docs.readthedocs.io/en/stable/guides/migrate-rest-myst.html

