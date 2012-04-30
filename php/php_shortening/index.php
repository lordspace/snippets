<?php

require_once(dirname(__FILE__) . '/zzz_lib.php');

$shorty = new App_Shorty();


$id = 10;

echo 'ID: ' . $id;
echo '<br/> Short link: ' . $shorty->encode($id);
echo '<br/> Decoded Short Link: ' . $shorty->decode($shorty->encode($id));

