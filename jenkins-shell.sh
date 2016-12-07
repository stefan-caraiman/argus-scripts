#!/bin/bash
set -e
UUID=`uuidgen`
WORK_FOLDER="/tmp/argus-run-$UUID"
mkdir $WORK_FOLDER -p

ARGUS_LOG_FILE="$WORK_FOLDER/argus.log"
SUBUNIT_FILE="/tmp/argus-ci-subunit-$UUID.subunit"
HTML_FILE="$UUID-argus-ci-subunit.html"
SUBUNIT_HTML_FILE="/tmp/$HTML_FILE"

touch $ARGUS_LOG_FILE

pushd /home/ubuntu/stefan/cloudbase-init-ci

source /home/ubuntu/cloudbase-init-ci/.venv/argus-ci/bin/activate

echo "TEST ID: $UUID"

crudini --set /etc/argus/argus.conf openstack image_ref $IMAGE_ID

crudini --set /etc/argus/argus.conf argus argus_log_file $ARGUS_LOG_FILE

crudini --set /etc/argus/argus.conf argus output_directory $WORK_FOLDER

crudini --set /etc/argus/argus.conf argus resources "https://raw.githubusercontent.com/stefan-caraiman/cloudbase-init-ci/improve-installation-logs/argus/resources"

crudini --set /etc/argus/argus.conf argus git_command "$GIT_COMMAND"

testr run ScenarioGenericSmoke --subunit >> $SUBUNIT_FILE &

TESTR_PID=$!

tail -f $ARGUS_LOG_FILE &

TAIL_PID=$!

while true;
do
    kill -0 $TESTR_PID 2>/dev/null || break
    sleep 10
done

kill -9 $TAIL_PID

popd

python /home/ubuntu/cloudbase-init-ci/scripts/subunit2html.py $SUBUNIT_FILE $SUBUNIT_HTML_FILE

scp -r $WORK_FOLDER ubuntu@10.10.1.26:/var/www/html/argus-ci-results/

scp -p $SUBUNIT_HTML_FILE ubuntu@10.10.1.26:/var/www/html/argus-ci-results/argus-run-$UUID

echo "You can view all logs for the $UUID run here: http://10.10.1.26/html/argus-ci-results/$UUID"

exit