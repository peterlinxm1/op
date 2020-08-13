include $(TOPDIR)/rules.mk

PKG_NAME:=install-program
PKG_VERSION:=1.2
PKG_RELEASE:=20200806

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Install to emmc script for phicomm n1
	DEPENDS:=+block-mount +blkid +parted +dosfstools +e2fsprogs +lsblk +pv +resize2fs +tune2fs +losetup +uuidgen
endef

define Package/$(PKG_NAME)/description
	Install to emmc script for phicomm n1, which will help you to copy openwrt system to emmc.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_BIN) ./files/n1-install $(1)/usr/bin/n1-install
	$(INSTALL_BIN) ./files/n1-update $(1)/usr/bin/n1-update
	$(INSTALL_CONF) ./files/fstab $(1)/etc/config/fstab
	$(INSTALL_CONF) ./files/fstab $(1)/etc/config/fstab.bak
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
