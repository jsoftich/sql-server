

---un-used indexes excluding PK's
SELECT o.name Object_Name,
	   SCHEMA_NAME(o.schema_id) Schema_name,
       i.name Index_name, 
       i.Type_Desc--,i.*
 FROM sys.objects AS o
     JOIN sys.indexes AS i
 ON o.object_id = i.object_id and i.is_primary_key=0 and SCHEMA_NAME(o.schema_id)='dbo'
  LEFT OUTER JOIN 
	sys.dm_db_index_usage_stats AS s    
 ON i.object_id = s.object_id  
	AND i.index_id = s.index_id
 WHERE  o.type = 'u'
   --Clustered and Non-Clustered indexes
  AND i.type IN (1, 2) 
  --Indexes without stats
  AND (s.index_id IS NULL) OR
 -- Indexes that have been updated by not used
      (s.user_seeks = 0 AND s.user_scans = 0 AND s.user_lookups = 0 ) OPTION (RECOMPILE);
      
      
---used indexes      
SELECT o.name Object_Name,
       SCHEMA_NAME(o.schema_id) Schema_name,
       i.name Index_name, 
       i.Type_Desc, 
       s.user_seeks,
       s.user_scans, 
       s.user_lookups, 
       s.user_updates  
 FROM sys.objects AS o
     JOIN sys.indexes AS i
 ON o.object_id = i.object_id 
     JOIN
  sys.dm_db_index_usage_stats AS s    
 ON i.object_id = s.object_id   
  AND i.index_id = s.index_id
 WHERE  o.type = 'u'
 -- Clustered and Non-Clustered indexes
  AND i.type IN (1, 2) 
 -- Indexes that have been updated by not used
  AND(s.user_seeks > 0 or s.user_scans > 0 or s.user_lookups > 0 ) OPTION (RECOMPILE);
  
  
  -- Missing Indexes for current instance by Index Advantage
SELECT user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage], 
migs.last_user_seek, mid.[statement] AS [Database.Schema.Table],
mid.equality_columns, mid.inequality_columns, mid.included_columns,
migs.unique_compiles, migs.user_seeks, migs.avg_total_user_cost, migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
ON mig.index_handle = mid.index_handle
where user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) > 10000 --arbitrary cut-off
ORDER BY index_advantage DESC OPTION (RECOMPILE);