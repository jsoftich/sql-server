SELECT
    p1.SPID AS blockedSPID, p2.SPID AS blockingSPID
FROM 
    master..sysprocesses p1
    JOIN
    master..sysprocesses p2 ON p1.blocked = p2.spid