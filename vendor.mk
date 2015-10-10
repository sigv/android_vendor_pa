# Copyright 2013 ParanoidAndroid Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# It's-a me, Paranoid Android!
export VENDOR := pa

# Inform about the versioning we got going on.
# The scheme's a 'P' (for Paranoid) followed by a single release family letter and an integral version tag.
ROM_VERSION_UPSTREAM := M
ROM_VERSION_WEEKLY_BUILD := 0
export ROM_VERSION := P$(ROM_VERSION_UPSTREAM)$(shell date -u +%y%W)$(ROM_VERSION_WEEKLY_BUILD)
PRODUCT_PROPERTY_OVERRIDES += ro.modversion=$(ROM_VERSION)
PRODUCT_PROPERTY_OVERRIDES += ro.pa.version=$(ROM_VERSION)

# Tell the builders about what overlays we got ready for them.
PRODUCT_PACKAGE_OVERLAYS += vendor/pa/overlay

# Include the custom boot animation.
ifneq ($(filter pa_mako pa_grouper pa_tilapia,$(TARGET_PRODUCT)),)
    PRODUCT_COPY_FILES += vendor/pa/bootanim/1280x720.zip:system/media/bootanimation.zip
else ifneq ($(filter pa_hammerhead pa_shamu,$(TARGET_PRODUCT)),)
    PRODUCT_COPY_FILES += vendor/pa/bootanim/1920x1080.zip:system/media/bootanimation.zip
else ifneq ($(filter pa_%,$(TARGET_PRODUCT)),)
    # Just default the hell out for everything else that is not specified.
    PRODUCT_COPY_FILES += vendor/pa/bootanim/1920x1080.zip:system/media/bootanimation.zip
endif

# Override generic Google properties.
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.com.google.clientidbase=android-google \
    ro.setupwizard.enterprise_mode=1 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html

# Override old AOSP default sounds using the new Google ones.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Osmium.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.ringtone=Titania.ogg

# Enable SIP+VoIP.
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable swipe typing with the proprietary latinime library.
PRODUCT_COPY_FILES += vendor/pa/libjni_latinime.so:system/lib/libjni_latinime.so

# Include our custom OTA package unless instructed otherwise.
ifneq ($(OTA_BUILD),false)
    PRODUCT_PACKAGES += ParanoidOTA
endif

# Include APN configuration.
PRODUCT_COPY_FILES += vendor/pa/apns-conf.xml:system/etc/apns-conf.xml

# Include backup script support for Google apps and more.
PRODUCT_COPY_FILES += \
    vendor/pa/backup/backuptool.functions:install/bin/backuptool.functions \
    vendor/pa/backup/backuptool.sh:install/bin/backuptool.sh \
    vendor/pa/backup/50-backuptool.sh:system/addon.d/50-backuptool.sh
