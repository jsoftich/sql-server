USE msdb
;WITH CTE AS (SELECT schedule_id, job_id, RIGHT('0'+CAST(next_run_time AS VARCHAR(6)),6) AS next_run_time, next_run_date
FROM sysjobschedules)
SELECT A.name Job_Name,
'Will be running today at '+
SUBSTRING(CONVERT(VARCHAR(10), CASE WHEN SUBSTRING (CONVERT(VARCHAR(10),next_run_time) , 1 ,2) > 12
THEN SUBSTRING (CONVERT(VARCHAR(10),next_run_time),1,2) -12
ELSE SUBSTRING (CONVERT(VARCHAR(10),next_run_time),1,2) END),1,2)
+':'+SUBSTRING (CONVERT(VARCHAR(10), next_run_time),3,2)
+':'+SUBSTRING (CONVERT(VARCHAR(10), next_run_time ),5,2) 'Scheduled At'
FROM sysjobs A ,CTE B
WHERE A.job_id = B.job_id
AND SUBSTRING(CONVERT(VARCHAR(10),next_run_date) , 5,2) +'/'+
SUBSTRING(CONVERT(VARCHAR(10),next_run_date) , 7,2) +'/'+
SUBSTRING(CONVERT(VARCHAR(10),next_run_date),1,4) = CONVERT(VARCHAR(10),GETDATE()+1,101)
AND (SUBSTRING( CONVERT(VARCHAR(10),
CASE WHEN SUBSTRING (CONVERT(VARCHAR(10),next_run_time) , 1 ,2) > 12
THEN SUBSTRING (CONVERT(VARCHAR(10),next_run_time) , 1 ,2) -12
ELSE SUBSTRING (CONVERT(VARCHAR(10),next_run_time) , 1 ,2) END),1,2)
+':'+SUBSTRING (CONVERT(VARCHAR(10), next_run_time ),3,2)
+':'+SUBSTRING (CONVERT(VARCHAR(10), next_run_time ),5,2)) >
SUBSTRING (CONVERT( VARCHAR(30) , GETDATE(),9),13,7)