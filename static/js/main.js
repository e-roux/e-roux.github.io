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

document.addEventListener("DOMContentLoaded", updateNavbar);
