<?php declare(strict_types=1);

namespace App\Security;

use Nette\Database\Explorer;
use Nette\Security\Authenticator;
use Nette\Security\AuthenticationException;
use Nette\Security\IIdentity;
use Nette\Security\SimpleIdentity;

final class AdminAuthenticator implements Authenticator
{
    public function __construct(private Explorer $db)
    {
    }

    public function authenticate(string $username, string $password): IIdentity
    {
        $user = $this->db->table('admin_users')->where('username', $username)->fetch();

        if (!$user || !password_verify($password, $user->password_hash)) {
            throw new AuthenticationException('Invalid credentials.');
        }

        return new SimpleIdentity((int) $user->id, $user->role, ['username' => $user->username]);
    }
}
