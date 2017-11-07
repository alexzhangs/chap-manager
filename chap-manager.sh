#!/bin/bash

usage ()
{
    printf "Manager entries of /etc/chap-secrets\n"
    printf "${0##*/}\n"
    printf "\t-a ACTION\n"
    printf "\t-u USERNAME/CLIENT\n"
    printf "\t[-p PASSWORD]\n"
    printf "\t[-s SERVER]\n"
    printf "\t[-i CLIENT_IP]\n"
    printf "\t[-h]\n"

    printf "OPTIONS\n"
    printf "\t-a ACTION\n\n"
    printf "\tAction could be one of ADD, DEL and GET.\n\n"

    printf "\t-u USERNAME/CLIENT\n\n"
    printf "\tUsername or client hostname.\n\n"

    printf "\t[-p PASSWORD]\n\n"
    printf "\tPassword or secret for the username or the hostname.\n"
    printf "\tThis option is mandatory with action ADD, and ignored\n"
    printf "\twith action DEL and GET.\n\n"

    printf "\t[-s SERVER]\n\n"
    printf "\tServer hostname, default is '*', meaning any server, with\n"
    printf "\taction ADD, and no default value with other actions.\n\n"

    printf "\t[-i CLIENT_IP]\n\n"
    printf "\tClient IP, default is '*', meaning any IP, with action ADD,\n"
    printf "\tand ignored with action DEL and GET.\n\n"

    printf "\t[-h]\n\n"
    printf "\tThis help.\n\n"

    printf "EXAMPLE\n"
    printf "\tAdd a new chap-secrets entry: 'steve * password *':\n\n"
    printf "\t${0##*/} -a ADD -u steve -p password\n\n"

    printf "\tDelete all entries of steve:\n\n"
    printf "\t${0##*/} -a DEL -u steve\n\n"

    printf "\tGet all entries of steve:\n\n"
    printf "\t${0##*/} -a GET -u steve\n\n"
    exit 255
}

timestamp ()
{
    date "+%Y-%m-%d% %H:%M:%S"
    return $?
}

while getopts a:u:p:s:i:h opt; do
    case $opt in
        a)
            action=$(echo $OPTARG | tr 'a-z' 'A-Z')
            ;;
        u)
            username=$OPTARG
            ;;
        p)
            password=$OPTARG
            ;;
        s)
            server=$OPTARG
            ;;
        i)
            ip=$OPTARG
            ;;
        h|*)
            usage
    esac
done

[[ -z $username ]] && usage >&2

case $action in
    ADD)
        [[ -z $password ]] && usage >&2
        [[ -z $server ]] && server='\*'
        [[ -z $ip ]] && ip='\*'

        cnt=$(sed -rn "/^$username( |\t)+$server( |\t)+/p" /etc/ppp/chap-secrets | wc -l)
        if [[ $cnt -eq 0 ]]; then
            printf "%s\t%s\t%s\t%s\n" "$username" "$server" "$password" "$ip" >> /etc/ppp/chap-secrets || exit $?
        else
            echo "The entry already exists within chap-secrets" >&2
        fi
        ;;
    DEL)
        if [[ -z $server ]]; then
            sed -ri "/^$username( |\t)+/d" /etc/ppp/chap-secrets || exit $?
        else
            sed -ri "/^$username( |\t)+$server( |\t)+/d" /etc/ppp/chap-secrets || exit $?
        fi
        ;;
    GET)
        if [[ -z $server ]]; then
            sed -rn "/^$username( |\t)+/p" /etc/ppp/chap-secrets || exit $?
        else
            sed -rn "/^$username( |\t)+$server( |\t)+/p" /etc/ppp/chap-secrets || exit $?
        fi
        ;;
    *)
        usage >&2
        ;;
esac

exit
