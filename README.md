# Linux Learning Notes

## Topics learnt so far

* Basic File Permissions (r, w, x)
* Directory Permissions (r, w, x on folders)
* Ownership and Groups (chown, chgrp, usermod)
* Special Permissions (SUID, SGID, Sticky Bit)
* ACL (Access Control Lists)
* Hard Links vs Soft Links
* Linux File Types (`-`, `d`, `l`, `b`, `c`, `p`, `s`)
* Real-Time Permission Scenarios (deployuser, CI/CD directories)

## Usecase that covers all these topics

We are going to simulate a real DevOps scenario to understand all the Linux concepts we learned so far:

* We have a multi-user application deployment environment.
* The directory `/opt/appdata` is shared between developers, CI/CD pipelines, and sometimes external contractors.
* Developers need to:

  * Edit and execute application scripts.
  * Run scripts that may have elevated privileges.
* CI/CD pipelines must:

  * Write logs and temporary build artifacts.
* Certain files are:

  * Sensitive scripts that only the owner can execute.
  * Config files linked via symlinks for multiple app locations.
  * Backup scripts replicated with hard links to preserve persistence.
* Contractors occasionally require temporary access to some configuration files without affecting permanent permissions.
* Docker environment requires:

  * Non-root users to access sockets and device files for container management.
* Shared directories must prevent accidental deletion of files by other users.
* Users belong to multiple groups, and permissions on parent directories, child directories, and individual files interact in complex ways.
* We need to handle real-time errors like “permission denied” or “cannot create file” while maintaining security and collaboration.

## Simulation process

1. Create multiple users including a deployment user and add them to relevant groups.
2. Create `/opt/appdata` and subdirectories representing scripts, logs, and configs.
3. Assign varying ownership and group memberships to directories and files.
4. Apply different permissions (r, w, x) to files and directories according to user roles.
5. Add SUID/SGID/sticky bits on critical scripts and shared directories.
6. Create ACL entries for temporary access to contractors.
7. Set up hard links for backups and symlinks for config files.
8. Simulate Docker environment and access to sockets and devices.
9. Test multi-user interactions by attempting to read, write, and execute files according to roles.

## Solution (command mode in order of usecase)

Q: How do we allow developers to edit and execute application scripts?
A: `chmod u+rwx /opt/appdata/scripts && chown devuser:devteam /opt/appdata/scripts`

Q: How do we let developers run scripts with elevated privileges?
A: `chmod u+s /opt/appdata/scripts/sensitive_script.sh`

Q: How do CI/CD pipelines write logs and temporary build artifacts?
A: `chmod g+rwx /opt/appdata/logs && chgrp cicd /opt/appdata/logs`

Q: How do we manage sensitive scripts that only the owner can execute?
A: `chmod 700 /opt/appdata/scripts/secure_script.sh && chown owner:owner /opt/appdata/scripts/secure_script.sh`

Q: How do we link configuration files for multiple applications?
A: `ln -s /opt/appdata/config.yaml /etc/app/config.yaml`

Q: How do we ensure backup scripts persist even if originals are deleted?
A: `ln /opt/appdata/backup_script.sh /opt/backups/backup_script.sh`

Q: How do we give contractors temporary access without affecting permanent permissions?
A: `setfacl -m u:contractor:rwx /opt/appdata/configs`

Q: How do we ensure Docker processes running as non-root can access necessary sockets and devices?
A: `chgrp docker /var/run/docker.sock && chmod 660 /var/run/docker.sock`

Q: How do we prevent accidental deletion in shared directories?
A: `chmod +t /opt/appdata/shared`
