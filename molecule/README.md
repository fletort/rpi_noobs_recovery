# Molecule Unit Test

## Objective

Some "normal" scenarios are defined to try to cover different possible usage.
Some other scenario are errors scenarios. They are here to test error case
and to check if more intelligible error message (than built-in default error
ansible message) are shown to the user. Some task are developed to handle
this kind of friendly error message. So we have to test it.

## Context

Each scenarios are using:
- a local noobs repository to can control which os is available 
(`noobs_repo` docker container created by [prepare.yml][] tasks)
- a simulated root noobs partition to can control which os is actually 
available locally on the SD card.

The tested container (`rpi`) and the local noobs repository container 
(`noobs_repo`) are connected to a specific docker network `molecule-test`.
In this way, `rpi` host can join the `noobs_repo` host with its hostname
(container name).

Molecule can be executed directly on the local host or inside
a docker container with the shortcut [molecule.sh][] that takes
the same parameter that the officiel molecule client. More information
on the tips to support that are documented 
[below](#tips-and-tricks-about-the-test-context)

## Scenario

### S1: Default Scenario
[S1]: #s1-default-scenario

**Scenario:** Recover latest default os already present.
**Given** 
- Latest version _2020-08-20_ of the default os _Raspberry Pi OS Lite (32-bit)_
  is already available on the SD card inside the directory *raspios_lite_armhf*
- Another os is also available on the SD card.
- Repository contains os _Raspberry Pi OS Lite (32-bit)_ in version _2020-08-20_
  and _2020-05-20_
**When** 
- I ask to recover with the _latest_ version of the _default_ os (default behavior)
**Then** 
- Process is sucessfull.
- Only defaut os stay on the sd card in the directory *raspios_lite_armhf*
with version _2020-08-20_
- noobs cmdline is updated with _silentinstall_ and _runinstaller_ option
- _ssh_ file is created on the root of the noobs partition

[Link To Scenario Directory](./default/)

### S2: Download SpecificOsDate Scenario
[S2]: #s2-download-specificosdate-scenario

**Scenario:** Recover specific os on specific date version (not present locally).
**Given** 
- Only os _Test OS 1_ is available on the sd card in version _2019-01-01_
- The version _2020-08-20_ of _Test OS 1_ is available on the repository
**When** 
- I ask to recover on os _Test OS 1_ with the version _2020-08-20_
**Then** 
- Process is sucessfull.
- The SD Card contains only one OS in the directory *test_os_1* with
version _2020-08-20_
- noobs cmdline is updated with _silentinstall_ and _runinstaller_ option
- _ssh_ file is created on the root of the noobs partition

[Link To Scenario Directory](./os_dwl_specific_date/)

### S3: Download Light package Scenario
[S3]: #s3-download-light-package-scenario

**Scenario:** Recover on a downloaded small package 
**Given** 
- Only os _Test OS 1_ is available on the sd card in version _2019-01-01_
- The version _2019-11-09_ of _Test OS 2_ is available on the repository
- The package of _Test OS 2_ contains only mandatory artifacts.
**When** 
- I ask to recover on os _Test OS 2_ 
**Then** 
- Process is sucessfull.
- The SD Card contains only one OS in the directory *test_os_2* with
version _2019-11-09_
- noobs cmdline is updated with _silentinstall_ and _runinstaller_ option
- _ssh_ file is created on the root of the noobs partition

[Link To Scenario Directory](./os_dwl_light/)

### E1: OsNameNotFound Scenario
[Es1]: #e1-osnamenotfound-scenario

**Scenario:** Try to Recover on non existing os.
**Given** 
- os _unknow os_ is not available on the repository or on the sd card.
**When** 
- I ask to recover on os _unknow os_
**Then** 
- The process failed on step _Failed if Requested Package Name is not available_
- The error message is:
```yaml
"The package 'unknow os' does not exists on given repo server."
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_name_not_found/)

### E2: OsDeliveryNotFound Scenario
[E2]: #e2-osdeliverynotfound-scenario

**Scenario:** Try to Recover on non existing delivery.
**Given** 
- os _Test OS 1_ is available on the repository on version _2020-08-20_ only.
**When** 
- I ask to recover on os _Test OS 1_ on delivery _2020-08-21_
**Then** 
- The process failed on step _Failed if Requested Package Release is not available_
- The error message is:
```yaml
"The package release '2020-08-21' of os 'Test OS 1' does not exists on given repo server."
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_delivery_not_found/)

### E3: Repository OsDouble Scenario
[E3]: #e3-repository-osdouble-scenario

**Scenario:** Try to Recover on an OS entry present twice on the repo.
**Given** 
- os _Test OS 2_ is available on the repository with release date _2019-11-09_
  and got twice entry with the release date _2020-01-19_.
- os _Test OS 2_ is not available on the sd card.
**When** 
- I ask to recover on os _Test OS 2_
**Then** 
- The process failed on step _Failed if too much Package available_
- The error message is:
```yaml
"More than 1 package is available for the release 'latest' of os 'Test OS 2'."
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_double_repo/)

### E4: SD Card OsDouble Scenario
[E4]: #e4-sd-card-osdouble-scenario

**Scenario:** Try to Recover on an OS entry present twice on the sd card.
**Given** 
- os _Test OS 1_ in version _2019-01-01_ is present twice on the sd card.
**When** 
- I ask to recover on os _Test OS 1_ in version _2019-01-01_.
**Then** 
- The process failed on step _Failed if too much local Packages are selected_
- The error message is:
```yaml
"More than 1 local package is selected."
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_double_sdcard/)

### E5: Repository Wrong Package Scenario
[E5]: #e5-repository-wrong-package-scenario

**Scenario:** Try to Recover on an OS with missing mandatory package.
**Given** 
- os _Test Os 3_ is present on the repository with *os_info* decription missing.
**When** 
- I ask to recover on os _Test Os 3_
**Then** 
- The process failed on step _Failed if a mandatory artifact is not defined_
- The error message is:
```yaml
"Mandatory artifact 'os_info' is missing."
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_repo_wrong_descriptor)

### E6: Repository Package Missing File
[E6]: #e6-repository-package-missing-file

**Scenario:** Try to Recover on an OS with missing file.
**Given** 
- os _Test os missing file_ is present on the repository with *os_json* and 
*partition_setup.sh* files missing.
- One os is present on the SD CARD in the directory _test_os_1_ with
version _2019-01-01_
**When** 
- I ask to recover on os _Test os missing file_
**Then** 
- The process failed on step _Repository Download Error_
- The error message is:
```yaml
- "Repository Error. Following files can not be downloaded:"
- "- http://noobs_repo:8080/test_os_3/os.json (HTTP Error 404: Not Found)"
- "- http://noobs_repo:8080/test_os_3/partition_setup.sh (HTTP Error 404: Not Found)"
```
- The SD Card contains only one OS in the directory _test_os_1_ with
version _2019-01-01_

[Link To Scenario Directory](./os_dwl_failed_missing_file)

### E7: Repository Package Missing Tar
[E7]: #e7-repository-package-missing-tar

**Scenario:** Try to Recover on an OS with missing tar.
**Given** 
- os _Test os missing tar_ is present on the repository with *root.tar.xz* 
file missing.
- One os is present on the SD CARD in the directory *test_os_1* with
version _2019-01-01_
**When** 
- I ask to recover on os _Test os missing tar_
**Then** 
- The process failed on step _Repository Download Error_
- The error message is:
```yaml
- "Repository Error. Following file can not be downloaded:"
- - "- http://noobs_repo:8080/test_os_4/root.tar.xz (HTTP Error 404: Not Found)"
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_dwl_failed_missing_tar)

### E8: Repository Wrong Marketing Tar
[E8]: #e8-repository-wrong-marketing-tar

**Scenario:** Try to Recover on an OS package with a wrong marketing tar
**Given** 
- os _Test os wrong marketing tar_ is present on the repository with an 
empty *marketing.tar* file.
- One os is present on the SD CARD in the directory *test_os_1* with
version _2019-01-01_
**When** 
- I ask to recover on os _Test os wrong marketing tar_
**Then** 
- The process failed on step _Repostiroy Marketing tarball Error_
- The error message is:
```yaml
"Archive http://noobs_repo:8080/test_os_5/marketing.tar is not valid"
```
- The SD Card contains only one OS in the directory *test_os_1* with
version _2019-01-01_

[Link To Scenario Directory](./os_dwl_failed_wrong_marketing_tar)


## Code coverage (manual)

This chapter indicates what portion of code is covered by each scenario for
each tasks files. Actually is is maintained manually. This is a kind of Code
(or Task) Coverage.

### File: main.yml

Code Coverage:

| Task / File Inclusion                                        | [S1][]&[S3][] | [S2][]   | [E1][]&[E2][] | [E3][]&[E4][] | [E5][]&[E6][]&[E7][]&[E8][] |
|--------------------------------------------------------------|---------------|----------|---------------|---------------|----------|
| [Get Information for Requested OS from defined repository][] | included      | skipping | included      | skipping      | skipping |
| Get Release data available from os description               | ok            | skipping |               | skipping      | skipping |
| [Check/Clean OS local package(s)][]                          | included      | included |               | included      | included |
| [Get Information for Requested OS (if not already done)][]   | skipping      | included |               |               | included |
| [Download OS][]                                              | skipping      | included |               |               | included |
| Force ssh on raspos reboot                                   | changed       | changed  |               |               |          |
| [Update NOOBS command line to force install][]               | included      | included |               |               |          |
| Remove local OS Package(s) not valid                         | changed       | changed  |               |               |          |


### File: os_get_remote_info.yml

This file is included by following taks:
| Task                                                      | File     |
|-----------------------------------------------------------|----------|
| Get Information for Requested OS from defined repository  | main.yml |
| Get Information for Requested OS (if not already done)    | main.yml |

[Get Information for Requested OS from defined repository]: #file-os_get_remote_infoyml
[Get Information for Requested OS (if not already done)]: #file-os_get_remote_infoyml

Code Coverage:

| Task                                                      | [S1][]   | [S2][]   | [S3][]&[E5][]&[E6][]&[E7][] | [E1][]  | [E2][]   | [E3][]   |
|-----------------------------------------------------------|----------|----------|-----------------------------|---------|----------|----------|
| Create temporary directory for Remote package Information | changed  | changed  | changed                     | changed | changed  | changed  |
| Download repo server information                          | changed  | changed  | changed                     | changed | changed  | changed  |
| Get all Packages Information                              | ok       | ok       | ok                          | ok      | ok       | ok       |
| Filter with specified package Name                        | ok       | ok       | ok                          | ok      | ok       | ok       |
| Failed if Requested Package Name is not available         | skipping | skipping | skipping                    | fatal   | skipping | skipping |
| Filter with specified Release Date                        | skipping | ok       | skipping                    |         | ok       | skipping |
| Failed if Requested Package Release is not available      | skipping | skipping | skipping                    |         | fatal    | skipping |
| Get Only Latest Release                                   | ok       | skipping | skipping                    |         |          | ok       |
| Failed if too much Package available                      | skipping | skipping | skipping                    |         |          | fatal    |
| Save Requested Package Information                        | ok       | ok       | ok                          |         |          |          |


### File: os_check.yml

This file is included by following tasks:
| Task                                                      | File     |
|-----------------------------------------------------------|----------|
| Check/Clean OS local package(s)                           | main.yml |

[Check/Clean OS local package(s)]: #file-os_checkyml

Code Coverage:

| Task                                                      | [S1][]   | [S2][]&[S3][]&[E5][]&[E6][]&[E7][]&[E8][] | [E4][]   |
|-----------------------------------------------------------|----------|-------------------------------------------|----------|
| Get available os package(s) on the SD card                | ok       | ok                                        | ok       |
| Download SD card os package descriptor(s) content locally | ok       | ok                                        | ok       |
| Parse Package(s) Information                              | ok       | ok                                        | ok       |
| Check Package(s) vs Requested OS Name                     | ok       | ok                                        | ok       |
| Check Package(s) vs Requested OS Release Date             | ok       | ok                                        | ok       |
| Failed if too much local Packages are selected            | skipping | skipping                                  | failed   |
| Save Local Package Information                            | ok       | skipping                                  |          |

### File: os_download.yml

This file is included by following tasks:
| Task                                                      | File     |
|-----------------------------------------------------------|----------|
| Download OS                                               | main.yml |

[Download OS]: #file-os_downloadyml

Code Coverage:

| Task                                                      | [S2][]   | [S3][]   | [E5][]   | [E6][]   | [E7][]   | [E8][]   |
|-----------------------------------------------------------|----------|----------|----------|----------|----------|----------|
| Failed if a mandatory artifact is not defined             | skipping | skipping | failed   | skipping | skipping | skipping |
| Create OS Destination Directory Name                      | ok       | ok       | ok       | ok       | ok       | ok       |
| Create OS Destination Directory                           | changed  | changed  | changed  | changed  | changed  | changed  |
| Download artifacts                                        | changed  | changed  |          | failed   | changed  | changed  |
| Install tar utility                                       | changed  | skipping |          |          | changed  | changed  |
| Extract Marketing tarball                                 | changed  | skipping |          |          | changed  | failed   |
| Delete Marketing tarball                                  | changed  | skipping |          |          | changed  |          |
| Download partition tarballs                               | changed  | changed  |          |          | failed   |          |
| Define item-like variable to can use ansible_failed_task (linked to ansible issuer 57399) | | | | ok  | ok       | ok       |
| Debug: Rescue on Task Failure                             |          |          |          | ok       | ok       | ok       |
| Clean: Erase the OS Destination Directory                 |          |          |          | changed  | changed  | ok       |
| Build Friendly Error Message                              |          |          |          | ok       | ok       | skipping |
| Repository Download Error                                 |          |          |          | fatal    | fatal    | skipping |
| Repostiroy Marketing tarball Error                        |          |          |          |          |          | fatal    |

### File: cmdline_add_option.yml

This file is included by following tasks:
| Task                                                      | File     |
|-----------------------------------------------------------|----------|
| Update NOOBS command line to force install                | main.yml |

[Update NOOBS command line to force install]: #file-cmdline_add_optionyml

Code Coverage:

| Task                                                      | [S1][]&[S2][]&[S3][] |
|-----------------------------------------------------------|----------------------|
| Check if silentinstall is already defined                 | ok                   |
| Add silentinstall option to command line                  | changed              |
| Check if runinstaller is already defined                  | ok                   |
| Add runinstaller option to command line                   | changed              |


## Tips and Tricks about the test (technical) context

To be compliant with native molecule execution or containerized one, 
some tips are used.

In a containerized molecule context, tested docker container and noobs repo
container are created from the molecule container but with the docker native
application. This is possible as `/var/run/docker.sock` is shared between
the host and the molecule container.

To can "mount" native host directory relative to `PWD` the native `PWD` 
environment variable is shared to the molecule container in the `HOST_PWD`
variable. With this tips, [prepare.yml][] is sharing 
`{{ playbook_dir }}/molecule/resources/files/noobs_repository` if molecule is
executed natively or `{{ lookup('env', 'HOST_PWD') }}/molecule/resources/files/noobs_repository`
if molecule is executed from a container.

Another problem linked to thos double context is the fact that repository os 
list download is delegated to localhost (see 
[os_get_remote_info.yml][]).
So localhost can be the molecule container or the main host machine. 
The local repo is defined by its container hostname *noobs_repo* by the
test inventory.
- In case molecule is executed from the container, molecule container is added
by [prepare.yml][] to the docker network where other container are already 
(molecule-test).
- In case molecule is executed natively, *noobs_repo* container is started
with its 8080 port mapped to the host. Port used on the host is defined
by the environment variable HOST_PORT. If not    defined 8080 is also used
on the host side. Then [prepare.yml][] also change the *noobs_repo:8080* 
value from `noobs_repo_server` variable with *localhost:xxxx* (where _xxxx_
is  the mapped port on the host).


[prepare.yml]: resources/prepare.yml
[os_get_remote_info.yml]: ../tasks/os_get_remote_info.yml
[molecule.sh]: ../molecule.sh




