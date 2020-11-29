##
# RecoveryMode.enter
# Startet die HomeMatic Zentrale im Recovery Modus
#
# Parameter:
#   paasword: [string] Passwort f�r den Recovery Modus
#
# R�ckgabewert: [bool]
#   true
##

set FLAG_FILE "/usr/local/.recoveryMode"

# Flag-Datei erzeugen
set fd [open $FLAG_FILE w]
puts $fd 1
close $fd

# Neustart
rega system.Save()
exec /sbin/reboot

jsonrpc_response true
