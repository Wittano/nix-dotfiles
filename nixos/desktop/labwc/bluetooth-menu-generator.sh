#!/usr/bin/env bash

echo "<openbox_pipe_menu>"

IFS=$'\n'
for device in $(bluetoothctl devices | cut -f 2- -d ' '); do
    device_name=$(echo "$device" | cut -f 2- -d ' ')
    mac=$(echo "$device" | cut -f 1 -d ' ')

    echo "<menu id=\"$device_name\" label=\"$device_name\">
        <item label=\"Connect\">
        <action name=\"Execute\">
            <command>bluetoothctl connect $mac</command>
        </action>
        </item>
        <item label=\"Disconnect\">
        <action name=\"Execute\">
            <command>bluetoothctl disconnect $mac</command>
        </action>
        </item>

    </menu>"
done

echo "</openbox_pipe_menu>"
