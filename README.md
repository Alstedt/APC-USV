# APC-USV
#APC USV Shutdown
#Benötigt die apcusd
apt update && apt install apcupsd -y
#Anpassen der Konfigurationsdatei
nano /etc/apcupsd/apcupsd.conf


#Anpassen des Shutdownvorgangs
nano /etc/apcupsd/apccontrol
#        /root/scripte/synology_shutdown.sh
#        sleep 10

#Anlegen der Ordnerstruktur für die Skripte und Anlegen des Skriptes

mkdir /root/scripe/ -r
nano /root/scripte/synology_shutdown.sh

#ssh key für den Zugang zu den anderen Servern ablegen
nano /root/.ssh/id_rsa_synology #Namen ggf. anpassen

#Auf dem Zielserver
#SSH KEY ablegen
nano /root/.ssh/authorized_keys
#Einschränkungne vor den Key schreiben
command="/usr/local/bin/allowed_pbs_commands.sh",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa ... #Hier dann der Key
#Wrapper Skript Anlegen, Beispieldatei für PBS Shutdown und Stoppen der Backupjobs
nano /usr/local/bin/allowed_pbs_commands.sh
