ifeq ($(strip $(GNUSTEP_MAKEFILES)),)
GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif

ifeq ($(strip $(GNUSTEP_MAKEFILES)),)
$(error GNUSTEP_MAKEFILES is not set. Source your GNUstep environment or install gnustep-make)
endif

include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = xib2coder

xib2coder_OBJC_FILES = \
	xib2coder/main.m \
	xib2coder/Generator/XIBClassGenerator.m \
	xib2coder/Generator/XIBObjCClassGenerator.m \
	xib2coder/Parser/NSString+Additions.m \
	xib2coder/Parser/XIBAbstractBuilder.m \
	xib2coder/Parser/XIBAbstractCodeGenerator.m \
	xib2coder/Parser/XIBCustomObject.m \
	xib2coder/Parser/XIBObjCAccessorBuilder.m \
	xib2coder/Parser/XIBObjCClassBuilder.m \
	xib2coder/Parser/XIBObjCCodeBuilder.m \
	xib2coder/Parser/XIBParser.m

ADDITIONAL_OBJCFLAGS += -Wall -Wextra

include $(GNUSTEP_MAKEFILES)/tool.make
