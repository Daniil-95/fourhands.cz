<?php declare(strict_types=1);

namespace App\Security;

use Nette\Database\Explorer;
use Nette\Http\Request;
use Nette\Security\Authenticator;
use Nette\Security\AuthenticationException;
use Nette\Security\IIdentity;
use Nette\Security\SimpleIdentity;

final class AdminAuthenticator implements Authenticator
{
    public function __construct(
        private Explorer $db,
        private Request $httpRequest,
    )
    {
    }

    public function authenticate(string $username, string $password): IIdentity
    {
        return $this->authenticateWithI60Schema($username, $password);
    }

    private function authenticateWithI60Schema(string $login, string $password): IIdentity
    {
        $row = $this->db->table('users')->where('username', $login)->fetch();

        if (!$row) {
            $this->logLoginAttempt(null, $login, false, 'user_not_found');
            throw new AuthenticationException('Invalid credentials.');
        }

        if ((int) $row->active !== 1) {
            $this->logLoginAttempt((int) $row->id, $login, false, 'inactive');
            throw new AuthenticationException('Account is inactive.');
        }

        if (!password_verify($password, (string) $row->password)) {
            $this->logLoginAttempt((int) $row->id, $login, false, 'invalid_password');
            throw new AuthenticationException('Invalid credentials.');
        }

        $roles = $this->extractRoles($this->loadRoleCodes((int) $row->id));
        if ($roles === [] || !in_array('admin', $roles, true)) {
            $this->logLoginAttempt((int) $row->id, $login, false, 'no_admin_access');
            throw new AuthenticationException('You do not have admin access.');
        }

        $this->logLoginAttempt((int) $row->id, $login, true, 'ok');

        return new SimpleIdentity((int) $row->id, $roles, [
            'username' => (string) $row->username,
        ]);
    }

    private function extractRoles(array $roleCodes): array
    {
        $roles = [];

        foreach ($roleCodes as $part) {
            $part = trim($part);
            if ($part !== '') {
                $roles[] = $part;
            }
        }

        return array_values(array_unique($roles));
    }

    private function loadRoleCodes(int $userId): array
    {
        $rows = $this->db->query(
            'SELECT r.role
             FROM users_roles ur
             INNER JOIN roles r ON r.id = ur.roles_id
             WHERE ur.users_id = ?',
            $userId,
        )->fetchAll();

        $roles = [];
        foreach ($rows as $row) {
            if (isset($row->role) && is_string($row->role)) {
                $roles[] = $row->role;
            }
        }

        return $roles;
    }

    private function logLoginAttempt(?int $userId, string $usernameInput, bool $isSuccess, string $reason): void
    {
        try {
            $this->db->table('log_users_login')->insert([
                'users_id' => $userId,
                'remote_ip' => (string) ($this->httpRequest->getRemoteAddress() ?? ''),
                'remote_host' => mb_substr((string) ($this->httpRequest->getHeader('Host') ?? $usernameInput), 0, 255),
            ]);
        } catch (\Throwable $e) {
            // Keep authentication flow independent from optional logging.
        }
    }
}
