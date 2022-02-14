#!/bin/bash

if [[ $# -ne 2 ]] ; then
    echo 'Required 2 arguments: databricks_profile_name and version_of_library.'
    echo '   For example: ./upload_with_dbfs.sh ecbpremium 3.1.2_2.12-1.0.0 '
    echo '                This requires to have configured ~/.databrickscfg'
    echo ' For more info check: https://docs.databricks.com/dev-tools/cli/index.html'
    exit 1
fi
echo 'Uploading to dbfs:/databricks/spark-monitoring/'
dbfs --profile $1 mkdirs dbfs:/databricks/spark-monitoring
dbfs --profile $1 cp --overwrite src/target/spark-listeners_$2.jar dbfs:/databricks/spark-monitoring/
dbfs --profile $1 cp --overwrite src/target/spark-listeners-loganalytics_$2.jar dbfs:/databricks/spark-monitoring/
dbfs --profile $1 cp --overwrite src/spark-listeners/scripts/spark-monitoring.sh dbfs:/databricks/spark-monitoring/

echo 'Uploaded to dbfs:/databricks/spark-monitoring/'
echo 'Showing the content of the folder dbfs:/databricks/spark-monitoring/'
dbfs --profile $1 ls dbfs:/databricks/spark-monitoring/
echo '************************************************************************************'
echo 'To install the library, add the following init script:'
echo '    dbfs:/databricks/spark-monitoring/spark-monitoring.sh'
echo ' And include the following Environment Variables:'
echo '    LOG_ANALYTICS_WORKSPACE_KEY={{secrets/your-scope-linked-to-keyvault/databricksloganalytics-key}}'
echo '    LOG_ANALYTICS_WORKSPACE_ID={{secrets/your-scope-linked-to-keyvault/databricksloganalytics-workspace-id}}'
echo ' OPTIONAL: If you want to filter the logs, add the following Environment Variables: (examples)'
echo '    LA_SPARKMETRIC_REGEX=app.*\.ExternalShuffle\.shuffle-client\.usedDirectMemory|app.*\.jvm\.total\.used|app.*\.jvm\.pools\.PS-Survivor-Space\.used|app.*\.jvm\.pools\.Code-Cache\.used|app.*\.jvm\.pools\.Metaspace\.used|app.*\.executor\.cpuTime|app.*\.executor\.runTime    '
echo '    LA_SPARKLISTENEREVENT_REGEX=SparkListenerTaskEnd|SparkListenerExecutorAdded|SparkListenerBlockManagerAdded|SparkListenerJobStart|SparkListenerStageSubmitted|SparkListenerTaskGettingResult|SparkListenerTaskStart   '
echo '    LA_SPARKLOGGINGEVENT_NAME_REGEX=org\.apache\.spark\.deploy\.master\.Master     '
echo '    LA_SPARKLOGGINGEVENT_MESSAGE_REGEX=Registering worker.*    '
echo '************************************************************************************'
