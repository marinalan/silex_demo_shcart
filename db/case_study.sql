CREATE DATABASE IF NOT EXISTS casestudy CHARACTER SET utf8;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER on casestudy.* to 'shannon'@'localhost' IDENTIFIED by  'k68aC7kXc5QsbRF';

use casestudy;
create table sh_accounts (
  id              bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  memberid        char(20) not null  UNIQUE KEY,
  email           varchar(128) not null  UNIQUE KEY,
  pwd             varchar(128) not null,
  full_name       varchar(255) not null,
  street          varchar(255),
  city            varchar(128),
  zip             varchar(20),
  province_state  varchar(255),
  country         varchar(128),
  phone           varchar(128),
  expires_at      date,
  created_at      datetime,
  updated_at      datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_invitations (
  id                      bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  sender_account_id       bigint unsigned not null REFERENCES sh_accounts(id),
  receiver_email          varchar(128) not null,
  created_at              datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_relations (
  account1_id    bigint unsigned not null REFERENCES sh_accounts(id),
  account2_id    bigint unsigned not null REFERENCES sh_accounts(id),
  circle1        varchar(255) not null default 'friends',
  circle2        varchar(255) not null default 'friends',
  created_at     datetime,
  updated_at     datetime,
  PRIMARY KEY(account1_id, account2_id)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_products (
  id                bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  sku               varchar(255) not null UNIQUE KEY,
  price             decimal(10,2) not null, 
  name              varchar(255) not null,
  description       text,  
  inventory_amount  int,
  created_at        datetime,
  updated_at        datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_orders (
  id                       bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  account_id               bigint unsigned not null REFERENCES  sh_accounts(id),   
  status                   varchar(255) not null default 'initiated',
  billing_fullname         varchar(255) not null,
  billing_street           varchar(255) not null,
  billing_city             varchar(128) not null,
  billing_zip              varchar(20) not null,
  billing_province_state   varchar(255) not null,
  billing_country          varchar(128) not null,
  billing_phone            varchar(128) not null,
  shipping_different       tinyint(1), 
  shipping_fullname        varchar(255) not null,
  shipping_street          varchar(255) not null,
  shipping_city            varchar(128) not null,
  shipping_zip             varchar(20) not null,
  shipping_province_state  varchar(255) not null,
  shipping_country         varchar(128) not null,
  shipping_phone           varchar(128) not null,
  paid_at                  datetime,
  shipped_at               datetime,
  shipping_method          varchar(128),
  shipping_price           decimal(10,2),
  tracking_number          varchar(255),
  payment_method           varchar(255) default 'braintree',
  total                    decimal(10,2),
  created_at               datetime,
  updated_at               datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_order_products (
  id                bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  order_id          BIGINT UNSIGNED NOT NULL REFERENCES sh_orders( id ), 
  product_id        integer not null REFERENCES sh_products(id),
  price             decimal(10,2) not null, 
  quantity          SMALLINT not null default 1
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_payments (
  id                bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  order_id          bigint unsigned not null REFERENCES sh_orders( id ),
  card_info         text,
  paid_currency     varchar(10) not null,
  paid_amount       decimal(10,2) not null, 
  exchange_rate     decimal(10,2) not null,
  paid_usd_amount   decimal(10,2) not null, 
  paid_at           datetime,
  created_at        datetime,
  updated_at        datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_blogposts (
  id              bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
  title           varchar(255) not null,
  author          varchar(128) REFERENCES sh_accounts(memberid),
  body            text,
  created_at      datetime,
  updated_at      datetime
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sh_sessions (
  sid          varchar(255) not null PRIMARY KEY,
  data         text,
  timestamp    int(11) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into sh_accounts(id, memberid, email, pwd, full_name, street, city, zip, province_state, country, 
                        phone, expires_at, created_at, updated_at) values 
(1, 'H4g03FhAyoY5AGuHitMg',  'marina+michaljeff@marina-mac.local', SHA1('abc123'), 'Michael Jefferson', 
 '#42 678766 Springfield Dr.', 'Richmond', 'V3Y 1Y6', 'BC', 'Canada', '406-234-4567', '2012-12-10', now(), now()),  
(2, 'V7izK9LGq918N8ggWSMI',  'marina+howareyou@marina-mac.local', SHA1('abc123'), 'Kiel Thompson', 
 '#562-4527 Park Ave', 'Burnaby', 'I5W 2Y8', 'BC', 'Canada', '406-234-6782', '2012-12-30', now(), now()),  
(3, 'm6zb5vxhs42ufouZ4pn8',  'marina+junni@marina-mac.local', SHA1('abc123'), 'Lilac Tremp', 
 '#25-289 St.', 'Pitt Meadows', 'K5U 7X8', 'BC', 'Canada', '406-234-2290', '2013-01-05', now(), now()),  
(4, '6J78t00POB10o90b6qh9',  'marina+sullivan@marina-mac.local', SHA1('abc123'), 'Shanny Sullivan', 
 '#42 678766 Springfield Dr.', 'Richmond', 'T5U 2Y8', 'BC', 'Canada', '406-234-2290', '2013-01-10', now(), now()),  
(5, 'krYVA24h6P4B45pZQJY2',  'marina+karina@marina-mac.local', SHA1('abc123'), 'Karina Bristly', 
 '#324-3567 Cleverdale St.', 'Burnaby', 'I4W 8S8', 'BC', 'Canada', '406-234-2290', '2012-12-10', now(), now());  

insert into sh_blogposts ( title, author, body, created_at, updated_at ) values
('Using Silex', 'krYVA24h6P4B45pZQJY2', '...',  now(), now()),
('Learn Braintree', 'm6zb5vxhs42ufouZ4pn8', 'Learning braintree payment processing', now(), now()),
('Online shop', '6J78t00POB10o90b6qh9', 'Doing online shopping cart', now(), now());

insert into sh_relations ( account1_id, account2_id, circle1, circle2, created_at, updated_at ) values
(1, 2, 'Palme Theatre', 'friends', now(), now()),
(1, 3, 'Palme Theatre', 'Palme Theatre', now(), now()),
(4, 5, 'Prizm Media', 'Prizm Media', now(), now()),
(3, 4, 'relatives', 'family', now(), now());

insert into sh_products(id, sku, price, name, description, inventory_amount, created_at, updated_at) values
(1, 'MMBR120', 40.00 , '120 day subscription','Membership subscription for unlimited access to social network and school supplies servuces for 120 next days period.',  0, now(), now()),
(2, '650SLVA', 69.95 , 'Lumivella','"Missing link" in beauty science holds the key to ageless beauty while you sleep. 
    Cutting-edge formula taps into the very latest discovery in beauty science.
    Specifically designed to counteract the effects of internal and external stress on the complexion.  
    Combats every factor that contributes to aging.
    Helps rejuvenate skin and fight wrinkles by promoting healthy collagen production 
Even better, today you can take advantage of a special opportunity and start saving the most on every order. We want to introduce you to NorthStar Nutritionals\' Preferred Beauty program—the easiest and most convenient way to ensure you never run out of Lumivella, so you can continue looking your best every day!  
Plus, enjoy our "They Notice or You Don\'t Pay" Guarantee!  
Try Lumivella for four weeks If you\'re not getting more compliments than you have in years...If friends and family members don\'t start doing double-takes when they see you...And if people don\'t start begging for your secret...Then we\'ll reimburse every penny you paid.', 2000, now(), now()),
(3, '650SSOO', 49.95, 'Soothanol X2','Works on all kinds of joint pain. 
    Ease away pain on contact.
    Back, hip and joint pain soothed. 
    Pleasant scent. 
    Easy to apply 
    FEEL THE DIFFERENCE
From muscle strains to bumps and bruises. Don\'t suffer any longer!  
A few drops of this liquid and pain is relieved on contact.  
While most over the counter topical products commonly contain one or two pain-relievers, Soothanol X2 contains a proprietary blend of 12 extracts that work together to fight all kinds of pain on contact.  
Anything is possible when you\'re no longer a prisoner of pain. Don\’t wait. Order your RISK-FREE TRIAL of Soothanol X2 right now!', 2000, now(), now()),
(4, '650SAPT', 29.95, 'ArthriPain Relief Cream','Helps you get back more of your "get up and go" in as little as 30 minutes
    Begins to relieve arthritis pain on contact
    Mess-free topical arthritis pain relief 
    Contains a unique blend of natural oils known for their ability to enhance absorption through the skin 
    Your relief is guaranteed—or your money back!  
This stunning advancement helps give you back your "get up and go" in as little as 30 minutes...without a single pill!  
You\'re about to discover the easy way to rub out arthritis pain anytime, anywhere. With this natural breakthrough, you could...
Begin to ease your pain with the very first touch Get back more of your "get up and go" in as little as 30 minutes 
    Have that soothing, sigh-of-relief right at your fingertips—whenever you need it!

Don\'t wait for one more second for that pain reliever or glucosamine supplement to kick in...Discover the brand new arthritis solution that eases your pain on contact and lets you put an end to the pill-popping waiting game once and for all!', 2000, now(), now()),
(5, '650SPIP', 39.95 , 'PureImmune Plus','Boosts activity of Natural Killer cells
    Supports proper immune response
    Fights free radicals 
    Promotes a healthy inflammatory response 
Feel good - all-year round!  
When these two immune system powerhouses come together—you can feel confident about your health all-year long. That\'s because this is focused immune support like we\'ve never seen before...  
  In just one tiny capsule, you have an immune breakthrough that can specifically support your body\'s strong NK cells—the powerful line of defense within your body. It also supports your body\'s first wave of protection—your mucosal barriers and even has natural anti-inflammatory properties . This is revolutionary, head-to-toe support.  
But it gets even stronger. PureImmune Plus is enhanced with a critical immune hero mineral -- one that is almost impossible to get enough of in our modern diet. By including this special potent form—PureImmune Plus gives you security about staying strong.

It\'s time to feel good—it\'s time to stay confident all-year long. Maintain a balanced immune system with the revolutionary power of PureImmune Plus.', 2000, now(), now()),
(6, '650SGC2', 39.95 , 'Gluco-Sure','Support optimal glucose metabolism
    Promote natural insulin sensitivity for balanced blood sugar
    Banish post meal crashes and power through your day 
    And even help shake those nasty mood swings and cravings
Stress-free blood sugar support is finally here — with the Holy Grail of blood sugar balancers
See how it could help, RISK-FREE!
Now there\'s an easier way to go above and beyond to help keep your blood sugar in perfect harmony. Because when it comes to your blood sugar - why not give your body every possible advantage? Especially when it could be this easy...
With each capsule of Gluco-Sure, you won\'t just be giving your blood sugar extra support, you\'ll finally free yourself from worry! Because with Gluco-Sure on your side, you don\'t have to give your blood sugar a second thought.

Gluco-Sure is designed to help you:

    Support optimal glucose metabolism
    Promote natural insulin sensitivity for balanced blood sugar
    Banish post meal crashes and power through your day
    And even help shake those nasty mood swings and cravings

Gluco-Sure is one of our best-selling supplements of all time. We don\'t just think it\'s a great formula - we can tell it\'s great by how many people turn to it time and again for blood sugar support.

Too many supplements out there sound too good to be true - but to PROVE this one\'s the real McCoy - we\'re backing Gluco-Sure with our Gold Standard Guarantee. If Gluco-Sure doesn\'t exceed your every expectation - you can refund it for any reason within 6 months (less shipping). Just send back whatever portion you didn\'t use -- no questions asked!

With a guarantee like that, why wait another day to experience what Gluco-Sure could do for you. Order today!', 2000, now(), now()),
(7, '650SGAR', 49.95  , 'SugarSol','Attack ALL 5 health factors of Syndrome X
and keep all your numbers healthy!  
SugarSol is scientifically designed to help keep all your numbers in the center of the healthy range, for...  
Balanced blood sugar 
    Improved cholesterol levels
    Healthy triglycerides levels
    Normal blood pressure
    And a strong, lean body you\'ll be proud to show off!
    With the help of the most well-rounded formula you\'ll find for metabolic support – featuring today\'s most recommended nutrients like magnesium and chromium to keep ALL your numbers balanced and healthy.

Because if the numbers below sound familiar – it\’s no coincidence...it’s Syndrome X.

    Waist size 40 inches or more around (35 inches for women)
    Fasting blood sugar 100mg/dL or higher
    Blood pressure—130/85 or higher
    HDL cholesterol—below 40mg/dL (50mg/dl for women)
    Triglyceride levels—150mg/dL or higher

Now you can attack each of these health factors, head on – for results you can feel. Thanks to our exclusive blend of nutrients and natural secrets, carefully selected to give you maximum metabolic support.

Keep reading to see all the ways SugarSol could help you transform your health...', 2000, now(), now()),
(8, '650SCHS', 29.95   , 'BenVia Gold Seed','One of the industry\'s most generous guarantees -- 60 full days to decide if BenVia Gold is right for you.  
    Rich, dense source of Omega 3s 
    Great-tasting source for fiber 
    Super-charge your heart health 
    Fight nasty free radicals 
    Give your bones a boost 
    Dial down occasional digestive stress 
    ORDER BenVia Gold NOW!  
    Amazing super food discovery leaves all others in the dust!  
    Introducing great news on how to provide amazing support to your blood pressure, blood sugar, cholesterol balance, energy, skin, joints, digestion and so much more...  
    In a gram-to-gram analysis, this amazing discovery packs awesome amounts of Omega 3 fatty acids, plus 5 times more calcium than whole milk, 13 times more magnesium than broccoli, 3 times more antioxidant power than fresh blueberries, more fiber than flaxseed, more protein than soy...  
Imagine a food so perfect that just a tiny bit every morning could transform your entire day. You simply stir a bit into your cereal or yogurt, and presto...  Suddenly, you\'re surging with energy all day long, and sleeping better at night... You\'ve never been more regular, as occasional constipation, diarrhea, bloating, gas and cramps virtually disappear...  
    Weight-control becomes more manageable, as hunger pangs and cravings fade, and you feel amazingly satisfied...  
    Then, as the weeks go by, imagine...  
    Your heart, arteries, blood pressure and even your cholesterol balance are all beautifully supported...  
    Your joints feel youthful as stiffness fades...  
    Friends say you\'re even looking younger and compliment you on your skin...  And what if I told you this miracle can transform all kinds of delicious foods? You can blend it into your breakfast shake, sprinkle it on our yogurt, add it to your salad make mouthwatering dinners with it, bake cookies with it, or use it as thickener for sauces; it just makes everything more satisfying!  It\'s a grain called Salvia Hispanica L, and when modern researchers ran tests, THEY NEARLY FELL OVER...
Because these seeds tested off the charts! Packed with so many vital nutrients -- it was clear that they had uncovered a nutritional goldmine.', 2000, now(), now()),
(9, '650SRGC', 399.95, 'RegeneCell','Bring aging to a screeching halt
    Rejuvenate every cell in your body .
    Stay young and vibrant well into your 70s…80s…and 90s. 
    Limited-time only - Blender Bottle to mix your product with ease, yours free!  
Anti-aging Alert 
Why settle for just looking younger...when you can 
Rejuvenate every system-- And every cell--in your body In just 30 days!  
*PLEASE NOTE: Additional shipping charges apply to this product because of its weight and size.  
We cannot fulfill orders of RegeneCell to anywhere outside of the United States. Please be advised that orders placed from addresses outside of the United States will not be processed. We apologize for any inconvenience.', 2000, now(), now());

insert into sh_orders(id, account_id, status, 
  billing_fullname, billing_street, billing_city, billing_zip, billing_province_state, billing_country, billing_phone,
  shipping_different, shipping_fullname, shipping_street, shipping_city, shipping_zip, shipping_province_state, shipping_country, shipping_phone,
  paid_at, shipped_at, shipping_method, shipping_price, tracking_number, total, created_at, updated_at) values
(1, 1, 'Shipped', 'Michael Jefferson', '#42 678766 Springfield Dr.', 'Richmond', 'V3Y 1Y6', 'BC', 'Canada', '406-234-4567',
  1,'Lucy Jefferson', '#56-3456 Sherbrook St.', 'Mountain View', '12343', 'Hawaii', 'Jamaica', '238-123-4567',
  '2012-11-26 23:30', '2012-11-28 10:00', 'USPS International Priority', 30.50, 'CJ239798823US', 200.3, '2012-11-26 23:30', now()),
(2, 1, 'Shipped', 'Michael Jefferson', '#42 678766 Springfield Dr.', 'Richmond', 'V3Y 1Y6', 'BC', 'Canada', '406-234-4567',
  1,'Thomas Kinly', '#289-2456 Kilsby Ave.', 'Mountain View', '56743', 'CA', 'USA', '112-565-2567',
  '2012-11-26 23:30', '2012-11-28 10:00', 'USPS Domestic Express', 20.99, 'CJ22345423US', 100.89, '2012-10-15 18:30', now());

insert into sh_order_products ( order_id, product_id, price, quantity ) values
(1, 2, 49.95, 1),
(1, 5, 39.95, 3),
(2, 4, 49.95, 1),
(2, 7, 29.95, 1);

insert into sh_payments ( order_id, card_info, paid_currency, paid_amount, exchange_rate, paid_usd_amount, paid_at, 
                          created_at, updated_at ) values
(1, '---          +
 :type: master+
 :month: 9    +
 :year: 2014  +
 :f4: "5348"  +
 :l4: "6688"  +', 'USD', 200.3, 1.0, 200.3, '2012-11-26 23:30', '2012-11-26 23:30', '2012-11-26 23:30'),
(2, '---      +
 :type: master+
 :month: 9    + 
 :year: 2014  +
 :f4: "5348"  +
 :l4: "6688"  +', 'USD', 100.89, 1.0, 100.89, '2012-11-26 23:30', '2012-11-26 23:30', '2012-11-26 23:30');

--
--  List of world's countries containing the official short names in English as given in ISO 3166-1,
--  the ISO 3166-1-alpha-2 code provided by the International Organization for Standardization
--  (http://www.iso.org/iso/prods-services/iso3166ma/02iso-3166-code-lists/country_names_and_code_elements)
--  and the ISO alpha-3 code provided by the United Nations Statistics Division
--  (http://unstats.un.org/unsd/methods/m49/m49alpha.htm)
--
--  compiled by Stefan Gabos
--  version 1.2 (last revision: December 09, 2012)
--
--  http://stefangabos.ro/other-projects/list-of-world-countries-with-national-flags/
--

CREATE TABLE `sh_countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `alpha_2` varchar(2) NOT NULL default '',
  `alpha_3` varchar(3) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sh_countries` (`name`, `alpha_2`, `alpha_3`) VALUES
    ('Afghanistan', 'af', 'afg'),
    ('Aland Islands', 'ax', 'ala'),
    ('Albania', 'al', 'alb'),
    ('Algeria', 'dz', 'dza'),
    ('American Samoa', 'as', 'asm'),
    ('Andorra', 'ad', 'and'),
    ('Angola', 'ao', 'ago'),
    ('Anguilla', 'ai', 'aia'),
    ('Antarctica', 'aq', ''),
    ('Antigua and Barbuda', 'ag', 'atg'),
    ('Argentina', 'ar', 'arg'),
    ('Armenia', 'am', 'arm'),
    ('Aruba', 'aw', 'abw'),
    ('Australia', 'au', 'aus'),
    ('Austria', 'at', 'aut'),
    ('Azerbaijan', 'az', 'aze'),
    ('Bahamas', 'bs', 'bhs'),
    ('Bahrain', 'bh', 'bhr'),
    ('Bangladesh', 'bd', 'bgd'),
    ('Barbados', 'bb', 'brb'),
    ('Belarus', 'by', 'blr'),
    ('Belgium', 'be', 'bel'),
    ('Belize', 'bz', 'blz'),
    ('Benin', 'bj', 'ben'),
    ('Bermuda', 'bm', 'bmu'),
    ('Bhutan', 'bt', 'btn'),
    ('Bolivia, Plurinational State of', 'bo', 'bol'),
    ('Bonaire, Sint Eustatius and Saba', 'bq', 'bes'),
    ('Bosnia and Herzegovina', 'ba', 'bih'),
    ('Botswana', 'bw', 'bwa'),
    ('Bouvet Island', 'bv', ''),
    ('Brazil', 'br', 'bra'),
    ('British Indian Ocean Territory', 'io', ''),
    ('Brunei Darussalam', 'bn', 'brn'),
    ('Bulgaria', 'bg', 'bgr'),
    ('Burkina Faso', 'bf', 'bfa'),
    ('Burundi', 'bi', 'bdi'),
    ('Cambodia', 'kh', 'khm'),
    ('Cameroon', 'cm', 'cmr'),
    ('Canada', 'ca', 'can'),
    ('Cape Verde', 'cv', 'cpv'),
    ('Cayman Islands', 'ky', 'cym'),
    ('Central African Republic', 'cf', 'caf'),
    ('Chad', 'td', 'tcd'),
    ('Chile', 'cl', 'chl'),
    ('China', 'cn', 'chn'),
    ('Christmas Island', 'cx', ''),
    ('Cocos (Keeling) Islands', 'cc', ''),
    ('Colombia', 'co', 'col'),
    ('Comoros', 'km', 'com'),
    ('Congo', 'cg', 'cog'),
    ('Congo, The Democratic Republic of the', 'cd', 'cod'),
    ('Cook Islands', 'ck', 'cok'),
    ('Costa Rica', 'cr', 'cri'),
    ('Cote d\'Ivoire', 'ci', 'civ'),
    ('Croatia', 'hr', 'hrv'),
    ('Cuba', 'cu', 'cub'),
    ('Curacao', 'cw', 'cuw'),
    ('Cyprus', 'cy', 'cyp'),
    ('Czech Republic', 'cz', 'cze'),
    ('Denmark', 'dk', 'dnk'),
    ('Djibouti', 'dj', 'dji'),
    ('Dominica', 'dm', 'dma'),
    ('Dominican Republic', 'do', 'dom'),
    ('Ecuador', 'ec', 'ecu'),
    ('Egypt', 'eg', 'egy'),
    ('El Salvador', 'sv', 'slv'),
    ('Equatorial Guinea', 'gq', 'gnq'),
    ('Eritrea', 'er', 'eri'),
    ('Estonia', 'ee', 'est'),
    ('Ethiopia', 'et', 'eth'),
    ('Falkland Islands (Malvinas)', 'fk', 'flk'),
    ('Faroe Islands', 'fo', 'fro'),
    ('Fiji', 'fj', 'fji'),
    ('Finland', 'fi', 'fin'),
    ('France', 'fr', 'fra'),
    ('French Guiana', 'gf', 'guf'),
    ('French Polynesia', 'pf', 'pyf'),
    ('French Southern Territories', 'tf', ''),
    ('Gabon', 'ga', 'gab'),
    ('Gambia', 'gm', 'gmb'),
    ('Georgia', 'ge', 'geo'),
    ('Germany', 'de', 'deu'),
    ('Ghana', 'gh', 'gha'),
    ('Gibraltar', 'gi', 'gib'),
    ('Greece', 'gr', 'grc'),
    ('Greenland', 'gl', 'grl'),
    ('Grenada', 'gd', 'grd'),
    ('Guadeloupe', 'gp', 'glp'),
    ('Guam', 'gu', 'gum'),
    ('Guatemala', 'gt', 'gtm'),
    ('Guernsey', 'gg', 'ggy'),
    ('Guinea', 'gn', 'gin'),
    ('Guinea-Bissau', 'gw', 'gnb'),
    ('Guyana', 'gy', 'guy'),
    ('Haiti', 'ht', 'hti'),
    ('Heard Island and McDonald Islands', 'hm', ''),
    ('Holy See (Vatican City State)', 'va', 'vat'),
    ('Honduras', 'hn', 'hnd'),
    ('Hong Kong', 'hk', 'hkg'),
    ('Hungary', 'hu', 'hun'),
    ('Iceland', 'is', 'isl'),
    ('India', 'in', 'ind'),
    ('Indonesia', 'id', 'idn'),
    ('Iran, Islamic Republic of', 'ir', 'irn'),
    ('Iraq', 'iq', 'irq'),
    ('Ireland', 'ie', 'irl'),
    ('Isle of Man', 'im', 'imn'),
    ('Israel', 'il', 'isr'),
    ('Italy', 'it', 'ita'),
    ('Jamaica', 'jm', 'jam'),
    ('Japan', 'jp', 'jpn'),
    ('Jersey', 'je', 'jey'),
    ('Jordan', 'jo', 'jor'),
    ('Kazakhstan', 'kz', 'kaz'),
    ('Kenya', 'ke', 'ken'),
    ('Kiribati', 'ki', 'kir'),
    ('Korea, Democratic People\'s Republic of', 'kp', 'prk'),
    ('Korea, Republic of', 'kr', 'kor'),
    ('Kuwait', 'kw', 'kwt'),
    ('Kyrgyzstan', 'kg', 'kgz'),
    ('Lao People\'s Democratic Republic', 'la', 'lao'),
    ('Latvia', 'lv', 'lva'),
    ('Lebanon', 'lb', 'lbn'),
    ('Lesotho', 'ls', 'lso'),
    ('Liberia', 'lr', 'lbr'),
    ('Libyan Arab Jamahiriya', 'ly', 'lby'),
    ('Liechtenstein', 'li', 'lie'),
    ('Lithuania', 'lt', 'ltu'),
    ('Luxembourg', 'lu', 'lux'),
    ('Macao', 'mo', 'mac'),
    ('Macedonia, The former Yugoslav Republic of', 'mk', 'mkd'),
    ('Madagascar', 'mg', 'mdg'),
    ('Malawi', 'mw', 'mwi'),
    ('Malaysia', 'my', 'mys'),
    ('Maldives', 'mv', 'mdv'),
    ('Mali', 'ml', 'mli'),
    ('Malta', 'mt', 'mlt'),
    ('Marshall Islands', 'mh', 'mhl'),
    ('Martinique', 'mq', 'mtq'),
    ('Mauritania', 'mr', 'mrt'),
    ('Mauritius', 'mu', 'mus'),
    ('Mayotte', 'yt', 'myt'),
    ('Mexico', 'mx', 'mex'),
    ('Micronesia, Federated States of', 'fm', 'fsm'),
    ('Moldova, Republic of', 'md', 'mda'),
    ('Monaco', 'mc', 'mco'),
    ('Mongolia', 'mn', 'mng'),
    ('Montenegro', 'me', 'mne'),
    ('Montserrat', 'ms', 'msr'),
    ('Morocco', 'ma', 'mar'),
    ('Mozambique', 'mz', 'moz'),
    ('Myanmar', 'mm', 'mmr'),
    ('Namibia', 'na', 'nam'),
    ('Nauru', 'nr', 'nru'),
    ('Nepal', 'np', 'npl'),
    ('Netherlands', 'nl', 'nld'),
    ('New Caledonia', 'nc', 'ncl'),
    ('New Zealand', 'nz', 'nzl'),
    ('Nicaragua', 'ni', 'nic'),
    ('Niger', 'ne', 'ner'),
    ('Nigeria', 'ng', 'nga'),
    ('Niue', 'nu', 'niu'),
    ('Norfolk Island', 'nf', 'nfk'),
    ('Northern Mariana Islands', 'mp', 'mnp'),
    ('Norway', 'no', 'nor'),
    ('Oman', 'om', 'omn'),
    ('Pakistan', 'pk', 'pak'),
    ('Palau', 'pw', 'plw'),
    ('Palestinian Territory, Occupied', 'ps', 'pse'),
    ('Panama', 'pa', 'pan'),
    ('Papua New Guinea', 'pg', 'png'),
    ('Paraguay', 'py', 'pry'),
    ('Peru', 'pe', 'per'),
    ('Philippines', 'ph', 'phl'),
    ('Pitcairn', 'pn', 'pcn'),
    ('Poland', 'pl', 'pol'),
    ('Portugal', 'pt', 'prt'),
    ('Puerto Rico', 'pr', 'pri'),
    ('Qatar', 'qa', 'qat'),
    ('Reunion', 're', 'reu'),
    ('Romania', 'ro', 'rou'),
    ('Russian Federation', 'ru', 'rus'),
    ('Rwanda', 'rw', 'rwa'),
    ('Saint Barthelemy', 'bl', 'blm'),
    ('Saint Helena, Ascension and Tristan Da Cunha', 'sh', 'shn'),
    ('Saint Kitts and Nevis', 'kn', 'kna'),
    ('Saint Lucia', 'lc', 'lca'),
    ('Saint Martin (French Part)', 'mf', 'maf'),
    ('Saint Pierre and Miquelon', 'pm', 'spm'),
    ('Saint Vincent and The Grenadines', 'vc', 'vct'),
    ('Samoa', 'ws', 'wsm'),
    ('San Marino', 'sm', 'smr'),
    ('Sao Tome and Principe', 'st', 'stp'),
    ('Saudi Arabia', 'sa', 'sau'),
    ('Senegal', 'sn', 'sen'),
    ('Serbia', 'rs', 'srb'),
    ('Seychelles', 'sc', 'syc'),
    ('Sierra Leone', 'sl', 'sle'),
    ('Singapore', 'sg', 'sgp'),
    ('Sint Maarten (Dutch Part)', 'sx', 'sxm'),
    ('Slovakia', 'sk', 'svk'),
    ('Slovenia', 'si', 'svn'),
    ('Solomon Islands', 'sb', 'slb'),
    ('Somalia', 'so', 'som'),
    ('South Africa', 'za', 'zaf'),
    ('South Georgia and The South Sandwich Islands', 'gs', ''),
    ('South Sudan', 'ss', 'ssd'),
    ('Spain', 'es', 'esp'),
    ('Sri Lanka', 'lk', 'lka'),
    ('Sudan', 'sd', 'sdn'),
    ('Suriname', 'sr', 'sur'),
    ('Svalbard and Jan Mayen', 'sj', 'sjm'),
    ('Swaziland', 'sz', 'swz'),
    ('Sweden', 'se', 'swe'),
    ('Switzerland', 'ch', 'che'),
    ('Syrian Arab Republic', 'sy', 'syr'),
    ('Taiwan, Province of China', 'tw', ''),
    ('Tajikistan', 'tj', 'tjk'),
    ('Tanzania, United Republic of', 'tz', 'tza'),
    ('Thailand', 'th', 'tha'),
    ('Timor-Leste', 'tl', 'tls'),
    ('Togo', 'tg', 'tgo'),
    ('Tokelau', 'tk', 'tkl'),
    ('Tonga', 'to', 'ton'),
    ('Trinidad and Tobago', 'tt', 'tto'),
    ('Tunisia', 'tn', 'tun'),
    ('Turkey', 'tr', 'tur'),
    ('Turkmenistan', 'tm', 'tkm'),
    ('Turks and Caicos Islands', 'tc', 'tca'),
    ('Tuvalu', 'tv', 'tuv'),
    ('Uganda', 'ug', 'uga'),
    ('Ukraine', 'ua', 'ukr'),
    ('United Arab Emirates', 'ae', 'are'),
    ('United Kingdom', 'gb', 'gbr'),
    ('United States', 'us', 'usa'),
    ('United States Minor Outlying Islands', 'um', ''),
    ('Uruguay', 'uy', 'ury'),
    ('Uzbekistan', 'uz', 'uzb'),
    ('Vanuatu', 'vu', 'vut'),
    ('Venezuela, Bolivarian Republic of', 've', 'ven'),
    ('Viet Nam', 'vn', 'vnm'),
    ('Virgin Islands, British', 'vg', 'vgb'),
    ('Virgin Islands, U.S.', 'vi', 'vir'),
    ('Wallis and Futuna', 'wf', 'wlf'),
    ('Western Sahara', 'eh', 'esh'),
    ('Yemen', 'ye', 'yem'),
    ('Zambia', 'zm', 'zmb'),
    ('Zimbabwe', 'zw', 'zwe')
