#!/bin/bash

#!/usr/bin/bash
# Copy Files to Image
cp /ctx/packages.json /tmp/packages.json
cp /ctx/system_files/* /etc/yum.repos.d/

# Build the single package list requested for this image.
readarray -t INCLUDED_PACKAGES < <(jq -r "(.include // []) | sort | unique[]" /tmp/packages.json)

# Install Packages
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  dnf -y install "${INCLUDED_PACKAGES[@]}" --skip-unavailable
else
  echo "No packages to install."
fi

# Build the single exclusion list requested for this image.
readarray -t EXCLUDED_PACKAGES < <(jq -r "(.exclude // []) | sort | unique[]" /tmp/packages.json)

if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  readarray -t EXCLUDED_PACKAGES < <(rpm -qa --queryformat='%{NAME}\n' "${EXCLUDED_PACKAGES[@]}")
fi

# remove any excluded packages which are still present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  dnf -y remove "${EXCLUDED_PACKAGES[@]}"
else
  echo "No packages to remove."
fi

echo "::endgroup::"
