apt update -y

apt upgrade -y

apt dist-upgrade -y

apt install nano htop mc nload -y

clear

read -p "Creat User:" MASTERUSER
echo User is: $MASTERUSER

read -p "Set User Password:" USERPW
echo Password is: $USERPW

read -p "Change Root Password:" ROOTPW
echo Root Password is: $ROOTPW

read -p "Set SSH Key:" SSHKEY
echo SSH Key is: $SSHKEY

read -p "Set SSH Port:" SSHPORT
echo SSH Port is: $SSHPORT

passwd "root" <<EOF
$ROOTPW
$ROOTPW
EOF

adduser --gecos "" "$MASTERUSER" <<EOF
$USERPW
$USERPW
EOF

rm -R /home/$MASTERUSER/.ssh

cd /home/$MASTERUSER

mkdir /home/$MASTERUSER/.ssh

chmod 700 /home/$MASTERUSER/.ssh

echo $SSHKEY >/home/$MASTERUSER/.ssh/authorized_keys2

chmod 600 /home/$MASTERUSER/.ssh/authorized_keys2

cd

chown -R $MASTERUSER:$MASTERUSER /home/$MASTERUSER

sed -i "s/.*Port *.*/Port $SSHPORT/g" /etc/ssh/sshd_config

sed -i "s/.*PermitRootLogin *.*/PermitRootLogin no/g" /etc/ssh/sshd_config

sed -i "s/.*UsePAM *.*/#UsePAM yes/g" /etc/ssh/sshd_config

sed -i "s/.*PasswordAuthentication *.*/PasswordAuthentication no/g" /etc/ssh/sshd_config

echo '# Cronjob-Spam umleiten
:msg, contains, "pam_unix(cron:session):" -/var/log/cronauth.log
& ~' >/etc/rsyslog.d/30-cron.conf

echo -e "\e[1;32mFertig\e[0m"
