// window.addEventListener("load", () => {
//   const themeButtons = document.querySelectorAll(
//     "button[data-theme-select]"
//   );
//   themeButtons.forEach((element) => {
//     element.addEventListener("click", (event) => {
//       changeTheme(element.dataset.themeSelect);
//     });
//   });
// });

window.queryFile = (url) => {
  fetch(url).then(response => {
    return response.json()
  }).then(json =>{
    console.log(json)
  })
}
