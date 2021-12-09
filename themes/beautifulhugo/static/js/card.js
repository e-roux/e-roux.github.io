export { groupCard };

function groupCard() {
  const cards = document.getElementsByClassName("card");

  let group = [];
  for (let card of Array.from(cards)) {
    let isPreviousElementACard =
      card.previousElementSibling.getAttribute("class") === "card";
    if (group.length == 0 && !isPreviousElementACard) {
      group.push(card);
      // console.log(card, card.parentNode);
    } else if (isPreviousElementACard) {
      group.push(card);
    } else {
      console.log("cards.js: no action");
    }
    // const newItem = document.createElement("li");
    // newItem.innerHTML = '<a href="/products">Products</a>';
    // console.log(isPreviousElementACard, group);
  }
  group[0].parentNode.replaceChild(group[1], group[0]);
  group = [];
  // console.log(cards);
}
