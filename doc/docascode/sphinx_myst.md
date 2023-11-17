# Sphinx: MyST


`````{list-table}
---
header-rows: 1
---
* - MyST
  - reStructuredText
* - ````md
    ```{directivename} arguments
    ---
    key1: val1
    key2: val2
    ---
    This is
    directive content
    ```
    ````
  - ```rst
    .. directivename:: arguments
       :key1: val1
       :key2: val2

       This is
       directive content
    ```
`````
