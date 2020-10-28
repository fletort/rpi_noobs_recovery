# Role Name

Role used to recover a raspberry pi.

This role do a headless recover (reflash) of a raspberry pi automatically.
OS that will be flash can be specified before starting the process.

## Requirements

This role targets a Raspberry Pi with NOOBS and an OS already installed on it.

The os that will be recover (installed) can be downloaded from
NOOBS repository (or a compatible one).

The targeted Raspberry Pi must accept ssh connection.

## Role Variables

- **noobs_main_partition**

NOOBS main partition on the Raspberry Pi. Defaut value is `/dev/mmcblk0p1`.

- **noobs_repo_server**

List of NOOBS repository. This is a list of url targeting os_list files.
Default value contains the official noobs os_list:
`["http://downloads.raspberrypi.org/os_list_v3.json"]`.

- **requested_os_name**

OS name to install. Default value is `Raspberry Pi OS Lite (32-bit)`.
The name can be found on each entry (description) of the os lists used.

- **requested_os_release_date**

OS release date to install. On NOOBS os list, versionning is made with this 
informations. Default value is the special value `latest`. `latest` value
can be used to always auto update on last release. This release is automatically
downloaded when the role detect that it is available.

## Dependencies

None.

## Example Playbook

### Simple example
```yml
- hosts: servers
  roles:
    - role: fletort.rpi-noobs-recovery
```

This playbook will recover the Raspberry Pi with the latest version of the _Raspberry Pi OS Lite (32-bit)_.
It will check each time if a new version is available on the default repository.

### Install only specified os release.
```yml
- hosts: servers
  roles:
    - role: fletort.rpi-noobs-recovery
      vars:
        requested_os_name: "OSMC_Pi2"
        requested_os_release_date: "2020-10-18"
```

This playbook will always restore the release *2020-10-18* of 
the *OSMC_Pi2* os. If it is not available locally, it will be downloaded from
the default repository. Then as soon it is available locally, no any download
will be attempt.

Be careful, if it is not available locally or on the repository, an error
will occur.

### Install from specific repository.
```yml
- hosts: servers
  roles:
    - role: fletort.rpi-noobs-recovery
      vars:
        noobs_repo_server:
          - "http://downloads.raspberrypi.org/os_list_v3.json"
          - "http://myserver.com/my_os_list.json"
        requested_os_name: "my beautiful os"
```

This playbook adds a personal repository to the server list.

A specifc os, from this repository, will be installed: _my beautiful os_


## License

MIT / BSD

