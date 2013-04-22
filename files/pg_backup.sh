#!/bin/bash
 
###########################
####### LOAD CONFIG #######
###########################
 
while [ $# -gt 0 ]; do
        case $1 in
                -c)
                        if [ -r "$2" ]; then
                                source "$2"
                                shift 2
                        else
                                ${ECHO} "Ureadable config file \"$2\""
                                exit 1
                        fi
                        ;;
                *)
                        ${ECHO} "Unknown Option \"$1\""
                        exit 2
                        ;;
        esac
done
 
if [ $# = 0 ]; then
        SCRIPTPATH=$(cd ${0%/*} && pwd -P)
        source $SCRIPTPATH/pg_backup.config
fi;
 
###########################
#### START THE BACKUPS ####
###########################
 
 
FINAL_BACKUP_DIR=$BACKUP_DIR"`date +\%Y-\%m-\%d`/"
 
echo "Making backup directory in $FINAL_BACKUP_DIR"
 
if ! mkdir -p $FINAL_BACKUP_DIR; then
  echo "Cannot create backup directory in $FINAL_BACKUP_DIR. Go and fix it!"
  exit 1;
fi;
 
 
###########################
### SCHEMA-ONLY BACKUPS ###
###########################
 
for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
do
  SCHEMA_ONLY_CLAUSE="$SCHEMA_ONLY_CLAUSE or datname ~ '$SCHEMA_ONLY_DB'"
done
 
SCHEMA_ONLY_QUERY="select datname from pg_database where false $SCHEMA_ONLY_CLAUSE order by datname;"
 
echo -e "\n\nPerforming schema-only backups"
echo -e "--------------------------------------------\n"
 
SCHEMA_ONLY_DB_LIST=`psql -At -c "$SCHEMA_ONLY_QUERY" postgres`
 
echo -e "The following databases were matched for schema-only backup:\n${SCHEMA_ONLY_DB_LIST}\n"
 
for DATABASE in $SCHEMA_ONLY_DB_LIST
do
  echo "Schema-only backup of $DATABASE"
 
  if ! pg_dump -Fp -s "$DATABASE" | gzip > $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz.in_progress; then
    echo "[!!ERROR!!] Failed to backup database schema of $DATABASE"
  else
    mv $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz.in_progress $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz
  fi
done
 
 
###########################
###### FULL BACKUPS #######
###########################
 
for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
do
  EXCLUDE_SCHEMA_ONLY_CLAUSE="$EXCLUDE_SCHEMA_ONLY_CLAUSE and datname !~ '$SCHEMA_ONLY_DB'"
done
 
FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate and datallowconn $EXCLUDE_SCHEMA_ONLY_CLAUSE order by datname;"
 
echo -e "\n\nPerforming full backups"
echo -e "--------------------------------------------\n"
 
for DATABASE in `psql -At -c "$FULL_BACKUP_QUERY" postgres`
do
  if [ $ENABLE_PLAIN_BACKUPS = "yes" ]
  then
    echo "Plain backup of $DATABASE"
 
    if ! pg_dump -Fp "$DATABASE" | gzip > $FINAL_BACKUP_DIR"$DATABASE".sql.gz.in_progress; then
      echo "[!!ERROR!!] Failed to produce plain backup database $DATABASE"
    else
      mv $FINAL_BACKUP_DIR"$DATABASE".sql.gz.in_progress $FINAL_BACKUP_DIR"$DATABASE".sql.gz
    fi
  fi
 
  if [ $ENABLE_CUSTOM_BACKUPS = "yes" ]
  then
    echo "Custom backup of $DATABASE"
 
    if ! pg_dump -Fc "$DATABASE" -f $FINAL_BACKUP_DIR"$DATABASE".custom.in_progress; then
      echo "[!!ERROR!!] Failed to produce custom backup database $DATABASE"
    else
      mv $FINAL_BACKUP_DIR"$DATABASE".custom.in_progress $FINAL_BACKUP_DIR"$DATABASE".custom
    fi
  fi
 
done
 
echo -e "\nAll database backups complete!"