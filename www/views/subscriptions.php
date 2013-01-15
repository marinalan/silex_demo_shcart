<?php
global $app;
$customerId = $app["request"]->get("id");
$customer = Braintree_Customer::find($customerId);
$paymentMethodToken = $customer->creditCards[0]->token;
$result = Braintree_Subscription::create(array(
  'paymentMethodToken' => $paymentMethodToken,
  'planId' => 'test_plan_1'
));

if ($result->success) {
 $message = "Subscription status ".$result->subscription->status;
}
else {
 $message = print_r($result->errors->deepAll(), True);
}

?>
<html>
 <body>
   <h1>Subscription Status</h1>
   <ul>
     <li><?php echo $message ?></li>
   </ul>
 </body>
</html>
