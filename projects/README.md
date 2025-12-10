
# Linux File Permission Visualizer:

About This Project:

- I am learning Linux, so I made a small script that scans a folder and shows all files with their permissions.
  This helps me understand how rwx, owners, groups, and special permissions work.

What the Script Does
- Scans a directory (recursively)

Shows:
File name
Permission (rwx format)
Owner
Group
Marks files that look risky, like:
777 permissions
Files with SUID, SGID, or Sticky Bit

Why I Made This

- I wanted a simple way to see which files in a folder have weird or unsafe permissions.
  While practicing Linux permissions, I realized many people don’t notice SUID/SGID or world-writable files, so I built this small tool.

How to Run:
bash permission-visualizer.sh /path/to/folder

Example Output:
./script.sh        rwxr-xr-x   user   user
./notes.txt        rw-r--r--   user   user
./test.sh          rwxrwxrwx   user   user   --> world writable
./backup-tool      rwsr-xr-x   root   root   --> suid

What I Learned:
- How to read permissions using stat
- How SUID/SGID and sticky bit work
- Basic Bash scripting
- Using find to scan directories

Future Ideas:
- Add JSON or CSV output
- Add an option to automatically fix risky permissions
