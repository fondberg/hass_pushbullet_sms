## Sending SMS through Pushbullet using their Android integration

This script doesn't require your Home-Assistant to be configured with [Pushbullet](https://www.pushbullet.com/#setup) but it is highly recommended because then you can send notifications too, see [Pushbullet component](https://www.home-assistant.io/components/notify.pushbullet/) for more information.

For more information see the [Pushbullet API documentation for SMS](https://docs.pushbullet.com/#send-sms) 

### Installation
To install download the [script](https://raw.githubusercontent.com/fondberg/hass_pushbullet_sms/master/pushbullet_sms.sh) to `<home-assistent>:/config/pushbullet_sms.sh` and make sure to make it executable (`chmod +x pushbullet_sms.sh`).

#### Oneliner install on the home-assistent:
```
$ cd /config && curl https://raw.githubusercontent.com/fondberg/hass_pushbullet_sms/master/pushbullet_sms.sh > pushbullet_sms.sh && chmod +x pushbullet_sms.sh
```

### Get device iden and other info from pushbullet
```
$ curl --header 'Access-Token: <your_access_token_here>' https://api.pushbullet.com/v2/devices | jq .
```

### Configuration
1. Edit these variables in the script for your Pushbullet integration:
```
# Same as in the normal Hass.io integration
AUTH_TOKEN=''
# The Android device which has SMS integration on 
TARGET_DEVICE_IDEN=''
# This seems it can be whatever but it is required
SOURCE_USER_IDEN='niklas'
# The numbers you want to send SMS to
NUMBERS=( "+46987654321" "+46123456798" )

```

2. Add the script to your configuration
Add the script to `configuration.yaml`:
```
shell_command:
  pushbullet_sms: bash /config/pushbullet_sms.sh "{{message}}"
```

### Use in automation
Example automation
```
alias: Send pushbullet sms
trigger:
  platform: sun
  event: sunset
action:
  - service: shell_command.pushbullet_sms
    data:
      message: "Sun has set"

```
------
MIT License - Copyright (c) 2019 Niklas Fondberg <niklas.fondberg@gmail.com>

