window.addEventListener("load", () => {
  const themeButtons = document.querySelectorAll(
    "button[data-theme-select]"
  );
  themeButtons.forEach((element) => {
    element.addEventListener("click", (event) => {
      changeTheme(element.dataset.themeSelect);
    });
  });
});

window.changeTheme = (theme) =>{
  let themeController = document.querySelector("#theme-controller")
  themeController.removeAttribute("class")
  themeController.classList.add(theme)
}