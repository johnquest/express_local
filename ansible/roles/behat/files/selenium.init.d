#!/bin/bash
#
# Selenium
#
# chkconfig: 345 90 25
# description: Selenium service

# Source function library.
. /etc/init.d/functions

java_bin=/usr/bin/java

xvfb_bin=/usr/bin/xvfb-run

selenium_dir=/opt/selenium
selenium_jar_file="$selenium_dir/selenium-server-standalone-2.46.0.jar"
user=root
exec="$xvfb_bin $java_bin"
args=" -client -jar $selenium_jar_file"
lockfile="/var/lock/subsys/selenium"
pidfile="$selenium_dir/selenium.pid"
logfile="$selenium_dir/selenium.log"
prog="selenium"
display=":1"
port="4444"

RETVAL=0

start() {
  echo -n $"Starting $prog: "

  touch $pidfile
  chown $user $pidfile

  touch $logfile
  chown $user $logfile

  /bin/su - $user -c "DISPLAY=\"$display\" $exec $args >> $logfile 2>&1 & echo \$! > $pidfile"

  sleep 2

  pgrep -fl $prog
  RETVAL=$?
  [ $RETVAL -eq 0 ] && echo_success || echo_failure

  return $RETVAL
}

stop() {
  echo -n $"Stopping $prog: "
  killproc -p $pidfile $prog
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && rm -f $lockfile $pidfile
  return $RETVAL
}

restart() {
  stop
  sleep 2
  start
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status -p ${pidfile} ${prog}
    RETVAL=$?
    ;;
  restart)
    restart
    ;;
  *)
    echo $"Usage: $0 {start|stop|restart}"
    exit 1
esac
