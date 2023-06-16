#!/bin/bash
set -euo pipefail
##################################################
prepare_display_screen() {
    XVFB_SCREEN_WIDTH=${SCREEN_WIDTH-1920}
    XVFB_SCREEN_HEIGHT=${SCREEN_HEIGHT-1080}
    Xvfb :1 -screen 0 "${XVFB_SCREEN_WIDTH}x${XVFB_SCREEN_HEIGHT}x24" >/dev/null 2>&1 &
    export DISPLAY=:1.0
    fluxbox >/dev/null 2>&1 &
}

run_tests() {
    prepare_display_screen
    if [ ! -d "$PWD/results" ]; then
        mkdir $PWD/results
    fi
    DEBUG=testcafe:*,hammerhead:* yarn feature 2> $PWD/results/testcafe_error.log || {
        echo "End of test running"
        return 1
    }
    echo "End of test running"
}

run_tests || {
    echo "job fails"
    exit 1
}
