<?php
namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Doctrine\DBAL\Connection;

use Symfony\Component\Validator\Constraints as Assert;

class CheckoutForm extends AbstractType{
  private $payment_methods;

  public function __construct($payment_methods)
  {
    $this->payment_methods = $payment_methods;
  }

  public function buildForm(FormBuilderInterface $builder, array $options){
    $builder->add('billing_fullname','text',array('required'=>true, 'label'=>'Full Name',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('billing_street','text',array('required'=>true, 'label'=>'Street Address',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('billing_city','text',array('required'=>true, 'label'=>'City',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('billing_zip','text',array('required'=>true, 'label'=>'Postal / Zip Code',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('billing_province_state','text',array('label'=>'Province / State',
      )); 
    $builder->add('billing_country','country',array('required'=>true, 'label'=>'Country',
      'preferred_choices' => array('CA','US'))); 
    $builder->add('billing_phone','text',array('required'=>true, 'label'=>'Phone',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 


    $builder->add('shipping_fullname','text',array('required'=>true, 'label'=>'Full Name',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('shipping_street','text',array('required'=>true, 'label'=>'Street Address',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('shipping_city','text',array('required'=>true, 'label'=>'City',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('shipping_zip','text',array('required'=>true, 'label'=>'Postal / Zip Code',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 
    $builder->add('shipping_province_state','text',array('label'=>'Province / State',
      )); 
    $builder->add('shipping_country','country',array('required'=>true, 'label'=>'Country',
      'preferred_choices' => array('CA','US'))); 
    $builder->add('shipping_phone','text',array('required'=>true, 'label'=>'Phone',
      'constraints' => array(new Assert\NotNull(),new Assert\NotBlank()))); 

    $builder->add('payment_method','choice',array('label'=>'Payment Method',
      'expanded'=>true,'multiple'=>false,'choices'=>$this->payment_methods,
      'required'=>true));
  }

  public function setDefaultOptions(OptionsResolverInterface $resolver)
  {
      $resolver->setDefaults(array(
        'data_class' => 'App\Model\Entity\Order',
      ));
  }

  public function getName(){
      return "checkout1";
  }
}
?>
