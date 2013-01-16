<?php
namespace App\Model\Entity;

use Symfony\Component\Security\Core\User\AdvancedUserInterface;

class User extends Base implements AdvancedUserInterface, \Serializable
{
   protected $id=null;
   protected $memberid=null;
   protected $email=null;
   protected $pwd=null;
   protected $full_name=null;
   protected $street=null;
   protected $city=null;
   protected $zip=null;
   protected $province_state=null;
   protected $country=null;
   protected $phone=null;
   protected $expires_at=null;
   protected $roles = array('ROLE_MEMBER');
   protected $enabled=true;
   protected $accountNonExpired=true;
   protected $credentialsNonExpired=true;
   protected $accountNonLocked=true;

    public function isAccountNonExpired()
    {
        return $this->accountNonExpired;
    }

    public function isAccountNonLocked()
    {
        return $this->accountNonLocked;
    }

    public function isCredentialsNonExpired()
    {
        return $this->credentialsNonExpired;
    }

    public function isEnabled()
    {
        return $this->enabled;
    }

    public function getRoles()
    {
        return $this->roles;
    }

    public function getPassword()
    {
        return $this->pwd;
    }

    public function getSalt()
    {
        return null;
    }

    public function getUsername()
    {
        return $this->memberid;
    }

    public function eraseCredentials()
    {
    }

    public function equals(UserInterface $user)
    {
        if (!$user instanceof App\Model\Entity\User) {
            return false;
        }
 
        if ($this->pwd !== $user->getPassword()) {
            return false;
        }
 
        if ($this->getSalt() !== $user->getSalt()) {
            return false;
        }
 
        if ($this->memberid !== $user->getUsername()) {
            return false;
        }

        if ($this->email !== $user->getEmail()) {
            return false;
        }

        if ($this->campus !== $user->getCampus()) {
            return false;
        }
 
        return true;
    }
}
