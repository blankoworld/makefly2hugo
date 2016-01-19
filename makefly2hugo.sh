#!/usr/bin/env bash

# create result directory if not found
resultdir="content/post"
if ! test -d "$resultdir"; then
  mkdir -p $resultdir
fi

function process_metadata() {
  db_author=$(sed -n 's#^AUTHOR = \(.*\)$#\1#p' < "db/$1")
  db_description=$(sed -n 's#^DESCRIPTION = \(.*\)$#\1#p' < "db/$1")
  db_keywords=$(sed -n 's#^KEYWORDS = \(.*\)$#\1#p' < "db/$1")
  db_tags=$(sed -n 's#^TAGS = \(.*\)$#\1#p' < "db/$1")
  db_title=$(sed -n 's#^TITLE = \(.*\)$#\1#p' < "db/$1")
  db_type=$(sed -n 's#^TYPE = \(.*\)$#\1#p' < "db/$1")
  # processing values
  echo "date = ${2}" >> $3
  echo "draft = false" >> $3
  echo "title = \"${db_title}\"" >> $3
  echo "description = \"${db_description}\"" >> $3
  echo "author = \"${db_author}\"" >> $3
  echo "categories = [ \"${db_type}\" ]" >> $3
  # TODO: keywords
  fixed_tags=$(echo "${db_tags}"|sed -e 's#,#", "#g' -e 's#^\(.*\)$#"\1"#g')
  echo "tags = [ ${fixed_tags} ]" >> $3
}

# browser db directory
for item in `ls db`; do
  # fetch info about post title and date
  timestamp=`echo $item|cut -d ',' -f 1`
  mkfilename=`echo $item|cut -d ',' -f 2`
  postname=`basename $mkfilename .mk`
  date=$(date -d "@${timestamp}" +'%Y-%m-%dT%H:%M:%S')

  # check if a source file exist for the given postname
  mdfile="${postname}.md"
  srcfile="src/${mdfile}"
  if test -f "$srcfile"; then
    # source file exist, create result for this file
    destfile="${resultdir}/${mdfile}"
    if test -f "${destfile}"; then
      echo "+++" > "${destfile}"
    else
      echo "+++" >> "${destfile}"
    fi
    # parse metadata and add them to result file
    process_metadata "${item}" "${date}" "${destfile}"
    # end of metadata
    echo -e "\n+++" >> "${destfile}"
    # add content
    cat "$srcfile" >> "${destfile}"
    # process for this post is done
    echo "[EXPORTED] ${postname}"
  else
    echo "[NO CONTENT] ${postname}"
  fi
done
