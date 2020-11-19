# Simple Functional Test

This directory contains a simple functional test targeting a physical 
Raspberry PI.

This raspberry pi must be joinable through the alias `rpi-test` (update your 
DNS, or use your local `/etc/hosts` file). If it not possible you can also
define the environment variable `RPI_TEST_HOST` with the hostname or ip
of the targeted Raspberry PI.

Prerequesite:

- Your raspberry pi must accept ssh connexion.
- The fingerprint musy already be accepted.
- Default raspbian credential is used. If Other credential must be used
please define the following environments variables: `RPI_TEST_SSH_USER` and
`RPI_TEST_SSH_PASSWORD`.




