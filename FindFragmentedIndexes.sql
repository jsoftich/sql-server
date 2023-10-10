

SELECT b.name as IndexName, object_name(a.object_id) as TableName,a.*
FROM sys.dm_db_index_physical_stats(DB_ID('DW_Reporting'), NULL, NULL, NULL , NULL) a
join sys.indexes b
on
a.object_id=b.object_id
where a.avg_fragmentation_in_percent > 30 
order by 10 desc