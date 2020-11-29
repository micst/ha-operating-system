##
# CCU.setUserAckInstallWizard
# Legt die Datei/etc/config/userprofiles/userAckInstallWizard_USERNAME an
#
# Parameter:
#  userName
#
# R�ckgabewert: immer true
##

set userName [string map {
                " " ";"
                "/" ""
                "�" "AE"
                "�" "UE"
                "�" "OE"
                "�" "ae"
                "�" "ue"
                "�" "oe"
                "�" "ss"
             } $args(userName)]

regsub -all {[^\u0020-\u007e]+} $userName "" userName

catch {exec touch /etc/config/userprofiles/userAckInstallWizard_$userName}

jsonrpc_response true
