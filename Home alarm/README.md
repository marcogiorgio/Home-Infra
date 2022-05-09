# Overview

In order to realize a simple but effective anti theft alarm for my house, I decided to build a system based on Home Assistant, a powerful tool for home automation.
I installed the software on a Raspberry Pi4 and bought some movement/magnetic sensors/a siren compatible with ZIGBEE protocol, and ConbeeII, an USB adapter to make Home Assistant use ZIGBEE.

I made a custom integration with BlueIris, the software which handles the security cameras, in order to change their routines when the alarm state changes.
I coded these kind of states:
- Home:
  - Day: This is the state during daylight and when I am home. The alarm is off and the camera does not record.
  - Night: This is the state during the night when I am home. Only the magnetic sensors installed on windows and doors trigger the alarm. Cameras' record is on.

- Outside:
This is the state when I am not home. The alarm is on and all the sensors trigger it. Cameras' record is on.

Whenever an alarm is triggered these things happen:
- A Telegram notification is sent on my phone with a particular message that triggers a custom sound
- A mail is sent with the picture sent by the cameras at the moment the alarm was triggered
- The siren starts

The whole system is segregated into its own VLAN with no Internet access except for the ports needed to send the notifications.

![Alt text](alarm-main-panel.png?raw=true "Alarm main page")

Here's the most reliable, unintentional test that I run: the girlfriend test. She forgot to deactivate the alarm before entering the house.

![Alt text](alarm-proof-test.gif?raw=true "Alarm test")