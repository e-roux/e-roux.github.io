// Dean Attali / Beautiful Jekyll 2016

var main = {
  bigImgEl: null,
  numImgs: null,

  init: function () {
    // Shorten the navbar after scrolling a little bit down
    $(window).scroll(function () {
      if ($(".navbar").offset().top > 50) {
        $(".navbar").addClass("top-nav-short");
      } else {
        $(".navbar").removeClass("top-nav-short");
      }
    });

    // On mobile, hide the avatar when expanding the navbar menu
    $("#main-navbar").on("show.bs.collapse", function () {
      $(".navbar").addClass("top-nav-expanded");
    });
    $("#main-navbar").on("hidden.bs.collapse", function () {
      $(".navbar").removeClass("top-nav-expanded");
    });

    // On mobile, when clicking on a multi-level navbar menu, show the child links
    $("#main-navbar").on("click", ".navlinks-parent", function (e) {
      var target = e.target;
      $.each($(".navlinks-parent"), function (key, value) {
        if (value == target) {
          $(value).parent().toggleClass("show-children");
        } else {
          $(value).parent().removeClass("show-children");
        }
      });
    });

    // Ensure nested navbar menus are not longer than the menu header
    var menus = $(".navlinks-container");
    if (menus.length > 0) {
      var navbar = $("#main-navbar").find("ul");
      var fakeMenuHtml =
        "<li class='fake-menu' style='display:none;'><a></a></li>";
      navbar.append(fakeMenuHtml);
      var fakeMenu = $(".fake-menu");

      $.each(menus, function (i) {
        var parent = $(menus[i]).find(".navlinks-parent");
        var children = $(menus[i]).find(".navlinks-children a");
        var words = [];
        $.each(children, function (idx, el) {
          words = words.concat($(el).text().trim().split(/\s+/));
        });
        var maxwidth = 0;
        $.each(words, function (id, word) {
          fakeMenu.html("<a>" + word + "</a>");
          var width = fakeMenu.width();
          if (width > maxwidth) {
            maxwidth = width;
          }
        });
        $(menus[i]).css("min-width", maxwidth + "px");
      });

      fakeMenu.remove();
    }

    // show the big header image
    main.initImgs();
  },

  initImgs: function () {
    // If the page was large images to randomly select from, choose an image
    if ($("#header-big-imgs").length > 0) {
      main.bigImgEl = $("#header-big-imgs");
      main.numImgs = main.bigImgEl.attr("data-num-img");

      // 2fc73a3a967e97599c9763d05e564189
      // set an initial image
      var imgInfo = main.getImgInfo();
      var src = imgInfo.src;
      var desc = imgInfo.desc;
      var position = imgInfo.position;
      main.setImg(src, desc, position);

      // For better UX, prefetch the next image so that it will already be loaded when we want to show it
      var getNextImg = function () {
        var imgInfo = main.getImgInfo();
        var src = imgInfo.src;
        var desc = imgInfo.desc;
        var position = imgInfo.position;

        var prefetchImg = new Image();
        prefetchImg.src = src;
        // if I want to do something once the image is ready: `prefetchImg.onload = function(){}`

        setTimeout(function () {
          var img = $("<div></div>")
            .addClass("big-img-transition")
            .css("background-image", "url(" + src + ")");
          if (position !== undefined) {
            img.css("background-position", position);
          }
          $(".intro-header.big-img").prepend(img);
          setTimeout(function () {
            img.css("opacity", "1");
          }, 50);

          // after the animation of fading in the new image is done, prefetch the next one
          //img.one("transitioned webkitTransitionEnd oTransitionEnd MSTransitionEnd", function(){
          setTimeout(function () {
            main.setImg(src, desc, position);
            img.remove();
            getNextImg();
          }, 1000);
          //});
        }, 6000);
      };

      // If there are multiple images, cycle through them
      if (main.numImgs > 1) {
        getNextImg();
      }
    }
  },

  getImgInfo: function () {
    var randNum = Math.floor(Math.random() * main.numImgs + 1);
    var src = main.bigImgEl.attr("data-img-src-" + randNum);
    var desc = main.bigImgEl.attr("data-img-desc-" + randNum);
    var position = main.bigImgEl.attr("data-img-position-" + randNum);

    return {
      src: src,
      desc: desc,
      position: position,
    };
  },

  setImg: function (src, desc, position) {
    $(".intro-header.big-img").css("background-image", "url(" + src + ")");
    if (position !== undefined) {
      $(".intro-header.big-img").css("background-position", position);
    } else {
      // Remove background-position if added to the prev image.
      $(".intro-header.big-img").css("background-position", "");
    }
    if (typeof desc !== typeof undefined && desc !== false) {
      // Check for Markdown link
      var mdLinkRe = /\[(.*?)\]\((.+?)\)/;
      if (desc.match(mdLinkRe)) {
        // Split desc into parts, extracting md links
        var splitDesc = desc.split(mdLinkRe);

        // Build new description
        var imageDesc = $(".img-desc");
        splitDesc.forEach(function (element, index) {
          // Check element type. If links every 2nd element is link text, and every 3rd link url
          if (index % 3 === 0) {
            // Regular text, just append it
            imageDesc.append(element);
          }
          if (index % 3 === 1) {
            // Link text - do nothing at the moment
          }
          if (index % 3 === 2) {
            // Link url - Create anchor tag with text
            var link = $("<a>", {
              href: element,
              target: "_blank",
              rel: "noopener noreferrer",
            }).text(splitDesc[index - 1]);
            imageDesc.append(link);
          }
        });
        imageDesc.show();
      } else {
        $(".img-desc").text(desc).show();
      }
    } else {
      $(".img-desc").hide();
    }
  },
};

// https://hacks.mozilla.org/2015/08/es6-in-depth-subclassing/
class Group extends Array {
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

function groupCard() {
  const cards = document.getElementsByClassName("card");

  let grp = new Group();
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

/* When the user scrolls down, hide the navbar. When the user scrolls up, show
 * the navbar */
function updateNavbar() {
  const navbar = document.getElementById("navbarCustom");
  let prevScrollpos = 0;
  const updatePosition = function () {
    const newScrollPos = window.scrollY;
    if (
      (newScrollPos > 50 && prevScrollpos <= 50) ||
      (newScrollPos <= 50 && prevScrollpos > 50)
    ) {
      navbar.classList.toggle("top-nav-short");
    }
    prevScrollpos = newScrollPos;
  };
  document.addEventListener("scroll", updatePosition);
}

function displayLinkHoverImg() {
  const imgs = document.getElementsByClassName("card-header");
  for (const elt of imgs) {
    elt.addEventListener("mouseenter", () => {
      elt.querySelector(".card-img-overlay").classList.toggle("d-none");
      elt.querySelector(".img-course").classList.toggle("opacity-25");
    });
    elt.addEventListener("mouseleave", () => {
      console.log(elt.classList);
      elt.querySelector(".card-img-overlay").classList.toggle("d-none");
      elt.querySelector(".img-course").classList.toggle("opacity-25");
    });
  }
  // const updatePosition = function () {
  //   const newScrollPos = window.scrollY;
  //   if (
  //     (newScrollPos > 50 && prevScrollpos <= 50) ||
  //     (newScrollPos <= 50 && prevScrollpos > 50)
  //   ) {
  //     navbar.classList.toggle("top-nav-short");
  //   }
  //   prevScrollpos = newScrollPos;
  // };
  // document.addEventListener("scroll", updatePosition);
}

document.addEventListener("DOMContentLoaded", updateNavbar);
document.addEventListener("DOMContentLoaded", displayLinkHoverImg);

document.addEventListener("DOMContentLoaded", groupCard);
