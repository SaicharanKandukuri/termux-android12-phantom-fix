#!/bin/bash

cat <<-EOF >>~/.bashrc
cur_phantom_peak=\$(adb   shell device_config get activity_manager max_phantom_processes)

if [[ "\$cur_phantom_peak" == 'null' ]]; then
    echo "fixing phantom.."
    adb   \\
        shell \\
        device_config \\
        put activity_manager \\
        max_phantom_processes 214181594
    echo "process limit increased from \$cur_phantom_peak to 214181594"
fi

if [ "\$(adb   shell device_config get activity_manager max_phantom_processes)" == 'null' ]; then
    echo "Failed to increase phantom max_phantom_processes"
    echo "check returned null"
fi
EOF
