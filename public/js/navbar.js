const openMenu = document.querySelector('#show-menu')
const hideMenu = document.querySelector('#hide-menu')
const sideMenu = document.querySelector('#nav-menu')
const container = document.querySelector('.container')
const navText = document.querySelector(".nav-text")
const subMenu = document.querySelector(".sub-menu")

function openNav() {
    sideMenu.classList.add('active');
    container.classList.add('overlay')
}
function closeNav() {
    sideMenu.classList.remove('active')
    container.classList.remove('overlay')
}
function toggle(item1) {
    var element = document.getElementById(item1);
    element.classList.toggle("open-list");
}
$(document).click(function (e) {
    if (!openMenu.contains(e.target) && !sideMenu.contains(e.target)) {
        closeNav()
    }

});