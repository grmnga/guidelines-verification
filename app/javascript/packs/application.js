// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


function ShowMessage() {
    button = document.getElementById('message');
    button.innerText = 'Проверка началась. Это займет некоторое время...';
}

function disableButton() {
    this.style = "background: #AAAAAA; cursor: default; pointer-events: none;";
}

window.onload = function() {
    document.getElementById('start_full_checking').addEventListener('click', ShowMessage);
    document.getElementById('start_subsection_checking').addEventListener('click', ShowMessage);
    document.getElementById('show_select_subsection_button').addEventListener('click', function () {
       document.getElementById('select_subsection_block').style = 'display: block';
    });
    document.getElementById('start_subsection_checking_2020').addEventListener('click', ShowMessage);
    document.getElementById('show_select_subsection_button_2020').addEventListener('click', function () {
       document.getElementById('select_subsection_block_2020').style = 'display: block';
    });

    document.getElementById("start_full_checking").addEventListener("click", disableButton);
    document.getElementById("start_subsection_checking").addEventListener("click", disableButton);
    document.getElementById("start_subsection_checking_2020").addEventListener("click", disableButton);
}