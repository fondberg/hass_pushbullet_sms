#!/bin/bash

# Script to send SMS using Pushbullet's Android integration
# 
# MIT License
# 
# Copyright (c) 2019 Niklas Fondberg <niklas.fondberg@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


MSG=$1
CURL="curl --write-out '%{http_code}' --silent"
AUTH_TOKEN=''
TARGET_DEVICE_IDEN=''
SOURCE_USER_IDEN='niklas'
LOG=/config/shell_scripts/pushbullet_sms.log
NUMBERS=( "+46987654321" "+46123456798" )
JSON='{"type": "push", "push": {"type": "messaging_extension_reply","package_name": "com.pushbullet.android","source_user_iden": "_SOURCE_USER_IDEN_","target_device_iden": "_TARGET_DEVICE_IDEN_", "conversation_iden": "_NUMBER_","message": "_MESSAGE_" } }'
JSON=$(echo "${JSON/_TARGET_DEVICE_IDEN_/$TARGET_DEVICE_IDEN}")
JSON=$(echo "${JSON/_SOURCE_USER_IDEN_/SOURCE_USER_IDEN}")

# The pushbullet api doesn't allow for multiple numbers so send one by one
sendSms () {
    NUMBER="$1"
    echo "Skickar till $1" >> $LOG
    JSON_REPLACED=$(echo "${JSON/_MESSAGE_/$MSG}")
    JSON_REPLACED=$(echo "${JSON_REPLACED/_NUMBER_/$NUMBER}")
    eval $CURL -X POST https://api.pushbullet.com/v2/ephemerals --header \'Access-Token: $AUTH_TOKEN\' --header \'Content-Type: application/json\' --data-binary \'$JSON_REPLACED\' >> $LOG 2>&1
}

echo "Sending SMS using Pushbullet. Message is \"$MSG\"" >> $LOG
for i in "${NUMBERS[@]}"
do
    sendSms "$i"
done

