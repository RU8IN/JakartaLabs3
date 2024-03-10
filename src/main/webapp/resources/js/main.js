function createCircle(x, y, r, isHit) {
    let circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    let svg = document.getElementById('graph');
    let svgRect = document.getElementById('graph').getBoundingClientRect();
    // Устанавливаем атрибуты для круга (цвет, радиус, координаты)


    circle.setAttribute("cx", (x * 100 / r)  + svgRect.width / 2);
    circle.setAttribute("cy", -(y * 100 / r) + svgRect.height / 2);
    circle.setAttribute("r", 5); // Радиус круга (можно установить другое значение)
    circle.setAttribute("class", "graph_circle")
    setCircleFill(circle, isHit);
    // console.log(x, y, r, isHit, -(y * 100 / r) + svgRect.height / 2);

    svg.appendChild(circle);
    return circle;
}
function setCircleFill(circle, isHit) {
    if (isHit === "true") circle.setAttribute("fill", "green")
    else circle.setAttribute("fill", "red")
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}


function setR(number, link) {
    clearCircles();
    let inputHidden = document.getElementById("input-form:r-text");
    inputHidden.value = number;
    highlightSelectedRButton(link);
}

function highlightSelectedRButton(link) {
    let links = document.querySelectorAll('.setRButton');
    links.forEach(function(item) {
        if (item === link) {
            item.classList.add('active'); // Выделяем нажатый тег
        } else {
            item.classList.remove('active'); // Убираем выделение с остальных тегов
        }
    });
}

function clearCircles() {
    let svg = document.getElementById('graph');
    let circles = svg.querySelectorAll(".graph_circle");
    circles.forEach((circle) => {circle.remove()})
}

