" Title: vTransfer
" Description: Upload and download files using lftp.
" Usage: :Tput and :Tget
"        See README for more
" Github: https://github.com/sgelb/vTransfer
" Author: sgelb (github.com/sgelb)
" License: MIT

function! h:GetConf()
    " read config file
    " The following function is
    " Copyright (C) Viktor Hesselbom (hesselbom.net)
    let conf = {}

    let l:configpath = expand('%:p:h')
    let l:configfile = l:configpath . '/.vTransfer'
    let l:foundconfig = ''
    if filereadable(l:configfile)
        let l:foundconfig = l:configfile
    else
        while !filereadable(l:configfile)
            let slashindex = strridx(l:configpath, '/')
            if slashindex >= 0
                let l:configpath = l:configpath[0:slashindex]
                let l:configfile = l:configpath . '.vTransfer'
                let l:configpath = l:configpath[0:slashindex-1]
                if filereadable(l:configfile)
                    let l:foundconfig = l:configfile
                    break
                endif
                if slashindex ==# 0 && !filereadable(l:configfile)
                    break
                endif
            else
                break
            endif
        endwhile
    endif

    if strlen(l:foundconfig) > 0
        let options = readfile(l:foundconfig)
        for i in options
            let vname = substitute(i[0:stridx(i, ' ')], '^\s*\(.\{-}\)\s*$', '\1', '')
            let vvalue = substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', '')
            let conf[vname] = vvalue
        endfor
        let conf['local_root'] = fnamemodify(l:foundconfig, ':h:p') . '/'
    endif

    return conf
endfunction

function! h:TransferFile(actionType)
    let conf = h:GetConf()
    
    " ask for missing options
    let askForOptions = ['host', 'user', 'pass', 'port', 'local_root', 'remote_root']

    for opt in askForOptions
        if !has_key(conf, opt)
            inputsave()
            let conf[opt] = input('Enter ' . opt . ': ')
            inputrestore()
        endif
    endfor

    " create localpath and remotepath
    let conf['localpath'] = expand('%:p')
    let conf['remotepath'] = conf['remote_root'] . conf['localpath'][strlen(conf['local_root']):]

    if has_key(conf, 'host')
        " create different actions for put and get
        if a:actionType ==# "put"
            let action = printf('%s %s -o %s', a:actionType, conf['localpath'], conf['remotepath'])
        elseif a:actionType ==# "get"
            let action = printf('%s %s -o %s', a:actionType, conf['remotepath'], conf['localpath'])
        endif

        " create command
        let cmd = printf('lftp -p %s -u %s,%s %s ', conf['port'], conf['user'], conf['pass'], conf['host']) 
        let cmd .= printf('-e "set ftp:passive-mode off;set xfer:clobber on;%s;quit;"', action)

        " confirm transfer if set in config
        if (a:actionType ==# "put") && (conf['confirm_upload'] ==# 1)
            let choice = confirm('Upload file?', "&Yes\n&No", 2)
        elseif (a:actionType ==# "get") && (conf['confirm_download'] ==# 1)
            let choice = confirm('Download file?', "&Yes\n&No", 2)
        endif

        if choice != 1
            echo 'Canceled.'
            return
        endif

        execute '!' . cmd
    else
        " no host, no transfer
        echo 'Could not find .vTransfer config file'
    endif
endfunction

command! Tget call h:TransferFile("get")
command! Tput call h:TransferFile("put")
