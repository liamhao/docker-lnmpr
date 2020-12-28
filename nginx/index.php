<?php

echo "<h1>{$_SERVER['SERVER_ADDR']}</h1>";

// echo json_encode(getallheaders());

var_dump($_SERVER["REQUEST_URI"]);

// $ch = curl_init('order.service.consul/index.html');
// curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

// echo '========';
// var_dump(curl_exec($ch));
// echo '========';
// var_dump(curl_error($ch));
// echo '========';
// curl_close($ch);

if (isset($_GET['hsj'])) {
  echo "<h3>参数:</h3>";
  var_dump($_GET);
}