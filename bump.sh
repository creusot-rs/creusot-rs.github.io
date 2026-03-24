# Script to bump the version automatically to match the latest tag on creusot-rs/creusot

CREUSOT=https://github.com/creusot-rs/creusot

CREUSOT_VERSION=$(git -c versionsort.suffix=- ls-remote --exit-code --refs --sort=version:refname --tags -h $CREUSOT 'v*.*.*'|tail -1|cut --delimiter='/' --fields=3)
CREUSOT_VERSION=${CREUSOT_VERSION#v}
if ! echo $CREUSOT_VERSION|grep -q '^[0-9]\+.[0-9]\+.[0-9]\+$' ; then
  >&2 echo "$CREUSOT_VERSION is not a proper version number. Skipped."
  exit 1
fi

LOCAL_VERSION=$(grep '^version =' config.toml|cut -d'"' --fields=2)
if dpkg --compare-versions $CREUSOT_VERSION le $LOCAL_VERSION ; then
  >&2 echo "Remote $CREUSOT_VERSION is older than local $LOCAL_VERSION. Skipped."
  exit 1
fi

sed -i '/^version =/s/"[^"]*"/"'$CREUSOT_VERSION'"/' config.toml
echo $CREUSOT_VERSION
