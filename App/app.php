<?php
require_once __DIR__.'/../vendor/braintree-php-2.14.0/lib/Braintree.php';
require_once __DIR__.'/../vendor/autoload.php';

Braintree_Configuration::environment('sandbox');
Braintree_Configuration::merchantId('4y8p2399gf68zhgj');
Braintree_Configuration::publicKey('nnpzs7p3krt2rq39');
Braintree_Configuration::privateKey('766bf7b405fbd7956b76bd2df0f41668');

ini_set( "memory_limit","192M");
?>
