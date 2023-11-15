
/**
 * Represents a Badge.
 * @constructor
 * @param {string} title - The title of the book.
 * @param {string} author - The author of the book.
 */
class Badge extends HTMLElement {
  //
  constructor() {
    // Always call super first in constructor
    super();

    // Create a documentation badge
    var shadow = this.attachShadow({mode: 'open'});

    var wrapper = document.createElement('span');
    wrapper.setAttribute('class','myBadge');

    // badge attributes
    var alt = this.hasAttribute('alt')?this.getAttribute('alt'):'Documentation';
    var color = this.hasAttribute('color')?this.getAttribute('color'):'brightgreen';
    var href = this.hasAttribute('href')?this.getAttribute('href'):'img/default.png';
    var label = this.hasAttribute('label')?this.getAttribute('label'):'docs';
    var logo = this.hasAttribute('logo')?this.getAttribute('logo'):'Read-the-docs';
    var message = this.hasAttribute('message')?this.getAttribute('message'):'stable';

    var src = `https://img.shields.io/badge/${label}-${message}-${color}?style=flat&logo=${logo}`;
    var src = `https://img.shields.io/badge/-${label}-fcfcfc?logo=${logo}&logoColor=gray`;
    // var src = `https://img.shields.io/badge/-f5f5f5?style=flat&labelColor=f5f5f5&logoColor=black&logo=${logo}&label=${label}`;

    const link = document.createElement('a');
    link.setAttribute('target','_blank');
    link.setAttribute('href', href);

    const img = document.createElement('img');
    img.setAttribute('src', src);
    img.setAttribute('alt', alt);
    img.setAttribute('style', 'vertical-align: text-bottom;');

    shadow.appendChild(wrapper);
    wrapper.appendChild(link);
    link.appendChild(img);
  }
}

class StarsBadge extends Badge {
  constructor() {
    super();

    var repo = this.hasAttribute('repo')?this.getAttribute('repo'):'';

    var img = this.shadowRoot.children[0].getElementsByTagName('img')[0];
    img.setAttribute('src', `https://img.shields.io/github/stars/${repo}?style=social&label=☆`);

    var link = this.shadowRoot.children[0].getElementsByTagName('a')[0];
    link.setAttribute('href', `https://github.com/${repo}`);

  }
}

class PEPBadge extends Badge {
  constructor() {
    super();

    var nr = this.hasAttribute('nr')?this.getAttribute('nr'):'';
    var pep = new Intl.NumberFormat("en", { minimumIntegerDigits: 4, useGrouping:false }).format(nr);

    var img = this.shadowRoot.children[0].getElementsByTagName('img')[0];
    img.setAttribute('src', `https://img.shields.io/badge/PEP-${nr}-ffd43b?logo=Python&style=flat&labelColor=306998&logoColor=white`);

    var link = this.shadowRoot.children[0].getElementsByTagName('a')[0];
    link.setAttribute('href', `https://www.python.org/dev/peps/pep-${pep}`);

  }
}


class DocBadge extends Badge {
  constructor() {
    super();

  }
}


class WikiBadge extends Badge {
  constructor() {
    super();

    var url = `https://img.shields.io/badge/--fcfcfc?logo=Wikipedia&logoColor=gray`;

    const img = this.shadowRoot.children[0].getElementsByTagName('img')[0];


		// Need CORS for that
		// https://developer.mozilla.org/fr/docs/Web/HTTP/CORS

		var myHeaders = new Headers({
			'Access-Control-Allow-Origin': '*',
			'Access-Control-Allow-Method': 'GET'
		});

		console.log(myHeaders.get('Access-Control-Allow-Origin')); // doit retourner 'text/xml'

		console.log(myHeaders);


		var fetchCfg = {
			method: 'GET',
			headers: myHeaders,
			mode: 'cors',
			cache: 'default' 
		};

		console.log(fetchCfg.headers);

    fetch(url, fetchCfg)
    .then(r => r.text())
		.then(function(resp) {
			// const objectURL = URL.createObjectURL(myBlob);
			// img.src = k;
			console.log("yo");
			console.log(resp);
			
		})
    .catch(console.error.bind(console));


    // img.setAttribute('src', src);
  }
}


customElements.define('badge-doc', DocBadge);
customElements.define('badge-stars', StarsBadge);
customElements.define('badge-pep', PEPBadge);
customElements.define('badge-wiki', WikiBadge);


const uml = (converter, className, settings) => {

  const getFromCode = function(parent) {
    // Handles <pre><code>
    let text = ""
    for (let j = 0; j < parent.childNodes.length; j++) {
      const subEl = parent.childNodes[j]
      if (subEl.tagName.toLowerCase() === "code") {
        for (let k = 0; k < subEl.childNodes.length; k++) {
          const child = subEl.childNodes[k]
          const whitespace = /^\s*$/
          if (child.nodeName === "#text" && !(whitespace.test(child.nodeValue))) {
            text = child.nodeValue
            break
          }
        }
      }
    }
    return text
  }

  const getFromDiv = (parent) => parent.textContent || parent.innerText;

  // Change article to whatever element your main Markdown content lives.
  const article = document.querySelectorAll("article")
  const blocks = document.querySelectorAll(`pre.${className},div.${className}`)

  // Is there a settings object?
  const config = (settings === void 0) ? {} : settings

  // Find the UML source element and get the text
  for (let i = 0; i < blocks.length; i++) {
    const parentEl = blocks[i]
    const el = document.createElement("div")
    el.className = className
    el.style.visibility = "hidden"
    el.style.position = "absolute"

    const text = (parentEl.tagName.toLowerCase() === "pre") ? getFromCode(parentEl) : getFromDiv(parentEl)

    // Insert our new div at the end of our content to get general
    // typeset and page sizes as our parent might be `display:none`
    // keeping us from getting the right sizes for our SVG.
    // Our new div will be hidden via "visibility" and take no space
    // via `position: absolute`. When we are all done, use the
    // original node as a reference to insert our SVG back
    // into the proper place, and then make our SVG visible again.
    // Lastly, clean up the old node.
    article[0].appendChild(el)
    

    const diagram = converter.parse(text)
    diagram.drawSVG(el, config)
    el.style.visibility = "visible"
    el.style.position = "static"
    parentEl.parentNode.insertBefore(el, parentEl)
    parentEl.parentNode.removeChild(parentEl)
  }
}

(() => {
  const onReady = function(fn) {
    if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", fn)
    } else {
      document.attachEvent("onreadystatechange", () => {
        if (document.readyState === "interactive")
          fn()
        
      })
    }
  }

  onReady(() => {

    if (typeof flowchart !== "undefined")
      uml(flowchart, "uml-flowchart")
  
    if (typeof Diagram !== "undefined"){
      uml(Diagram, "uml-sequence-diagram", {theme: "simple"})
    }

    if (typeof Treant !== "undefined"){
      uml(Treant, "uml-treediagram")
    }


  })
})()

