#!/bin/tclsh
#
# Simple tclsh script for triggering an alarm message with DPInfo
# <msg> to alarm variable <var> with eventually creating it.
#
# triggerAlarm.ctl v2.1
# Copyright (c) 2017-2019 Jens Maus <mail@jens-maus.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Usage:
# triggerAlarm.tcl <msg> <var>
#

load tclrpc.so
load tclrega.so

if { $argc < 1 } {
  puts "ERROR: script requires one or more arguments"
  exit 1
}

set msg [lindex $argv 0]
set var [lindex $argv 1]

# if no additional variable name was given
# we search for a SV with name "Alarmzone 1" or
# "${sysVarAlarmZone1}"
if { $var == "" } {
  set script "
    object alObj = null;
    string sSysVarId;
    foreach(sSysVarId, dom.GetObject(ID_SYSTEM_VARIABLES).EnumUsedIDs()) {
      object oSysVar = dom.GetObject(sSysVarId);
      if((alObj == null) &&
        ((oSysVar.Name() == \"\${sysVarAlarmZone1}\") || (oSysVar.Name() == \"Alarmzone 1\"))) {
        alObj=oSysVar;
      }
    }
  "
  set var "\${sysVarAlarmZone1}"
} else {
  set script "
    object alObj = null;
    string sSysVarId;
    foreach(sSysVarId, dom.GetObject(ID_SYSTEM_VARIABLES).EnumUsedIDs()) {
      object oSysVar = dom.GetObject(sSysVarId);
      if((alObj == null) &&
         (oSysVar.Name() == \"$var\")) {
        alObj=oSysVar;
      }
    }
  "
}

# try to get an alarm variable with name $var
# create it or change the existing one to be an alarmdp variable
append script "
  ! delete object if not of type OT_ALARMDP
  if( (alObj != null) && (alObj.IsTypeOf(OT_ALARMDP) == false) ) {
    dom.DeleteObject(alObj.ID());
    alObj = null;
  }

  ! (re)create the alarm system variable
  if(alObj == null) {
    alObj=dom.CreateObject(OT_ALARMDP);
    if(alObj != null) {
      alObj.Name(\"$var\");
      alObj.ValueType(ivtBinary);
      alObj.ValueSubType(istAlarm);
      alObj.ValueName0(\"\${sysVarAlarmZone1NotTriggered}\");
      alObj.ValueName1(\"\${sysVarAlarmZone1Triggered}\");
      alObj.ValueUnit(\"\");
      alObj.AlType(atSystem);
      alObj.AlArm(true);
      alObj.AlSetBinaryCondition();
      alObj.State(false);
      dom.GetObject(ID_SYSTEM_VARIABLES).Add(alObj.ID());
      dom.RTUpdate(1);
    }
  }

  ! raise alarm message
  if(alObj != null) {
    alObj.ValueType(ivtBinary);
    alObj.ValueSubType(istAlarm);
    alObj.DPInfo(\"$msg\");
    alObj.State(true);
  }
"

if { ![catch {array set result [rega_script $script]}] } then {
  if { $result(alObj) != "null" } {
    set res 0
  } else {
    set res 1
  }
} else {
  set res 1
}

exit $res
