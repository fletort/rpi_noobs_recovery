# Role Name

Role used to recover a raspberry pi.

## Requirements

This role targets a Raspberry Pi with NOOBS and an OS already installed on it.

The os that will be recover (installed) must be the unique os available inside the os directory of NOOBS.

The targeted Raspberry Pi must accept ssh connection.

## Role Variables

| Name | Default Value | Description |
|------|---------------|-------------|
| noobs_partition | /dev/mmcblk0p1 | Parition where NOOBS is located |

## Dependencies

None.

## Example Playbook

```yml
- hosts: servers
  roles:
    - role: fletort.rpi-noobs-recovery
```

## License

MIT / BSD

