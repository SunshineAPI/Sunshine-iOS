ARCHS = armv7 arm64
TARGET = iphone:clang:latest:8.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.0
THEOS_PACKAGE_DIR_NAME = debs
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

APPLICATION_NAME = Overcast
Overcast_FILES = main.m $(wildcard Classes/**/*.m) $(wildcard Classes/*.m) $(wildcard Classes/*.mm)
Overcast_FRAMEWORKS = UIKit CoreGraphics Foundation SystemConfiguration Security MobileCoreServices
Overcast_PRIVATE_FRAMEWORKS = ChatKit
Overcast_LDFLAGS = -all_load -ObjC
Overcast_LDFLAGS += -Wl,-segalign,4000


include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall -9 Overcast"
include $(THEOS_MAKE_PATH)/aggregate.mk
