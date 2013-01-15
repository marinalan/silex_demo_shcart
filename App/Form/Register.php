<?php
namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Doctrine\DBAL\Connection;

use Symfony\Component\Validator\Constraints as Assert;


class Register extends AbstractType{
  private $conn;

  public function __construct(Connection $conn)
  {
      $this->conn = $conn;
  }

	public function buildForm(FormBuilderInterface $builder, array $options){
    $builder->add('email',"email",array('constraints' => array(new Assert\NotNull(),new Assert\NotBlank(),new Assert\Email()), 
    'attr'=>array("placeholder"=>"email"), 'required' => true)); 
    // "constraints"=>array(new Assert\NotBlank(),new Assert\Email()),
    $builder->add('full_name',"text",array('label'=>'Full Name','required' => true,
                                           'constraints'=>array(new Assert\NotNull(),new Assert\NotBlank(),new Assert\MinLength(3)))); 
    // "constraints"=>array(new Assert\NotBlank(),new Assert\MinLength(3))
		$builder->add('pwd', 'repeated', array(
            'type'            => 'password',
            'invalid_message' => 'The password fields must match.',
            'options'         => array('required' => true),
            'first_options'   => array('label' => 'Password'),
            'second_options'  => array('label' => 'Repeat Password'),
            'required' => true
        ));

    $sql = "select code, name from sh_campuses";
    $campuses = $this->conn->fetchAll($sql);
    $choices = array();
    foreach($campuses as $campus){
      $choices[$campus['code']] = $campus['name'];
    }
    $builder->add('campus', 'choice', array('choices' => $choices, 'required' => true));
    $builder->add('phone',"text",array('label'=>'Telephone')); 
    $builder->add('street',"text",array('label'=>'Address Line 1')); 
    $builder->add('city',"text",array('label'=>'City / Town')); 
    $builder->add('zip',"text",array('label'=>'Zip / Postal Code')); 
    $builder->add('province_state',"text",array('label'=>'Province / State')); 
    $builder->add('country',"country",array('label'=>'Country','preferred_choices' => array('CA','US'))); 
		$builder->add("agreement",'checkbox',array('label'=>"Agree to Terms?"));
	}

  public function setDefaultOptions(OptionsResolverInterface $resolver)
  {
      $resolver->setDefaults(array(
        'data_class' => 'App\Model\Entity\User',
      ));
  }

	public function getName(){
		return "register";
	}

}
