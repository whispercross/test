#!/bin/bash

proc_name="Test"
pid="/var/log/test_pid.txt"
log_file="/var/log/monitoring.log"
https="https://test.com/monitoring/test/api"

if pgrep -x "$proc_name" > /dev/null; then
	if ! curl -s --fail --max-time 5 "$https" > /dev/null; then
		echo "$(date) Сервер $https недоступен" >> "$log_file"
	fi
	new_pid=$(pgrep -x "$proc_name" | head -n1)

	if [-f "$pid"]; then
		old_pid=$(cat "$pid")

		if ["$old_pid"!="$new_pid"]; then
			echo "$(date) Процесс был перезапущен. PID был $old_pid, стал $new_pid." | tee -a "$log_file"
		fi
	fi
	echo "$new_pid" > "$pid"
else
	echo "Процесс $proc_name недоступен"
	exit 0
fi
