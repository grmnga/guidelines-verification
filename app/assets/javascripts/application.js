function ShowMessage() {
    button = document.getElementById('message');
    button.innerText = 'Проверка началась. Это займет некоторое время...';
}

function disableButton() {
    this.style = "background: #AAAAAA; cursor: default; pointer-events: none;";
}

function toggle(el) {
    el.style.display = (el.style.display == 'block') ? '' : 'block'
}

window.onload = function() {
    document.getElementById('start_full_checking').addEventListener('click', ShowMessage);
    document.getElementById('start_subsection_checking').addEventListener('click', ShowMessage);
    document.getElementById('show_select_subsection_button').addEventListener('click', function () {
        toggle(document.getElementById('select_subsection_block'));
       // document.getElementById('select_subsection_block').style = 'display: block';
    });
    document.getElementById('start_subsection_checking_2020').addEventListener('click', ShowMessage);
    document.getElementById('show_select_subsection_button_2020').addEventListener('click', function () {
        toggle(document.getElementById('select_subsection_block_2020'));
       // document.getElementById('select_subsection_block_2020').style = 'display: block';
    });

    document.getElementById("start_full_checking").addEventListener("click", disableButton);
    document.getElementById("start_subsection_checking").addEventListener("click", disableButton);
    document.getElementById("start_subsection_checking_2020").addEventListener("click", disableButton);
}