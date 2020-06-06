#
# Copyright (C) 2019 The Android-x86 Open Source Project
#
# Licensed under the GNU General Public License Version 2 or later.
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/gpl.html
#

LOCAL_PATH := $(dir $(call my-dir))

# Build version.h
include $(CLEAR_VARS)

LOCAL_MODULE := alsa_utils_headers
LOCAL_MODULE_CLASS := HEADER_LIBRARIES

intermediates := $(call local-generated-sources-dir)

GEN := $(intermediates)/version.h
$(GEN): $(LOCAL_PATH)configure.ac
	@mkdir -p $(@D); \
	sed -n "/^AC_INIT.* \([0-9.]*\))/s//\#define SND_UTIL_VERSION_STR \"\1\"/p" $< > $@

# Common flags
ALSA_UTILS_CFLAGS := \
	-Wno-absolute-value -Wno-enum-conversion \
	-Wno-parentheses -Wno-pointer-arith -Wno-sign-compare \
	-Wno-unused-parameter -Wno-unused-variable

ALSA_UTILS_C_INCLUDES := \
	$(dir $(GEN)) \
	$(LOCAL_PATH)include \
	$(LOCAL_PATH)android

NCURSES_INCLUDE := \
	$(LOCAL_PATH)/../libncurses/ncurses \
	$(LOCAL_PATH)/../libncurses/panel \
	$(LOCAL_PATH)/../libncurses/include \
	$(LOCAL_PATH)/../libncurses/form \
	$(LOCAL_PATH)/../libncurses/menu
	
# Build amixer command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS) -D_GNU_SOURCE
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES)

LOCAL_SRC_FILES := \
	amixer/amixer.c \
	alsamixer/volume_mapping.c

LOCAL_MODULE := alsa_amixer
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)

include $(BUILD_EXECUTABLE)

# Build aplay command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS)
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES)

LOCAL_SRC_FILES := \
	aplay/aplay.c

LOCAL_MODULE := alsa_aplay
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)

include $(BUILD_EXECUTABLE)

# Build alsactl command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS) \
	-DSYS_ASOUNDRC=\"/data/local/tmp/asound.state\" \
	-DSYS_LOCKFILE=\"/data/local/tmp/asound.state.lock\" \
	-DSYS_PIDFILE=\"/data/local/tmp/alsactl.pid\"
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES)

LOCAL_SRC_FILES := $(addprefix alsactl/,\
	alsactl.c \
	daemon.c \
	init_parse.c \
	lock.c \
	monitor.c \
	state.c \
	utils.c)

LOCAL_MODULE := alsa_ctl
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)

include $(BUILD_EXECUTABLE)

# Build alsaucm command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS)
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES)

LOCAL_SRC_FILES := \
        alsaucm/usecase.c \

LOCAL_MODULE := alsa_ucm
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)

include $(BUILD_EXECUTABLE)

# Build alsaloop command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS)
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES)

LOCAL_SRC_FILES := \
        alsaloop/alsaloop.c \
        alsaloop/control.c \
        alsaloop/pcmjob.c

LOCAL_MODULE := alsa_loop
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)

include $(BUILD_EXECUTABLE)

# Build alsamixer command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS) -D_GNU_SOURCE -lcurses -lmenu -lpanel -lncurses -lncursesw
LOCAL_C_INCLUDES:= $(ALSA_UTILS_C_INCLUDES) $(NCURSES_INCLUDE) 
LOCAL_SRC_FILES := \
		alsamixer/card_select.c \
		alsamixer/cli.c \
		alsamixer/colors.c \
		alsamixer/device_name.c \
		alsamixer/die.c \
		alsamixer/mainloop.c \
		alsamixer/mem.c \
		alsamixer/mixer_controls.c \
		alsamixer/mixer_display.c \
		alsamixer/mixer_widget.c \
		alsamixer/proc_files.c \
		alsamixer/textbox.c \
		alsamixer/utils.c \
		alsamixer/volume_mapping.c \
		alsamixer/widget.c

LOCAL_MODULE := alsa_alsamixer
LOCAL_SHARED_LIBRARIES := libasound libncurses libmenu libpanel libform
LOCAL_ADDITIONAL_DEPENDENCIES := $(GEN)
man_MANS = alsamixer.1
EXTRA_DIST = alsamixer.1

include $(BUILD_EXECUTABLE)
