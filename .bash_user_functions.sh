function zoterof() {
  if [ ! $ZOTERO_DB_ADDR ]; then
    echo "
    Make sure to set your Zotero sqlite db path env var.
    'export ZOTERO_DB_ADDR=<file-path>'
    "
    return
  fi


  ROWS=$(sqlite3 -json $ZOTERO_DB_ADDR "with title_id as (
                                select fieldID
                                from fields
                                where fieldName LIKE 'title'
                                )
                                select itDV.value, it.key
                                from itemData itD
                                join itemDataValues itDV on itDV.valueID = itD.valueID
                                join items it on it.itemID = itD.itemID
                                where itD.fieldID = (select * from title_id)
                                and itDV.value LIKE '%.pdf';")


  PAPERS=$(echo $ROWS | jq .[].value | fzf --multi)

  if [ ! -z "$PAPERS" ]; then
    PAPERS=$(echo $PAPERS | sed -e 's/" "/","/g')
  fi

  JQ_ROWS_FILTER='map(select(.value | IN('$PAPERS')))'

  echo $ROWS | jq "$JQ_ROWS_FILTER" 

}
