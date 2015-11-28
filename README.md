# Sunshine iOS App

The Sunshine iOS App currently only runs on jailbroken devices and is built with theos due to the lack of access to a proper build platform and licensing.

The app can easily be recompiled and distributed with XCode in the future.

## Installing

Install Sunshine from Jake0oo0's Cydia repository: https://cydia.jakes.site

## Building

* Appster is built using [theos](https://github.com/DHowett/theos). Follow the [setup](http://iphonedevwiki.net/index.php/Theos/Setup) guide to install it.
* Run ```make clean package install THEOS_DEVICE_IP=xxx THEOS_DEVICE_PORT=xxx``` to build and install Appster on your device


## License

Sunshine iOS is licensed under the General Public License v3. Distribution of the Sunshine iOS Client requires that all changes are open-sourced prior to distribution of the binary.