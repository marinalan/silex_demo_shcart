<?php
namespace App\Model\Entity;

class Order extends Base
{
   protected $id=null;
   protected $account_id=null;
   protected $status=null;
   protected $billing_fullname=null;
   protected $billing_street=null;
   protected $billing_city=null;
   protected $billing_zip=null;
   protected $billing_province_state=null;
   protected $billing_country=null;
   protected $billing_phone=null;
   protected $shipping_different=null;
   protected $shipping_fullname=null;
   protected $shipping_street=null;
   protected $shipping_city=null;
   protected $shipping_zip=null;
   protected $shipping_province_state=null;
   protected $shipping_country=null;
   protected $shipping_phone=null;
   protected $paid_at=null;
   protected $shipped_at=null;
   protected $shipping_method=null;
   protected $shipping_price=null;
   protected $tracking_number=null;
   protected $payment_method=null;
   protected $total=null;
   protected $created_at=null;
   protected $updated_at=null;
}
