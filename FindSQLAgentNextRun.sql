SELECT
    JobName,
    MAX(NextRunTime) as NextRunTime
FROM (
    SELECT 
        j.name as JobName,
        cast(
            CONVERT(CHAR(8), next_run_date, 112) 
            + ' ' 
            + STUFF(STUFF(RIGHT('000000' 
            + CONVERT(VARCHAR(8), next_run_time), 6), 5, 0, ':'), 3, 0, ':')
            as datetime) as NextRunTime
    FROM msdb.dbo.sysjobs j
    join msdb.dbo.sysjobschedules s on j.job_id = s.job_id
) t1
group by JobName
