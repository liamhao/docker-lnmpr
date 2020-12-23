<?php

echo "<h1>{$_SERVER['SERVER_ADDR']}</h1>";

echo json_encode(getallheaders());

if (isset($_GET['hsj'])) {
  echo "<h3>参数:</h3>";
  var_dump($_GET);
}