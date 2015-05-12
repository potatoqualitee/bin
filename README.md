# locate
Invoke-Locate.ps1 Locate for Windows using PowerShell and SQLite.

This script was made in the spirit of (Linux/Unix) GNU findutils' locate. 

While the name of this script is Invoke-Locate, it actually creates two persistent aliases: locate and updatedb. A fresh index is automatically created every 6 hours, and updatedb can be used force a refresh. Indexing takes anywhere from 30 seconds to 15 minutes, depending on the speed of your drives. Performing the actual locate takes about 300 milliseconds. This is made possible by using SQLite as the backend. Invoke-Locate supports both case-sensitive, and case-insensitive searches, and is case-insensitive by default. 

Locate searches are per-user, and the database is stored securely in your home directory. You can search system files and your own home directory, but will not be able to search for filenames in other users' directories. 

Note: This is a work in progress (version 0.x), and I'm currently testing it in various environments. Please let me know if you have any issues. I fixed a few bugs over the weekend. Please download the newest version.