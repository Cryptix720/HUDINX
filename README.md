# hudinx
![alt text](https://github.com/Cryptix720/HUDINX/blob/master/honeyX.png)
Hudinx is a medium interaction SSH honeypot designed to log brute force attacks and, most importantly, the entire shell interaction performed by the attacker.







## Features

Some interesting features:
* Fake filesystem with the ability to add/remove files. A full fake filesystem resembling a Debian 5.0 installation is included
* Possibility of adding fake file contents so the attacker can 'cat' files such as /etc/passwd. Only minimal file contents are included
* Session logs stored in an  format for easy replay with original timings
* Just like Hudinx, hudinx saves files downloaded with wget for later inspection
* Trickery; ssh pretends to connect somewhere, exit doesn't really exit, etc

## Requirements

Software required:

* Operating systems: (tested on Debian, CentOS, FreeBSD and Windows 7, 8, 10)
* Python 2.7+
* Twisted 
* PyCrypto
* StrawberryPerl
* Zope Interface


See Wiki for some installation instructions.

## How to install it?


`./install.sh`


## Configure advanced security with rules ?

* Configure Windows and Linux security


## How to launch & kill it?

Edit hudinx.cfg to your liking and start the honeypot by running:

`./LAUNCH.sh` `./KILL.sh`

LAUNCH.sh is a simple shell script that runs hudinx in the background using twistd. Detailed startup options can be given by running hudnix manually. For example, to run hudinx in foreground:

`hudinx -y hudinx.tac -n`

By default Hudinx listens for ssh connections on port 3131. You can change this, but do not change it to 22 as it requires root privileges. Use port forwarding instead. (More info: [MakinghudinxReachable](https://github.com/desaster/hudinx/wiki/Making-hudinx-Reachable)).

Files of interest:

* dl/ - files downloaded with wget are stored here
* log/hudinx.log - log/debug output
* log/tty/ - session logs
* log/telnet/ - telnet logs
* utils/playlog.py - utility to replay session logs
* utils/createfs.py - used to create fs.pickle
* fs.pickle - fake filesystem
* honeyfs/ - file contents for the fake filesystem - feel free to copy a real system here

## Is it secure?

Maybe. See [FAQ](https://github.com/Cryptix720/hudinx/wiki/FAQ)


