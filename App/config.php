<?php
/**
 * Silex Blog 
 * @author Marina Landisberg
 * Learning Silex and trying "case study for Shannon"
 * @copyright 2012
 */
define('ROOT',dirname(__DIR__));
require_once ROOT.'/vendor/braintree-php-2.14.0/lib/Braintree.php';
$loader = require_once ROOT.'/vendor/autoload.php';

require_once ROOT.'/App/private/braintree.php';
ini_set( "memory_limit","192M");

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use Symfony\Component\HttpKernel\HttpKernelInterface;
use Silex\Provider\DoctrineServiceProvider;
use Symfony\Component\HttpFoundation\Session\Storage\Handler\PdoSessionHandler;
use Symfony\Component\HttpFoundation\Session\Storage\NativeSessionStorage;
use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\Security\Core\Encoder\MessageDigestPasswordEncoder;
use Symfony\Component\Form\FormError;

$app = new Silex\Application();
$app['debug'] = true;
$app['autoloader'] = $app->share(function()use($loader){return $loader;});
$app['autoloader']->add("App",ROOT);

if (!function_exists('intl_get_error_code')) {
  require_once ROOT.'/vendor/symfony/locale/Symfony/Component/Locale/Resources/stubs/functions.php';

  $app['autoloader']->add('', ROOT.'/vendor/symfony/locale/Symfony/Component/Locale/Resources/stubs');
}
# twig
$app->register(new Silex\Provider\TwigServiceProvider(), array(
  "twig.path" => ROOT . "/App/views",
  "twig.form.templates"=>array('form_div_layout.html.twig',"form_div_layout.twig"),
  'twig.options' => array('cache' => ROOT.'/cache', 'strict_variables' => false)
  )
);

$app['pdo.dsn'] = 'mysql:dbname=casestudy';
$app['pdo.user'] = 'shannon';
$app['pdo.password'] = 'k68aC7kXc5QsbRF';

$app['session.db_options'] = array(
    'db_table'      => 'sh_sessions',
    'db_id_col'     => 'sid',
    'db_data_col'   => 'data',
    'db_time_col'   => 'timestamp',
);

$app->register(new Silex\Provider\DoctrineServiceProvider(), array(
    'db.options' => array(
        'driver' => 'pdo_mysql',
        'dbhost' => 'localhost',
        'dbname' => 'casestudy',
        'user' => 'shannon',
        'password' => 'k68aC7kXc5QsbRF',
    ),
));

$app['pdo'] = $app->share(function () use ($app) {
    return new PDO(
        $app['pdo.dsn'],
        $app['pdo.user'],
        $app['pdo.password']
    );
});
# session
$app->register(new Silex\Provider\SessionServiceProvider());

$app['session.storage.handler'] = $app->share(function () use ($app) {
    return new PdoSessionHandler(
        $app['db']->getWrappedConnection() /* $app['pdo'] */,
        $app['session.db_options']
    );
});
# url generator
$app->register(new Silex\Provider\UrlGeneratorServiceProvider());
# trans
$app->register(new Silex\Provider\TranslationServiceProvider(), array("locale_fallback" => "en"));
# validation
$app->register(new Silex\Provider\ValidatorServiceProvider());
# form
$app->register(new Silex\Provider\FormServiceProvider());
# security
$app->register(new Silex\Provider\SecurityServiceProvider(), array(
  'security.firewalls' => array(
      'member' => array(
          'pattern' => '^/',
          "anonymous" => array(),
          'form' => array(
            'login_path' => '/login', 
            'failure_path' => '/login', 
            'username_parameter' => 'login[username]',
            'password_parameter' => 'login[password]',
            "csrf_parameter" => "login[_token]",
            'check_path' => 'login_check'
          ),
          'logout' => array(
            'logout_path' => "/logout",
            "target" => '/',
            "invalidate_session" => true,
          ),
          'users' => function($app) {
            return $app['user_manager'];
          }
      )
  ),
  'security.access_rules' => array(
    array('^/members', 'ROLE_MEMBER'),
    array('^/store/checkout', 'ROLE_MEMBER','https'),
    array('^/admin','ROLE_ADMIN'),
  ),
  'security.role_hierarchy'=> array(
    'ROLE_ADMIN' => array('ROLE_MEMBER')
  ),
));
$app['security.encoder.digest'] = $app->share(function ($app) {
    // use the sha1 algorithm
    // don't base64 encode the password
    // use only 1 iteration
    return new MessageDigestPasswordEncoder('sha1', false, 1);
});
$app->register(new Silex\Provider\MonologServiceProvider(), array(
  'monolog.logfile' => ROOT.'/log/development.log',
));

# user manager
$app['user_manager'] = $app->share(
  function($app) {
    return new \App\Model\Manager\UserManager($app['db']);
  }
);
$app['payment_methods'] = $app->share(
  function($app) {
    return array('paypal'=>'Paypal', 'braintree'=>'Credit Card');
  }
);
$app['shipping_methods'] = $app->share(
  function($app) {
    return array('usps'=>'USPS', 'ems'=>'EMS', 'dhl'=>'Global Priority Mail by DHL');
  }
);
$app['cart.widget'] = $app->protect(function() use ($app) {
  $smallcart = $app['session']->get('cart');
  $smallqty = 0;
  $output = '';
  if (!empty($smallcart) && is_array($smallcart)) {
    $smallqty = array_sum($smallcart);
  }
  if ($smallqty > 0) {
    $output .= '<div id="cart-indicator"><a href="/store/cart"><img src="/images/shopping_cart.png"></a> <span>'.$smallqty.' item';
    $output .= ($smallqty > 1 ? 's' : '').'</span></div>';
  }
  return $output;
});
$app['random.code'] = $app->protect(function($length) {
    $string = "";
    for($i=0; $i < $length; $i++){
        $x = mt_rand(0, 2);
        switch($x){
            case 0: $string.= chr(mt_rand(97,122));break;
            case 1: $string.= chr(mt_rand(65,90));break;
            case 2: $string.= chr(mt_rand(48,57));break;
        }
    }
    return $string; 
});
$app['cart.contents'] = $app->protect(function() use ($app) {
  $s_cart = $app['session']->get('cart');
  $s_total = 0;
  $s_contents = array();
  $sql = "select id, sku, price, name from sh_products where id = ?";
  # $sth = $app['pdo']->prepare($sql); 
  foreach($s_cart as $pid => $q) {
    if ($q > 0) {
      # $sth->execute(array($pid));
      # $product = $sth->fetch(PDO::FETCH_ASSOC); 
      $product = $app['db']->fetchAssoc($sql, array((int) $pid));
      $s_total += $q * $product['price'];
      $s_contents[$pid] = array_merge(array('quantity'=>$q), $product); 
    }
  }
  //echo "Called protected closure\n";
  return array($s_contents, $s_total);
});
$app['controllers']->before(function()  use ($app) {
  $cart_widget = $app['cart.widget'];
  $app['cart_widget'] = $cart_widget();
  $file = __DIR__ . '/../vendor/symfony/src/Symfony/Bundle/FrameworkBundle/Resources/translations/validators.fr.xlf' ;

       $app['translator']->addLoader('xlf', new Symfony\Component\Translation\Loader\XliffFileLoader()) ;
       $app['translator']->addResource('xlf', $file, 'fr', 'validators') ;
});
$app->get('/admin', function () use ($app) {
  $pageTitle = 'Testing authentication for access to Admin area'; 
  return $app["twig"]->render("layout.twig",array('title'=>$pageTitle));
});
$app->get('/login', function(Request $request) use ($app) {
      $pageTitle = 'Login';
      $loginForm = $app['form.factory']->create(new \App\Form\Login());
      $form_error = $app['security.last_error']($request);
      $app['monolog']->addInfo($form_error);
      if ($form_error != null):
        // $loginForm->addError(new FormError($form_error));
        $app['session']->setFlash("error", "Wrong credentials");
      endif;
      $last_username = $app['session']->get('_security.last_username');
      return $app['twig']->render('login.twig', array('title'=>$pageTitle,'loginForm' => $loginForm->createView(), "form_error" => $form_error, 'last_username' => $last_username));
})->bind('login');
$app->match('/signup', function(Request $request) use ($app) {
      $pageTitle = 'Register';
      $registerForm = $app['form.factory']->create(new \App\Form\Register($app['db']));
      
      if('POST' === $app['request']->getMethod()) {
        $registerForm->bindRequest($app['request']) ;

        if($registerForm->isValid()) {
          $data = $registerForm->getData();
          $app['monolog']->addInfo(print_r($data, true));
          $app['monolog']->addInfo(print_r($data->toArray(), true));

          $userManager = $app['user_manager'];
          //email must be unique
          if ($userManager->emailExists($data['email']) == true){
            $registrationForm->addError(new FormError('email already exists'));
          }
          $random =  $app['random.code']; 
          $data->memberid = $random(20);

          $encoder = $app['security.encoder_factory']->getEncoder($data);
          $encodedPassword = $encoder->encodePassword($data->pwd, $data->getSalt());
          $data->pwd = $encodedPassword;

          $userManager->registerUser($data);
          //later here I will implements sending an email with SwiftMailer
          $app['session']->setFlash('notice', 'Your account was successfully created, please login');
          return $app->redirect($app['url_generator']->generate('members.index'));
        }
      }
      return $app['twig']->render('register.twig', array(
        'title'=>$pageTitle,
        'registerForm' => $registerForm->createView() 
        )
      );
})->bind('signup');
$app->get('/hello/{name}', function ($name) use ($app) {
  $pageTitle = 'Hello '.$app->escape($name); 
  //return 'Hello '.$app->escape($name);
  return $app["twig"]->render("layout.twig",array('title'=>$pageTitle));
});
$app->get('/', function () use ($app) {
    $pageTitle = 'Case Study for Shannon';
    $cart_widget = $app['cart.widget'];
    return $app["twig"]->render("layout.twig",array('title'=>$pageTitle));
})->bind('home');
$app->get('/info', function () use ($app) {
    return phpinfo();
});
$app->get('/members', function () use ($app) {
    $pageTitle = 'Members List';
    $sql = "select * from sh_accounts;";
    # $sth = $app['pdo']->prepare($sql);
    # $sth->execute();
    # $members = $sth->fetchAll(PDO::FETCH_ASSOC);
    # $sth->closeCursor();
    $members = $app['db']->fetchAll($sql);
    return $app["twig"]->render("members.twig", array('title'=>$pageTitle,"members" => $members));
})->bind('members.index');
$app->get('/members/{campus}/{memberid}', function ($memberid) use ($app) {
  $pageTitle = 'Member Profile';
  $userManager = $app['user_manager'];
  $member = $userManager->getByMemberId($memberid);
  return $app["twig"]->render("members/profile.twig", array('title'=>$pageTitle,"member" => $member));
});
$app->get('/blog', function () use ($app) {
    $pageTitle = 'Blog';
    $sql = "SELECT * FROM sh_blogposts";
    $posts = $app['db']->fetchAll($sql);
    return $app["twig"]->render("blog/index.twig", array('title'=>$pageTitle,"posts" => $posts));
})->bind('blog.index');
$app->get('/store', function () use ($app) {
    $pageTitle = 'Online Store';
    $sql = "SELECT id, sku, name, price, description from sh_products";
    /*
    $sth = $app['pdo']->prepare($sql);
    $sth->execute();
    $products = $sth->fetchAll(PDO::FETCH_ASSOC);
    $sth->closeCursor();
     */
    $products = $app['db']->fetchAll($sql);
    return $app["twig"]->render("store/index.twig", array('title'=>$pageTitle,"products" => $products));
})->bind('store.index');
$app->match('/store/cart', function (Request $request) use ($app) {
    $command = $request->get('command');
    if (empty($command)) {
      $command = 'show';
    }
    $product_id = (int)$request->get('pid');
    $quantity = (int)$request->get('quantity');

    // TODO: Check if product is available and iventory_amount is sufficient  
    $cart = $app['session']->get('cart');
    if (empty($cart)) {
      $cart = array();
    }
    switch($command) {
    case 'add':
      $found = false;
      foreach( $cart as $pid => $q) {
        if ($pid == $product_id) {
          $found = true;
          $cart[$pid] += $quantity;
        }
      }
      if (!$found) {    
        $cart[$product_id] = $quantity;
      }
      break;
    case 'delete':  
      unset($cart[$product_id]);
      break;
    case 'clear':
      $cart = array();
      break;
    case 'update':
      $qty = (array) $request->get('qty');
      foreach($qty as $pid => $q) {
        if ($q > 0) {
          $cart[$pid] = $q;
        } else {
          unset($cart[$pid]);
        }
      }
      break;  
    case 'show':
      break;
    }  
    $app['session']->set('cart', $cart);
    $app['cart_widget'] = $app['cart.widget']();

    $func_cart_contents = $app['cart.contents'];
    list($cart_contents, $cart_total) = $func_cart_contents();

    $pageTitle = 'Your Shopping Cart';
    return $app["twig"]->render("store/cart.twig", 
      array('title'=>$pageTitle,"cart_contents" => $cart_contents,'cart_total'=>$cart_total));
});
$app->match('/store/checkout', function (Request $request) use ($app) {
    $step = (int)$request->get('step');
    $errorMessage = '&nbsp;';
    $vars = array(); 
    if ($step == 1) {
      $template = 'store/checkout/addresses.twig';
      $vars['title'] = 'Checkout - Step 1 of 3';
      $order = $app['session']->get('order');
      if (empty($order)) {
        $order = new App\Model\Entity\Order(array("payment_method" => 'braintree'));
      }
      $checkoutForm = $app['form.factory']->create(new \App\Form\CheckoutForm($app['payment_methods']), $order);
      $vars['checkoutForm'] = $checkoutForm->createView();

      if('POST' === $app['request']->getMethod()) {
        $checkoutForm->bindRequest($app['request']) ;

        if($checkoutForm->isValid()) {
          $data = $checkoutForm->getData();
          $app['monolog']->addInfo(print_r($data, true));
          $app['session']->set('order', $data);
          return $app->redirect("/store/checkout?step=2");
        }
      }
    } else if ($step == 2) {
      $template = 'store/checkout/confirmation.twig';
      $vars['title'] = 'Checkout - Step 2 of 3';
      
      $func_cart_contents = $app['cart.contents'];
      list($cart_contents, $cart_total) = $func_cart_contents();
      $vars['cart_contents'] = $cart_contents;
      $vars['cart_total'] = $cart_total; 
      $vars['order'] = $app['session']->get('order'); 
      $vars['payment_method'] = $app['payment_methods'][ $vars['order']['payment_method'] ];
    } else if ($step == 3) {
      // TODO: save order, take payment
      $token = $app['security']->getToken();
      if (null !== $token) {
          $user = $token->getUser();
      }
      $order = $app['session']->get('order');
      $order->account_id = $user->id;
      $app['monolog']->addInfo(print_r($order, true));

      $template = 'store/checkout/'.$order->payment_method.'_payment.twig';
      $app['monolog']->addInfo("template name: $template");
      $vars['title'] = 'Checkout - Step 3 of 3';
      /*
      $orderId     = saveOrder();
      $orderAmount = getOrderAmount($orderId);
      
      $_SESSION['orderId'] = $orderId;
      
      // our next action depends on the payment method
      // if the payment method is COD then show the 
      // success page but when paypal is selected
      // send the order details to paypal
      if ($_POST['hidPaymentMethod'] == 'cod') {
        header('Location: success.php');
        exit;
      } else {
        $includeFile = 'paypal/payment.php';	
      }
       */
    }
    return $app["twig"]->render($template, $vars);
})->bind('store.checkout');
?>
