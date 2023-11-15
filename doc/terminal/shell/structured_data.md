
# Working with structured data

## JSON


**jq** <badge-stars repo='stedolan/jq'></badge-stars> <badge-doc
href="https://stedolan.github.io/jq/"></badge-doc>

??? Question "JQ cheatsheet"

    <script
    src="https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4.js"></script>


!!! Example  "Prepare cookiecutter templates from `molecule init` outputs"

    ```bash URL=$(you-get --json "https://www.youtube.com/watch?v=ZzfHjytDceU" |
    jq  -s 'sort_by(.streams.__default__.size) | reverse |
    .[0].streams.__default__.src[0]' | sed -e s/\"//g)
    ```

## YAML

**yq** <badge-stars repo='mikefarah/yq'></badge-stars> <badge-doc
href="https://mikefarah.gitbook.io/yq/"></badge-doc>

