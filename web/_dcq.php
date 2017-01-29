<?php

// datacollector script

// SQL schema: TODO
// example usage: curl -H "X-Auth-Token: ..." -d '{"category": "temp", "name": "zem", "value": "22.124"}' http://server.local/_dcq.php

//---------------------------------------------------

$db_host='';
$db_database='';
$db_username='';
$db_password='';

//casova zona
date_default_timezone_set('Europe/Prague');

//pripojeni k DB
$scon = mysql_connect($db_host, $db_username, $db_password);
if (!$scon){
die ("Chyba pripojeni k DB."); //.mysql_error());
}
$db_select = mysql_select_db($db_database, $scon);

mysql_query("SET CHARACTER SET utf8", $scon);
mysql_query("SET NAMES utf8", $scon);

//----------------------------------------------------

function sec($text) {
  return mysql_real_escape_string(htmlspecialchars(trim($text)));
}

function is_valid_auth($token) {
  //$r = mysql_query("SELECT * FROM agents WHERE token = $token LIMIT 1;");
  //return mysql_fetch_assoc($r);
  return (sec($token) == "...")
}

function save_sample($d) {
    $ip = sec($_SERVER['REMOTE_ADDR']);
    mysql_query("INSERT INTO samples (category, name, value, created_at, detail) VALUES ('".sec($d->category)."', '".sec($d->name)."', '".sec($d->value)."', now(), 'remote:$ip');");
}

//----------------------------------------------------

if (is_valid_auth($_SERVER['HTTP_X_AUTH_TOKEN'])) {
  $data = json_decode(file_get_contents("php://input"));
  save_sample($data);
  header("HTTP/1.1 202 Accepted");
  echo "ok";
  exit;
} else {
  header("HTTP/1.1 401 Unauthorized");
  echo "err";
  exit;
}

?>
