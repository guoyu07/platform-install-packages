#!/bin/bash - 
#===============================================================================
#          FILE: kaltura-base-config.sh
#         USAGE: ./kaltura-base-config.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Jess Portnoy, <jess.portnoy@kaltura.com>
#  ORGANIZATION: Kaltura, inc.
#       CREATED: 01/06/14 11:27:00 EST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
verify_user_input()
{
        ANSFILE=$1
        for VAL in TIME_ZONE KALTURA_FULL_VIRTUAL_HOST_NAME DB1_HOST DB1_PORT DB1_NAME DB1_USER DB1_PASS ; do
                if [ -z "${!VAL}" ];then
                        echo "I need $VAL in $ANSFILE."
                        exit 1
                fi
        done
}

KALT_CONF_DIR='/opt/kaltura/app/configurations/'
if [ -n "$1" -a -r "$1" ];then
        ANSFILE=$1
        verify_user_input $ANSFILE
else
        echo "Welcome to Kaltura Server `rpm -qa kaltura-base --queryformat %{version}` post install setup.
In order to finalize the system configuration, please input the following:

CDN host [`hostname`]:
"
        read -e CDN_HOST
        if [ -z "$CDN_HOST" ];then
                CDN_HOST=`hostname`
        fi

        echo "Apache virtual host: "
        read -e KALTURA_VIRTUAL_HOST_NAME
        if [ -z "$KALTURA_VIRTUAL_HOST_NAME" ];then
                KALTURA_VIRTUAL_HOST_NAME=`hostname`
        fi
        echo "Which port will this Vhost listen on [443]? "
        read -e KALTURA_VIRTUAL_HOST_PORT
        if [ -z "$KALTURA_VIRTUAL_HOST_PORT" ];then
                KALTURA_VIRTUAL_HOST_PORT=443
        fi
        KALTURA_FULL_VIRTUAL_HOST_NAME="$KALTURA_VIRTUAL_HOST_NAME:$KALTURA_VIRTUAL_HOST_PORT"
        while [ -z "$DB1_HOST" ];do
                echo "DB hostname: "
                read -e DB1_HOST
        done

        echo "DB name [kaltura]: "
        read -e DB1_NAME
        if [ -z "$DB1_NAME" ];then
                DB1_NAME=kaltura
        fi

        while [ -z "$DB_SUPER_USER" ];do
                echo "DB super user [used to create the kaltura user and scheme]: "
                read -e DB_SUPER_USER
        done
        while [ -z "$DB_SUPER_PASS" ];do
                echo "DB super user passwd: "
                STTY_ORIG=`stty -g`
                stty -echo
                read -e DB_SUPER_PASS
                stty $STTY_ORIG

        done
        while [ -z "$DB1_USER" ];do
                echo "Kaltura DB user: "
                read -e DB1_USER
        done
        while [ -z "$DB1_PASS" ];do
                echo "Kaltura DB passwd: "
                STTY_ORIG=`stty -g`
                stty -echo
                read -e DB1_PASS
                stty $STTY_ORIG

        done
        while [ -z "$TIME_ZONE" ];do
                echo "Your time zone [see http://php.net/date.timezone]: "
                read -e TIME_ZONE
        done
fi


# Now we will sed.
CONF_FILES=`find $KALT_CONF_DIR -name "*.ini" -type f`

for CONF_FILE in $CONF_FILES;do
	sed -i -e "s#@CDN_HOST@#$CDN_HOST#g" -e "s#@DB1_HOST@#$DB1_HOST#g" -e "s#@DB1_NAME@#$DB1_NAME#g" -e "s#@DB1_USER@#$DB1_PASS#g"
done
#@CDN_HOST@
#@DB1_HOST@
#@DB1_NAME@
#@DB1_PASS@
#@DB1_USER@
#@DB2_HOST@
#@DB2_NAME@
#@DB3_HOST@
#@INSTALLED_HOSNAME@
#@KALTURA_FULL_VIRTUAL_HOST_NAME@
#@KALTURA_VIRTUAL_HOST_NAME@
#@REPORT_ADMIN_EMAIL@
#@TIME_ZONE@

