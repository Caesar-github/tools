#!/bin/bash

set -x
set -e

# ====
# Prep work
# ====

#git remote add -v linuxrockchip git://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git
#git remote add linuxdma git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/slave-dma.git
#git remote add linuxspi git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git
#git remote add linuxphy git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
#git remote add linuxcrypto git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
#git remote add linuxclk git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
#git remote add linuxdrm git://people.freedesktop.org/~airlied/linux
#git remote add linuxthermal git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
#git remote add linuxsound git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
#git remote add linuxpinctrl git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
#git remote add linuxiommu git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git

git fetch linuxrockchip
git fetch linuxdma
git fetch linuxspi
git fetch linuxphy
git fetch linuxcrypto
git fetch linuxclk
git fetch linuxdrm
git fetch linuxthermal
git fetch linuxsound
git fetch linuxpinctrl
git fetch linuxiommu



# ====
# Linux Rockchip picks for 4.5
# ...all are already in mineline
# ====

repo start lr-picks/v4.5-clk/clkids
git log --oneline v4.4..linuxrockchip/v4.5-clk/clkids | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


repo start lr-picks/v4.5-armsoc/dts32
git merge --no-ff --no-edit lr-picks/v4.5-clk/clkids
git log --first-parent --no-merges --oneline v4.4..linuxrockchip/v4.5-armsoc/dts32 | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


repo start lr-picks/v4.5-armsoc/dts64
git log --oneline v4.4..linuxrockchip/v4.5-armsoc/dts64 | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


# Note: skip last one, which never actually landed upstream (!!!)
repo start lr-picks/v4.5-armsoc/soc
git log --no-merges --oneline v4.4..linuxrockchip/v4.5-armsoc/soc~ | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


repo start lr-picks/v4.5-clk/next
git merge --no-ff --no-edit lr-picks/v4.5-clk/clkids
git log --first-parent --no-merges --oneline v4.4..linuxrockchip/v4.5-clk/next | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


# Hard because upstream branch isn't super clean; just do manual CLs
repo start lr-picks/v4.5-clk/fixes
git merge --no-ff --no-edit lr-picks/v4.5-clk/next

up 8ca1ca8f6039 # clk: rockchip: handle mux dependency of fractional dividers
up 667464208989 # clk: rockchip: include downstream muxes into fractional dividers
up 84a8c541664b # clk: rockchip: Allow the RK3288 SPDIF clocks to change their parent
up 2eb8c7104c64 # clk: add flag for clocks that need to be enabled on rate changes
up b0158bb27c7b # clk: rockchip: rk3036: include downstream muxes into fractional dividers

up 5b73840375e3 # clk: rockchip: fix section mismatches with new child-clocks

up 99222c9e4de7 # clk: rockchip: rk3036: fix the FLAGs for clock mux
up b29de2de5049 # clk: rockchip: rk3036: fix uarts clock error
up c40519350e1d # clk: rockchip: rk3036: fix the div offset for emac clock
up 3d667920bc8f # clk: rockchip: rk3036: rename emac ext source clock
up 8931f8e02979 # clk: rockchip: rk3368: fix some clock gates


# ====
# Linux Rockchip picks for 4.6
# ====

BASE="v4.5-rc1"

repo start lr-picks/v4.6-shared/pdids
git log --oneline ${BASE}..linuxrockchip/v4.6-shared/pdids | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-shared/pdids"|' | bash -e

repo start lr-picks/v4.6-shared/clkids
git merge --no-ff --no-edit lr-picks/v4.5-clk/clkids
git log --oneline ${BASE}..linuxrockchip/v4.6-shared/clkids | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-shared/clkids"|' | bash -e

repo start lr-picks/v4.6-armsoc/soc64
git log --oneline ${BASE}..linuxrockchip/v4.6-armsoc/soc64 | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-armsoc/soc64"|' | bash -e

repo start lr-picks/v4.6-armsoc/drivers
git merge --no-ff --no-edit lr-picks/v4.6-shared/pdids
git log --first-parent --no-merges --oneline ${BASE}..linuxrockchip/v4.6-armsoc/drivers | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-armsoc/drivers"|' | bash -e

repo start lr-picks/v4.6-armsoc/dts64
git merge --no-ff --no-edit lr-picks/v4.5-armsoc/dts64
git log --oneline ${BASE}..linuxrockchip/v4.6-armsoc/dts64 | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-armsoc/dts64"|' | bash -e

repo start lr-picks/v4.6-armsoc/dts32
git merge --no-ff --no-edit lr-picks/v4.5-armsoc/dts32
git merge --no-ff --no-edit lr-picks/v4.6-shared/clkids
git log --first-parent --no-merges --oneline ${BASE}..linuxrockchip/v4.6-armsoc/dts32 | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-armsoc/dts32"|' | bash -e

repo start lr-picks/v4.6-clk/next
git merge --no-ff --no-edit lr-picks/v4.5-clk/fixes
git merge --no-ff --no-edit lr-picks/v4.6-shared/clkids
git log --first-parent --no-merges --oneline ${BASE}..linuxrockchip/v4.6-clk/next | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org mmind/linux-rockchip v4.6-clk/next"|' | bash -e
# Throw an extra one in there
up 50359819794b "git.kernel.org clk/linux.git clk-next" # clk-divider: make sure read-only dividers do not write to their register


# ====
# Rockchip pinctrl
# ====
repo start pinctrl-picks

# First get up to mainline
# NOTE: takes commit 58383c78425e ("gpio: change member .dev to .parent").  OK?
# ...can skip it, too...
# ...have to get a few other picks in here too to get needed APIs.
git log --no-merges --oneline v4.4..5ed41cc4baaf~ -- \
  drivers/pinctrl/pinctrl-rockchip.c \
  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up 5ed41cc4baaf # gpiolib: do not allow to insert an empty gpiochip

git log --no-merges --oneline 5ed41cc4baaf..c88402c2e63d~ -- \
  drivers/pinctrl/pinctrl-rockchip.c \
  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up c88402c2e63d # gpiolib: make comment consistent with code

git log --no-merges --oneline c88402c2e63d..b08ea35a3296~ -- \
  drivers/pinctrl/pinctrl-rockchip.c \
  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up b08ea35a3296 # gpio: add a data pointer to gpio_chip

git log --no-merges --oneline b08ea35a3296..linux/master -- \
  drivers/pinctrl/pinctrl-rockchip.c \
  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


# Now get latest
git log --oneline linux/master..linuxpinctrl/for-next -- \
  drivers/pinctrl/pinctrl-rockchip.c \
  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org linusw/linux-pinctrl.git for-next"|' | bash -e


# ====
# Rockchip PHY stuff
# ====

repo start phy-picks

# Already in mainline
git log --oneline v4.4..tags/phy-for-4.5 -- drivers/phy/phy-rockchip-usb.c | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

BASE="v4.5-rc1"
git log --oneline ${BASE}..tags/phy-for-4.6 -- \
    drivers/phy/phy-rockchip-usb.c \
    drivers/phy/phy-rockchip-dp.c \
    drivers/phy/phy-rockchip-emmc.c \
    Documentation/devicetree/bindings/phy/{rockchip-emmc-phy.txt,rockchip-dp-phy.txt} \
    | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org kishon/linux-phy.git tags/phy-for-4.6"|' | bash -e


# ====
# Rockchip crytpo stuff
# ====

repo start crypto-picks

# Already in mainline
git log --oneline v4.4..linux/master -- \
  drivers/crypto/rockchip/ \
  Documentation/devicetree/bindings/crypto/rockchip-crypto.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

BASE="v4.5-rc1"
git log --oneline ${BASE}..linuxcrypto/master -- drivers/crypto/rockchip/  | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org herbert/cryptodev-2.6.git master"|' | bash -e


# ====
# DMA stuff
# ====

repo start dma-picks

# These two avoid a merge conflict below w/ 6d5bbed30f89 dmaengine: core: expose max burst capability to clients
up 13bb26ae8850 # dmaengine: virt-dma: don't always free descriptor upon completion
up 9eeacd3a2f17 # dmaengine: enable DMA_CTRL_REUSE

up 848e9776fee4 "git.kernel.org vkoul/slave-dma.git next" # dmaengine: pl330: support burst mode for dev-to-mem and mem-to-dev transmit
up 2318a3dd8880 "git.kernel.org vkoul/slave-dma.git next" # dt/bindings: arm-pl330: add description of arm, pl330-broken-no-flushp
up 271e1b86e691 "git.kernel.org vkoul/slave-dma.git next" # dmaengine: pl330: add quirk for broken no flushp
up 6d5bbed30f89 "git.kernel.org vkoul/slave-dma.git next" # dmaengine: core: expose max burst capability to clients
up 86a8ce7d4103 "git.kernel.org vkoul/slave-dma.git next" # dmaengine: pl330: add max burst for dmaengine
up 0a18f9b268dd "git.kernel.org vkoul/slave-dma.git next" # dmaengine: pl330: fix to support the burst mode

# ====
# SPI stuff
# ====

repo start spi-picks

git merge --no-ff --no-edit dma-picks

git log --oneline v4.4..linuxdma/next -- drivers/spi/spi-rockchip.c | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org vkoul/slave-dma.git next"|' | bash -e
git log --oneline v4.4..linuxspi/fix/rockchip -- drivers/spi/spi-rockchip.c | tac | \
    sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org broonie/spi.git fix/rockchip"|' | bash -e
git log --oneline v4.4..linuxspi/topic/rockchip -- drivers/spi/spi-rockchip.c | tac | \
   sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org broonie/spi.git topic/rockchip"|' | bash -e


# ====
# sound/soc stuff
# ====

repo start soundsoc-picks

git merge --no-ff --no-edit dma-picks

# First get up to mainline
git log --no-merges --oneline v4.4..linux/master -- \
  sound/soc/rockchip/ \
  Documentation/devicetree/bindings/sound/rockchip-i2s.txt \
  sound/soc/codecs/inno_rk3036.c \
  sound/soc/codecs/rt5616.c \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

# Not each to with just filtering with files; not in mainline yet.
up 7315917f7ccd "git.kernel.org broonie/sound.git for-next" # ASoC: rk3036: fix missing dependency on REGMAP_MMIO

# Now get latest
git log --no-merges --oneline linux/master..linuxsound/for-next -- \
  sound/soc/rockchip/ \
  Documentation/devicetree/bindings/sound/rockchip-i2s.txt \
  sound/soc/codecs/inno_rk3036.c \
  sound/soc/codecs/rt5616.c \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org broonie/sound.git for-next"|' | bash -e



# ====
# DRM
# ====

repo start drm-picks

# Avoid merge conflicts
up 10028c5ab107 # drm: Create a driver hook for allocating GEM object structs.
up c826a6e10644 # drm/vc4: Add a BO cache.

# First get up to mainline;


# Needed for the next patch to merge cleanly
git log --no-merges --oneline v4.4..dae91e4d1c7a~ -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up dae91e4d1c7a # drm/bridge/dw_hdmi: Constify function pointer structs

# HDMI unhappy if atomic changes merged but not this one:
git log --no-merges --oneline dae91e4d1c7a..2c5b2cccdbde~ -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up 2c5b2cccdbde # drm: bridge/dw_hdmi: add atomic API support

# Rockchip says take commit c240906d3665 ("drm/atomic-helper: Export framebuffer_changed()")
git log --no-merges --oneline 2c5b2cccdbde..c240906d3665~ -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e
up c240906d3665 # drm/atomic-helper: Export framebuffer_changed()

git log --no-merges --oneline c240906d3665..linux/master -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

# Now pick up recent stuff
git log --no-merges --oneline linux/master..4cacf91fcb1d7118e93caf9cb6651d7f7b56e58d~ -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git://people.freedesktop.org/~airlied/linux drm-next"|' | bash -e
up 4cacf91fcb1d "git://people.freedesktop.org/~airlied/linux drm-next" # drm: add drm_of_encoder_active_endpoint helpers
git log --no-merges --oneline 4cacf91fcb1d7118e93caf9cb6651d7f7b56e58d..linuxdrm/drm-next -- \
  drivers/gpu/drm/rockchip/ \
  Documentation/devicetree/bindings/display/rockchip/ \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git://people.freedesktop.org/~airlied/linux drm-next"|' | bash -e


# ====
# DRM fromlist
# ====

repo start drm-fromlist
git merge --no-ff --no-edit drm-picks

# [v2,1/5] drm/rockchip: dw_hdmi: Call drm_encoder_cleanup() in error path
fromupstream.py pw://8523301 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"
# [v2,3/5] drm/rockchip: vop: Fix vop crtc cleanup
fromupstream.py pw://8523381 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"


# Yakir needs to spin, and they don't apply cleanly...
#
# # [v2,1/3] drm/rockchip: vop: Add support for interrupt registers using write-masks
# fromupstream.py pw://7952591 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"
# # [v2,2/3] drm/rockchip: vop: add rk3229 vop support
# fromupstream.py pw://7952621 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"
# # [v2,3/3] dt-bindings: add document for rk3229-vop
# fromupstream.py pw://7952651 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"


# ====
# Thermal
# ====

repo start thermal-picks

# First get up to mainline
git log --oneline v4.4..linux/master -- \
  drivers/thermal/rockchip_thermal.c \
  Documentation/devicetree/bindings/thermal/rockchip-thermal.txt \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

# Now get new stuff
git log --oneline linux/master..linuxthermal/fixes -- \
  drivers/thermal/rockchip_thermal.c \
  Documentation/devicetree/bindings/thermal/rockchip-thermal.txt \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org evalenti/linux-soc-thermal.git fixes"|' | bash -e


# ====
# IOMMU
# ====

repo start iommu-picks

# Just one pick right now...
git log --oneline linux/master..linuxiommu/next -- \
  drivers/iommu/rockchip-iommu.c \
  | tac | \
  sed 's|^\([a-f0-9]*\).*|up \1 "git.kernel.org joro/iommu.git next"|' | bash -e


# ====
# Ethernet
# ====

repo start ethernet-picks

# Just from mainline for now; take all of arc-emac
git log --oneline v4.4..linux/master -- \
  drivers/net/ethernet/arc/ \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e


# ====
# Timer
# ====

repo start timer-picks

# From mainline
git log --oneline v4.4..linux/master -- \
  drivers/clocksource/rockchip_timer.c \
  | tac | sed 's/^\([a-f0-9]*\).*/up \1/' | bash -e

# ====
# mailbox fromlist
# ====

repo start mainbox-fromlist

# [v1,1/3] dt-bindings: rockchip-mailbox: Add mailbox controller document on Rockchip SoCs
fromupstream.py pw://7494251 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"
# [v1,2/3] mailbox: rockchip: Add Rockchip mailbox driver
fromupstream.py pw://7494261 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"
# [v1,3/3] ARM64: dts: rk3368: Add mailbox device nodes
fromupstream.py pw://7494281 --bug=chrome-os-partner:50756 --test="Build and boot on rk3288"


# ====
# MISC
# ====

repo start misc-picks

# Pretty up the "rockchip" diff vs. linux-next because this patch doesn't hurt
up 22697acdd72d


# ====
# Bring it all together
# ====

repo start merge-160307

git merge --no-edit v4.4.4

git merge --no-ff --no-edit \
  lr-picks/v4.5-clk/clkids \
  lr-picks/v4.5-armsoc/dts32 \
  lr-picks/v4.5-armsoc/dts64 \
  lr-picks/v4.5-armsoc/soc \
  lr-picks/v4.5-clk/next \
  lr-picks/v4.5-clk/fixes \
  \
  lr-picks/v4.6-shared/pdids \
  lr-picks/v4.6-shared/clkids \
  lr-picks/v4.6-armsoc/soc64 \
  lr-picks/v4.6-armsoc/drivers \
  lr-picks/v4.6-armsoc/dts64 \
  lr-picks/v4.6-armsoc/dts32 \
  lr-picks/v4.6-clk/next \
  \
  pinctrl-picks \
  phy-picks \
  crypto-picks \
  dma-picks \
  spi-picks \
  soundsoc-picks \
  drm-picks \
  drm-fromlist \
  thermal-picks \
  iommu-picks \
  ethernet-picks \
  timer-picks \
  mailbox-fromlist \
  misc-picks

# ===

# Check:

# /b/tip/scripts/diffs.py HEAD caesar_github_rockchip/stable4.4
# git diff --stat ..linuxnext/master | grep rockchip
