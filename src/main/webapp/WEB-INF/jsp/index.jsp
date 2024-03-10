<%@ page contentType="text/html;charset=utf-8" %>
<%@ page isELIgnored="true"%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Сайт для определения попадания точки в область</title>
    <!-- Подключаем bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <style>
        <%@include file="../../resources/css/styles.css"%>
    </style>
    <!-- Подключаем bootstrap 5 js -->
</head>
<body>
<div class="container-fluid">
    <!-- Шапка сайта с фамилией и группой студента -->
    <div class="row">
        <div class="col-12 bg-light">
            <div class="header">
                <h3 class="text-center">Студент: Васькин Вячеслав Денисович</h3>
                <h3 class="text-center">Группа: P3211 | ИСУ: 33231 | <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                    Задание
                </button></h3>
            </div>
        </div>
    </div>
    <div class="row justify-content-center main">
        <!-- Картинка с графиком -->
        <div class="col-3 graph">
            <svg width="260" height="260" viewBox="0 0 260 260" xmlns="http://www.w3.org/2000/svg" id="graph">


                <!-- 4 четверть -->
                <circle r="100" cx="130" cy="130" fill="#add8e6"/>
                <rect x="0" y="0" width="260" height="130" fill="white" />
                <rect x="0" y="0" width="130" height="260" fill="white" />

                <!-- 2 четверть -->
                <polygon points="30, 130 130,130 130,180" fill="#add8e6"/>

                <!-- 3 четверть -->
                <rect x=30 y=80 width=100 height=50 fill="#add8e6"/>


                <!-- Ось X -->
                <line x1="0" y1="130" x2="350" y2="130" stroke="black"/>
                <!-- Ось Y -->
                <line x1="130" y1="0" x2="130" y2="260" stroke="black"/>
                <!-- R на оси X -->
                <text x="230" y="127" font-size="12" font-family="Arial">R</text>
                <text x="180" y="127" font-size="12" font-family="Arial">R/2</text>
                <text x="80" y="127" font-size="12" font-family="Arial">-R/2</text>
                <text x="30" y="127" font-size="12" font-family="Arial">-R</text>
                <!-- R на оси Y -->
                <text x="133" y="230" font-size="12" font-family="Arial">-R</text>
                <text x="133" y="180" font-size="12" font-family="Arial">-R/2</text>
                <text x="133" y="80" font-size="12" font-family="Arial">R/2</text>
                <text x="133" y="30" font-size="12" font-family="Arial">R</text>
            </svg>
        </div>
        <!-- Форма для ввода X, Y и R -->
        <div class="col-4">
            <form method="POST" id="form" onsubmit="event.preventDefault(); sendForm(document.getElementById('x-input').value, document.getElementById('y-input').value, document.getElementById('r-input').value);">
                <div class="form-group">
                    <div class="row">
                        <label for="x-input">Введите X (-3 ... 3)</label>
                        <input type="number" id="x-input" step="0.0001" name="x" min="-3" max="3" class="form-control" required>
                    </div>
                    <div class="row">
                        <label for="y-input">Выберите Y (-3 ... 5)</label>
                        <select id="y-input" name="y" class="form-control" required>
                            <option value="-3">-3</option>
                            <option value="-2">-2</option>
                            <option value="-1">-1</option>
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                    <div class="row">
                        <label for="r-input">Выберите R (1 ... 5)</label>
                        <select id="r-input" name="r" class="form-control" required>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col gy-3" style="padding-left: 0">
                            <button type="submit" class="btn btn-primary gy-3 form-control" id="submit-button">Проверить</button>
                        </div>
                        <div class="col gy-3" style="padding-right: 0">
                            <button type="button" class="btn btn-warning gy-3 form-control" id="clear-button" onclick="clearTable()">Очистка</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>


    <!-- Таблица с результатами -->
    <div id="table-container" style="padding-top: 40px">
        <table class="table gy-5 table-light table-striped">
            <thead>
            <tr>
                <th scope="col">Время</th>
                <th scope="col">Координаты</th>
                <th scope="col">Попадание</th>
                <th scope="col">Время выполнения скрипта</th>
            </tr>
            </thead>
            <tbody id="results-table">
            </tbody>
        </table>
    </div>

</div>
<script>
    function createCircle(x, y) {
        var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        // Устанавливаем атрибуты для круга (цвет, радиус, координаты)
        circle.setAttribute("cx", x);
        circle.setAttribute("cy", y);
        circle.setAttribute("r", 5); // Радиус круга (можно установить другое значение)
        circle.setAttribute("class", "graph_circle")
        // Добавляем круг внутрь SVG элемента
        return circle;
    }
    function setCircleFill(circle, fill) {
        circle.setAttribute("fill", fill)
    }
    function addRow(rowData) {
        if (rowData.x == null) rowData.x = "Некорректный X"
        if (rowData.y == null) rowData.y = "Некорректный Y"
        if (rowData.r == null) rowData.r = "Некорректный R"
        let tableRef = document.getElementById('results-table');
        tableRef.innerHTML =
            `<tr>
                    <th>${rowData.timestamp}</th>
                    <td>${rowData.x}, ${rowData.y}, ${rowData.r}</td>
                    <td>${rowData.hitMessage}</td>
                    <td>${rowData.executionTime}</td>
                </tr>`
            + tableRef.innerHTML;

        if (rowData.isValid === true) {
            let svg = document.getElementById('graph');
            var svgRect = svg.getBoundingClientRect();

            let x = (rowData.x * 100) + svgRect.width / 2;
            let y = -(rowData.y * 100) + svgRect.height / 2;

            let circle = createCircle(x, y);
            svg.appendChild(circle);

            if (rowData.isHit === true) setCircleFill(circle, "green")
            else setCircleFill(circle, "red");
        }

    }
</script>
<script>
    document.getElementById('graph').addEventListener('click', function(event) {
        var svg = document.getElementById('graph');
        var svgRect = svg.getBoundingClientRect();
        var svgX = svgRect.x + svgRect.width / 2; // центр квадрата
        var svgY = svgRect.y + svgRect.height / 2; // центр квадрата

        var mouseX = event.clientX;
        var mouseY = event.clientY;

        var offsetX = (mouseX - svgX) / 100;
        var offsetY = (svgY - mouseY) / 100;

        sendForm(offsetX, offsetY, 1, false);
    });

</script>
<script>
    function sendForm(x, y, r, showTable=false) {
        // Параметры запроса
        const params = new URLSearchParams();
        params.append('x', x);
        params.append('y', y);
        params.append('r', r);
        params.append('showTable', showTable.toString());

        // Опции запроса
        const requestOptions = {
            method: 'POST',
            body: params
        };

        // Выполнение POST запроса
        var baseUrl = window.location.protocol + "//" + window.location.host;
        return fetch(baseUrl + '/JakartaLabs-2/2', requestOptions)
            .then(response => response.json())
            .then(data => {
                data.forEach(tableRow => {
                    addRow(tableRow);
                })
            })
            .catch(error => console.error('Ошибка при выполнении запроса:', error));
    }
    window.onload = () => sendForm(document.getElementById('x-input').value, document.getElementById('y-input').value, document.getElementById('r-input').value, true);
</script>
<script>
    function clearTable() {
        // Параметры запроса
        const params = new URLSearchParams();
        params.append('clearTable', 'true');

        // Опции запроса
        const requestOptions = {
            method: 'POST',
            body: params
        };
        // Выполнение POST запроса
        var baseUrl = window.location.protocol + "//" + window.location.host;
        fetch(baseUrl + '/JakartaLabs-2/2', requestOptions)
            .then(response => response.text())
            .then(() => {
                document.getElementById('results-table').innerHTML = '';
                document.querySelectorAll('.graph_circle').forEach(circle => circle.remove());
            })
            .catch(error => console.error('Ошибка при выполнении запроса:', error));
    }
</script>
</body>
</html>