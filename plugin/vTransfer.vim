" Title: vTransfer
" Description: Upload and download files using lftp.
" Usage: :Tput and :Tget
"        See README for more
" Github: https://github.com/sgelb/vTransfer
" Author: sgelb (github.com/sgelb)
" License: MIT

function! h:GetConf()
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

        let conf['local'] = fnamemodify(l:foundconfig, ':h:p') . '/'
        let conf['localpath'] = expand('%:p')
        let conf['remotepath'] = conf['remote'] . conf['localpath'][strlen(conf['local']):]
    endif

    return conf
endfunction

function! h:TransferFile(actionType)
    let conf = h:GetConf()

    if has_key(conf, 'host')

        if a:actionType ==# "put"
            let action = printf('%s %s -o %s', a:actionType, conf['localpath'], conf['remotepath'])
        elseif a:actionType ==# "get"
            let action = printf('%s %s -o %s', a:actionType, conf['remotepath'], conf['localpath'])
        endif

        let cmd = printf('lftp -p %s -u %s,%s %s ', conf['port'], conf['user'], conf['pass'], conf['host']) 
        let cmd .= printf('-e "set ftp:passive-mode off;set xfer:clobber on;%s;quit;"', action)

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
        echo 'Could not find .vTransfer config file'
    endif
endfunction

command! Tget call h:TransferFile("get")
command! Tput call h:TransferFile("put")
