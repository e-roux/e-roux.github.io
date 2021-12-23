// "use strict";
// https://hacks.mozilla.org/2015/08/es6-in-depth-subclassing/
/** @class Group */
class CardGroup extends Array {
  constructor(...items) {
    super(...items);
  }

  asRow() {
    const container = document.createElement("div");
    container.classList.add("card-group");
    container.classList.add("row");
    container.classList.add("row-cols-1");
    container.classList.add("mb-5");
    container.classList.add("mt-2");
    container.classList.add("g-4");
    container.classList.add("row-cols-sm-2");
    container.classList.add("row-cols-md-3");
    container.classList.add("row-cols-lg-4");
    container.classList.add("row-cols-xxl-5");
    this[0].insertAdjacentElement("beforebegin", container);

    // Avoid this as DOM is manipulated multiple times
    // this.forEach((node) => { ... });

    const makeCardContainer = function (node) {
      const subcontainer = document.createElement("div");
      subcontainer.classList.add("col");
      subcontainer.appendChild(node);
      container.appendChild(subcontainer);
      return subcontainer;
    };

    let nodes = this.map((node) => makeCardContainer(node));
    container.prepend(...nodes);
  }
}

/** Group conithuous boostrap cards in a div */
export function groupCard() {
  const cards = document.getElementsByClassName("card");

  let grp = new CardGroup();
  for (let card of Array.from(cards)) {
    let isPreviousElementACard =
      card.previousElementSibling.getAttribute("class") === "card h-100";
    if (!isPreviousElementACard) {
      if (grp.length > 0) {
        grp.asRow();
      }
      grp.length = 0;
      grp.push(card);
      // console.log("first card", card, card.parentNode);
    } else if (isPreviousElementACard) {
      grp.push(card);
      // console.log("sibling card", card, card.parentNode);
    } else {
      grp.asRow();
      // console.log("else", grp, grp.length, card.parentNode);
    }
  }
  // console.log(grp);
  grp.asRow();
}

export function displayLinkHoverImg() {
  const imgs = document.getElementsByClassName("card-header");

  const toggleLink = (elt) => {
    elt.querySelector(".card-img-overlay").classList.toggle("d-none");
    elt.querySelector(".img-course").classList.toggle("opacity-25");
  };

  for (const elt of imgs) {
    elt.addEventListener("mouseenter", () => toggleLink(elt));
    elt.addEventListener("mouseleave", () => toggleLink(elt));
    if (elt.parentNode.querySelector(":hover") == elt) {
      toggleLink(elt);
    }
  }
}
