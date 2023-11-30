# SPDX-FileCopyrightText: 2023-present Emmanuel Roux
# SPDX-License-Identifier: MIT

from docutils import nodes
from docutils.nodes import Admonition, Element
from docutils.parsers.rst import Directive
from docutils.parsers.rst.directives.admonitions import BaseAdmonition
from docutils.statemachine import ViewList
from sphinx.util.nodes import set_source_info


class HelloWorld(Directive):
    def run(self):
        self.severe(f"*" * 80)
        self.severe(f"Got {self.content}")
        paragraph_node = nodes.paragraph(text='Hello World!')
        return [paragraph_node]


class SidePreview(Directive):
    """Display rst code and html preview side by side"""

    required_arguments = 0
    optional_arguments = 0
    has_content = True

    def run(self):
        # Client code must handle the case where content is required but not supplied (an empty content list is supplied)
        if not self.content:
            raise self.error('Content is required in the directive block')

        # Create a container node to hold the RST code and interpreted output
        container_node = nodes.container(classes=['side-preview'])

        self.error(f"*" * 80)
        self.error(f"GOT {self.content}")
        # Process and display the RST code on the left
        code_block = nodes.literal_block(self.content[0], self.content[0])
        code_block['language'] = 'rst'  # Set the language to RST
        container_node += code_block

        # Convert the content to HTML for the interpreted output on the right
        output_html = self.state.document.settings.record_dependencies
        self.state.nested_parse(
            ViewList([self.content[0]], source=''), 0, container_node
        )
        output_div = container_node.children[
            -1
        ]  # The last child is the output div
        output_html = nodes.raw('', output_div.astext(), format='html')
        set_source_info(self, output_html)
        container_node += output_html

        return [container_node]


class ExampleAdmonition(nodes.Admonition, nodes.Element):
    pass


class Example(Directive):
    has_content = True
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = {}

    def run(self):
        # Create a container for the content
        container = nodes.container()
        self.state.nested_parse(self.content, self.content_offset, container)

        # Create a custom admonition node
        tip_node = ExampleAdmonition()
        tip_node += nodes.title(
            'Example', 'Example'
        )  # Custom title for the admonition
        tip_node += container

        return [tip_node]


class exa(Admonition, Element):
    pass


class Exa(BaseAdmonition):
    node_class = exa
