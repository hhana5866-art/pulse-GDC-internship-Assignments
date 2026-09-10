#!/bin/sh
# ---------------------------------------------------------------------------
# Maven Wrapper
#
# Lets you build this project without installing Maven yourself. On the first
# run it downloads the Maven distribution named in
# .mvn/wrapper/maven-wrapper.properties into ~/.m2/wrapper/dists, then reuses
# it every time after that.
#
#   ./mvnw spring-boot:run
#   ./mvnw test
# ---------------------------------------------------------------------------
set -e

# Resolve the directory this script lives in, following symlinks.
script_path="$0"
while [ -h "$script_path" ]; do
  link_target="$(readlink "$script_path")"
  case "$link_target" in
    /*) script_path="$link_target" ;;
    *)  script_path="$(dirname "$script_path")/$link_target" ;;
  esac
done
BASE_DIR="$(cd -P "$(dirname "$script_path")" && pwd)"

PROPS="$BASE_DIR/.mvn/wrapper/maven-wrapper.properties"
if [ ! -f "$PROPS" ]; then
  echo "mvnw: cannot find $PROPS" >&2
  exit 1
fi

read_prop() {
  grep "^$1=" "$PROPS" | head -n 1 | cut -d= -f2- | tr -d '\r' | sed 's/\\//g'
}

DIST_NAME="$(read_prop distributionName)"
DIST_URL="$(read_prop distributionUrl)"

if [ -z "$DIST_NAME" ] || [ -z "$DIST_URL" ]; then
  echo "mvnw: distributionName or distributionUrl missing from $PROPS" >&2
  exit 1
fi

MAVEN_HOME_BASE="${MAVEN_USER_HOME:-$HOME/.m2}/wrapper/dists/$DIST_NAME"
MVN_CMD="$MAVEN_HOME_BASE/$DIST_NAME/bin/mvn"

if [ ! -f "$MVN_CMD" ]; then
  echo "Downloading $DIST_NAME (one time only)..." >&2
  mkdir -p "$MAVEN_HOME_BASE"
  ARCHIVE="$MAVEN_HOME_BASE/$DIST_NAME-bin.tar.gz"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$ARCHIVE" "$DIST_URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$ARCHIVE" "$DIST_URL"
  else
    echo "mvnw: need curl or wget to download Maven, and neither is installed" >&2
    exit 1
  fi

  tar -xzf "$ARCHIVE" -C "$MAVEN_HOME_BASE"
  rm -f "$ARCHIVE"
fi

if [ ! -f "$MVN_CMD" ]; then
  echo "mvnw: Maven was not found at $MVN_CMD after extraction" >&2
  echo "mvnw: delete $MAVEN_HOME_BASE and try again" >&2
  exit 1
fi

chmod +x "$MVN_CMD" 2>/dev/null || true

export MAVEN_PROJECTBASEDIR="$BASE_DIR"
exec "$MVN_CMD" "$@"
