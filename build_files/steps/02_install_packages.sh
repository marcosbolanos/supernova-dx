#!/bin/bash

#!/usr/bin/bash
# Copy Files to Image
cp /ctx/packages.json /tmp/packages.json
cp /ctx/system_files/* /etc/yum.repos.d/

# build list of all packages requested for inclusion
readarray -t INCLUDED_PACKAGES < <(jq -r "[(.all.include | (select(.dx != null).dx)[]), \
                    (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (select(.dx != null).dx)[])] \
                    | sort | unique[]" /tmp/packages.json)

# Install Packages
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 ]]; then
  dnf -y install "${INCLUDED_PACKAGES[@]}" --skip-unavailable
else
  echo "No packages to install."
fi

# build list of all packages requested for exclusion
readarray -t EXCLUDED_PACKAGES < <(jq -r "[(.all.exclude | (select(.dx != null).dx)[]), \
                    (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (select(.dx != null).dx)[])] \
                    | sort | unique[]" /tmp/packages.json)

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
