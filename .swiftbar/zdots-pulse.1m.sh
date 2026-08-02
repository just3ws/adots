#!/bin/bash
# <swiftbar.title>zdots pulse</swiftbar.title>
# <swiftbar.version>v1</swiftbar.version>
# <swiftbar.author>zdots</swiftbar.author>
# <swiftbar.desc>Platform standing state: detectors, suite, capabilities, usage.</swiftbar.desc>
# Thin shim (Z-288): logic lives tracked/tested/man-paged in zdots bin/.
exec "${ZDOTDIR:-$HOME/.config/zsh}/bin/zdots-swiftbar"
