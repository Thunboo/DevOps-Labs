# system_hardening

Configures baseline security and system services on Debian-based VPS hosts.

The role:

- installs required system packages;
- hardens the OpenSSH server configuration;
- configures login banners and a dynamic MOTD;
- configures UFW with deny-by-default incoming traffic;
- configures Fail2Ban for SSH;
- optionally installs nginx configuration files.

## Requirements

- Ansible 2.14 or later
- A Debian-family target such as Debian or Ubuntu
- Privilege escalation to root
- The `community.general` collection for the UFW module

Install the required collection with:

```bash
ansible-galaxy collection install community.general
```

## Role variables (with examples)

```yaml
system_hardening_ssh_port: 2201

system_hardening_ssh_allowed_users:
  - user1
  - user2

system_hardening_configure_nginx: false
```

### `system_hardening_ssh_port`

The SSH TCP port allowed through UFW and monitored by Fail2Ban. The default is
`22`.

### `system_hardening_ssh_allowed_users`

The users permitted to connect through SSH. The default permits `thunboo`.
Ensure these users exist and have working SSH keys before applying the role.

### `system_hardening_configure_nginx`

Whether the role should deploy its nginx configuration. The default is `false`.

## Example inventory

```yaml
---
all:
  children:
    vps:
      hosts:
        vps01:
          ansible_host: 203.0.113.10
          ansible_user: thunboo
```

Example `group_vars/vps.yml`:

```yaml
---
system_hardening_ssh_port: 22
system_hardening_ssh_allowed_users:
  - thunboo
system_hardening_configure_nginx: false
```

## Example playbook

```yaml
---
- name: Harden VPS hosts
  hosts: vps
  become: true

  roles:
    - role: thunboo.vps_setup.system_hardening
```

## License

MIT

## Author

Thunboo
