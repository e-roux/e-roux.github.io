Directives
==========


.. py:currentmodule:: docutils.parsers.rst

.. rst-class:: directive 

.. container:: custom-container

    .. autoattribute:: Directive.required_arguments
    .. autoattribute:: Directive.optional_arguments
    .. autoattribute:: Directive.final_argument_whitespace
    .. autoattribute:: Directive.option_spec
    .. autoattribute:: Directive.has_content

.. rst-class:: directive 

.. container:: custom-container

  **Arguments** 

  :required_arguments: Number of required directive arguments
  :optional_arguments: Number of optional arguments after the required arguments.
  :final_argument_whitespace: May the final argument contain whitespace?
  :option_spec: Mapping of option names to validator functions. Function take the option argument, should validate it and raise either :code:`ValueError` or :code:`TypeError`.
  :has_content: May the directive have content?


  **Methods** 

  :run: May the directive have content?

New directives must implement the :meth:sphinx.Sphinx.() method:

Docutils Directives `Sphinx doc <https://www.sphinx-doc.org/en/master/extdev/markupapi.html#docutils.parsers.rst.Directive>`_

`Docutils doc <https://docutils.sourceforge.io/docs/howto/rst-directives.html>`_

`Directives <sphmarkapi:markupapi.html#directives>`_

Registration is done using :meth:`sphinx.application.Sphinx.add_directive` or :meth:`sphinx.application.Sphinx.add_directive_to_domain` methods:

.. code-block:: python

   def setup(app: Sphinx) -> None:
       app.add_directive("my-directive", MyDirective)

