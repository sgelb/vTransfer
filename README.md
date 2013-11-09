vTransfer
=========

Vim plugin for putting and getting files to/from remote locations using
[lftp][]. Supports ftp, ftps, http, https, hftp, fish, sftp and file (https and
ftps are only available when lftp is compiled with GNU TLS or OpenSSL library).

Based on [vim-hsftp][], but with the following differences:
- supports more protocols
- options in config file are optional
- config file is optional

Attention: this plugin is for very specific occasions. Your credentials are
saved in plaintext in either .vTransfer or ~/.viminfo!

Dependencies
------------

- [lftp][]

Todo
----

- test all protocols.

Usage
-----

If no config file is found or you omitted some options, you will be prompted.
Attention: `local_root` must be an absolute path with a trailing slash!

To make you life easier, you can create a config file `.vTransfer` in your
project root directory, `local_root` will be set automatically.

When uploading/downloading *vTransfer* searches backwards for a config file so if the
edited file is e.g. `/test/dir/file.txt` and the config file is `/test/.vTransfer`
it will upload/download as `dir/file.txt`.

This is an example config file (see vTransfer.example). All options are optional.

    host   ftp://1.1.1.1
    user   username
    pass   test123
    port   21
    remote_root /var/www/
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
