# d3.js

## Manipulating the DOM 

### Select some data

D3 has two methods for selection: `d3.select()` and `d3.selectAll()` used to select the first/all element(s) that matches the selector string.

```js
d3.select("h1");
d3.select("#intro");
d3.select(".intro");
d3.select("h1.intro");
d3.selectAll("h1, .intro");
```

### Append elements

Add elements to the DOM using `selection.append()`.
```js
const selection = d3.select("body");
selection.append("p");
```

### Setting and modifying attributes

Attributes can be set and modified using `selection.attr(...)`:

```js
selection.attr("id", "my-id");
selection.attr("viewBox", "0 0 1280 640");
```

Styles are set and modified using `selection.style(...)`

```js
selection.style("color", "red");
```
