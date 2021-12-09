class Avatar extends HTMLElement {
  //
  constructor() {
    // Always call super first in constructor
    super();

    // Create a documentation badge
    const shadow = this.attachShadow({ mode: "open" });
    const wrapper = document.createElement("div");

    wrapper.setAttribute(
      "style",
      "width:inherit; height:inherit; position:absolute; top:10px; right: 100px; display: block; transition: visibility 0.5s, opacity 0.5s ease-in-out;"
    );
    // badge attributes
    const src = this.getAttribute("src") || "";

    const link = document.createElement("a");
    link.setAttribute("title", document.title);
    link.setAttribute("href", document.URL);
    link.setAttribute("style", "width:inherit; height:inherit;");

    const img = document.createElement("img");
    img.setAttribute("src", src);
    img.setAttribute("alt", document.title);
    img.setAttribute(
      "style",
      " width:inherit; height:inherit; border-radius: 50%;"
    );

    shadow.appendChild(wrapper);
    wrapper.appendChild(link);
    link.appendChild(img);
  }
}

window.customElements.define("img-avatar", Avatar);
