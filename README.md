vTransfer
=========

Vim plugin for putting and getting files to/from remote locations using
[lftp][]. Supports ftp, ftps, http, https, hftp, fish, sftp and file (https and
ftps are only available when lftp is compiled with GNU TLS or OpenSSL library).

Based on [vim-hsftp][].

Dependencies
------------

- [lftp][]

Todo
----

- make user/pass optional in config file
- test all protocols.

Usage
-----

You have to create a config file called `.vTransfer` in your project directory
(see `vTransfer.example`).

When uploading/downloading *vTransfer* searches backwards for a config file so if the
edited file is e.g. `/test/dir/file.txt` and the config file is `/test/.vTransfer`
it will upload/download as `dir/file.txt`.

This is an example config file, all options are mandatory:

    host   ftp://1.1.1.1
    user   username
    pass   test123
    port   21
    remote /var/www/
    confirm_download 0
    confirm_upload 0

Commands
--------

    :Tget
Gets current file from remote path

    :Tput
Puts current file to remote path


[lftp]: http://lftp.yar.ru/ "lftp"
[vim-hsftp]: https://github.com/hesselbom/vim-hsftp "hesselbom/vim-hsftp"
