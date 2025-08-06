#!/bin/sh

command -v curl >/dev/null || {
  echo "curl not found"
  return 1
}
command -v tar >/dev/null || {
  echo "tar not found"
  return 1
}

TLDR_DB=$HOME/.tldr
TLDR_DB_NO_LEADING_SLASH=$(echo $TLDR_DB | sed "s/\///")
ARCHIVE_NAME=archive
mkdir -p "$TLDR_DB"
replaced_slash=$(echo $1 | sed "s/\//-/g")
if ! tar -xOf "$TLDR_DB/$ARCHIVE_NAME.tar.gz" "$TLDR_DB_NO_LEADING_SLASH/$replaced_slash" 2>/dev/null; then
  gunzip $TLDR_DB/$ARCHIVE_NAME.tar.gz 2>/dev/null
  curl -s cheat.sh/$1 >$TLDR_DB/$replaced_slash
  cat $TLDR_DB/$replaced_slash

  if ! grep -q "^Unknown topic." $TLDR_DB/$replaced_slash; then
    #echo saving $replaced_slash to database
    tar -rf $TLDR_DB/$ARCHIVE_NAME.tar $TLDR_DB/$replaced_slash 2>/dev/null
    #echo removing temporary $replaced_slash
  fi

  rm $TLDR_DB/$replaced_slash
  #echo compressing archive
  gzip $TLDR_DB/$ARCHIVE_NAME.tar >/dev/null
fi
