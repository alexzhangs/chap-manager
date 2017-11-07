# chap-manager

Provide a Shell interface to manage CHAP authentication entry within `/etc/ppp/chap-secrets`.

## Installation

```
git clone https://github.com/alexzhangs/chap-manager
sudo sh chap-manager.sh/install.sh
```

## Usage

chap-manager.sh needs to be run under root.

```
Manager entries of /etc/chap-secrets
chap-manager.sh
	-a ACTION
	-u USERNAME/CLIENT
	[-p PASSWORD]
	[-s SERVER]
	[-i CLIENT_IP]
	[-h]
OPTIONS
	-a ACTION

	Action could be one of ADD, DEL and GET.

	-u USERNAME/CLIENT

	Username or client hostname.

	[-p PASSWORD]

	Password or secret for the username or the hostname.
	This option is mandatory with action ADD, and ignored
	with action DEL and GET.

	[-s SERVER]

	Server hostname, default is '*', meaning any server, with
	action ADD, and no default value with other actions.

	[-i CLIENT_IP]

	Client IP, default is '*', meaning any IP, with action ADD,
	and ignored with action DEL and GET.

	[-h]

	This help.

EXAMPLE
	Add a new chap-secrets entry: 'steve * password *':

	chap-manager.sh -a ADD -u steve -p password

	Delete all entries of steve:

	chap-manager.sh -a DEL -u steve

	Get all entries of steve:

chap-manager.sh -a GET -u steve
```
