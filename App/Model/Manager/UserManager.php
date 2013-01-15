<?php
namespace App\Model\Manager;

use Symfony\Component\Security\Core\User\UserProviderInterface;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\User;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Doctrine\DBAL\Connection;
use App\Model\Entity\User as UserEntity;

class UserManager implements UserProviderInterface
{
    private $conn;

    public function __construct(Connection $conn)
    {
        $this->conn = $conn;
    }

    function emailExists($email) {
        $sql = "select count(*) from sh_accounts where email = ?";
        $cnt = $this->conn->fetchColumn($sql, array($email), 0);
        return $cnt > 0;
    }

    function memberidExists($memberId) {
        $sql = "select count(*) from sh_accounts where memberid = ?";
        $cnt = $this->conn->fetchColumn($sql, array($memberId), 0);
        return $cnt > 0;
    }

    function getByEmail($email){
        $sql = "select * from sh_accounts where email = ?";
        $user = $this->conn->fetchAssoc($sql, array($email));
        return new UserEntity($user);
    }

    function getById($accountId){
        $sql = "select * from sh_accounts where id = ?";
        $user = $this->conn->fetchAssoc($sql, array($accountId));
        return new UserEntity($user);
    }

    function getByMemberId($memberId){
        $sql = "select * from sh_accounts where memberid = ?";
        $user = $this->conn->fetchAssoc($sql, array($memberId));
        return new UserEntity($user);
    }

    function registerUser(UserEntity $user) {
      if($this->memberidExists($user['memberid'])):
        throw new Exception("The username is already taken");
      elseif($this->emailExists($user['email'])):
        throw new Exception("The email is already taken");
      endif;
      $userToCommit = $user->toArray();
      $removeKeys = array('id','roles','enabled','accountNonExpired','credentialsNonExpired','accountNonLocked');
      $userToCommit = array_diff_key($userToCommit, array_flip($removeKeys));
      /*
      unset($userToCommit['id'], $userToCommit['roles'], $userToCommit['enabled'], 
        $userToCommit['accountNonExpired'], $userToCommit['credentialsNonExpired'], $userToCommit['accountNonLocked']);
      */ 
      $status = $this->conn->insert('sh_accounts', $userToCommit);
      $id_insert = $this->conn->lastInsertId();
      $this->conn->executeUpdate("update sh_accounts set created_at=now(), updated_at=now() where id=?", 
                                 array($id_insert));
      return $this->getById($id_insert);
    }

    function remove($accountId) {
        $this->conn->delete('sh_accounts', array('id' => $accountId));
    }

    /** UserProviderInterface * */
    public function loadUserByUsername($username)
    {
        $username = strtolower($username);
        $_user = $this->conn->fetchAssoc('SELECT * FROM sh_accounts WHERE (email = ? OR memberid = ?)', 
            array($username, $username));
        if (empty($_user)) {
            throw new UsernameNotFoundException(sprintf("User %s does not exist", $username));
        }
        else {
          $user = new UserEntity($_user);
        }
        return $user;
        // return new User($user['memberid'], $user['pwd'], array('ROLE_MEMBER'), true, true, true, true);
    }
 
    public function refreshUser(UserInterface $user)
    {
        if (!$user instanceof UserEntity) {
            throw new UnsupportedUserException(sprintf('Instances of "%s" are not supported.', get_class($user)));
        }
 
        return $this->loadUserByUsername($user->getUsername());
    }
 
    public function supportsClass($class)
    {
        //return $class === 'Symfony\Component\Security\Core\User\User';
        return $class === 'App\Model\Entity\User';
    }
}
