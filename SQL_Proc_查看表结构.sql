USE [CY_MaterialManage_Dev]
GO

/****** Object:  StoredProcedure [dbo].[Usp_GS03_Columns]    Script Date: 10/12/2017 15:53:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[Usp_GS03_Columns]
(
   @ObjName VARCHAR(MAX) = ''
)
AS
IF ISNULL(@ObjName,'') = ''
begin
   select [表名] = CASE WHEN A.[Name] = '' THEN A.TableName ELSE '' END
         ,[表说明] = CASE WHEN A.[Name] = '' THEN A.[TDescription] ELSE '' END
         ,[字段名] = CASE WHEN A.[Name] > '' THEN A.[Name] ELSE '' END
         ,[字段说明] = CASE WHEN A.[Name] > '' THEN A.[CDescription] ELSE '' END
         ,[数据类型] = CASE WHEN A.[Name] > '' THEN A.[TypeName] ELSE '' END
         --,[ID] = CASE WHEN A.[Name] > '' THEN case when  A.[ID] = 1 then '1' else '' end ELSE '' END
         ,[主键项] = CASE WHEN A.PK_ordinal > 0 THEN CAST(A.PK_ordinal AS NVARCHAR(20)) ELSE '' END
         ,[可空] = CASE WHEN A.[Name] > '' THEN case when  A.[isnullable] = 1 then '1' else '' end ELSE '' END
         ,[自增] = CASE WHEN A.[Name] > '' THEN case when A.[IsIdentity] = 1 then '1' else '' end ELSE '' END
         ,[默认值] = CASE WHEN A.[Name] > '' THEN A.[DefaultValue] ELSE '' END
   from (SELECT tbl.Name AS TableName, 
                tDescription = cast(isnull(tsep.value,'') as nvarchar(128)),
                [Name] = sc.name, 
                cDescription = cast(isnull(sep.value,'') as nvarchar(128)),
                t.name +  
                case t.name when 'char' then '(' + case sc.length when -1 then 'MAX' else cast( sc.length as varchar(20) ) end + ')' 
                            when 'varchar' then '(' + case sc.length when -1 then 'MAX' else cast( sc.length as varchar(20) ) end + ')' 
                            when 'nchar' then '(' + case sc.length when -1 then 'MAX' else cast( sc.length/2 as varchar(20) ) end + ')' 
                            when 'nvarchar' then '(' + case sc.length when -1 then 'MAX' else cast( sc.length/2 as varchar(20) ) end + ')' 
                            when 'int' then '' 
                            when 'smallint' then '' 
                            when 'bit' then '' 
                            when 'text' then '' 
                            when 'image' then '' 
                            when 'uniqueidentifier' then '' 
                            when 'date' then '' 
                            when 'time' then '' 
                            when 'datetime2' then '' 
                            when 'datetimeoffset' then '' 
                            when 'tinyint' then '' 
                            when 'smalldatetime' then '' 
                            when 'real' then '' 
                            when 'money' then '' 
                            when 'datetime' then '' 
                            when 'float' then '' 
                            when 'ntext' then '' 
                            when 'numeric' then '(' + cast( sc.prec as varchar(20) ) + ',' + cast( sc.scale as varchar(20) ) + ')' 
                            when 'decimal' then '(' + cast( sc.prec as varchar(20) ) + ',' + cast( sc.scale as varchar(20) ) + ')' 
                            when 'bigint' then '' 
                            when 'timestamp' then '' 
                        else '' end AS typeName, 
                        sc.id, 
                        Colid = sc.colid, 
                        PK_ordinal = ic.key_ordinal, 
                        sc.isnullable,
                        ISNULL( CASE CONVERT( BIT, ( sc.status & 0x80 ) ) WHEN 1 THEN 1 ELSE 0 END, '' ) AS isidentity, 
                        ISNULL( CONVERT(VARCHAR(256), sys.syscomments.text), '' ) AS DefaultValue 
                        
           FROM sys.sysobjects AS tbl 
                INNER JOIN sys.syscolumns sc ON sc.id = tbl.id 
                INNER JOIN sys.systypes AS t on ( sc.usertype = t.usertype ) and  
                                                ( sc.xusertype = t.xusertype ) 
                LEFT OUTER JOIN sys.syscomments ON sys.syscomments.id = sc.cdefault
                LEFT OUTER JOIN sys.extended_properties tsep on tsep.major_id = tbl.id and tsep.minor_id = 0
                LEFT OUTER JOIN sys.extended_properties sep on sep.major_id = sc.id and sep.minor_id = sc.colid
                LEFT OUTER JOIN sys.indexes i ON tbl.id = i.object_id AND i.is_primary_key = 1
                LEFT OUTER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id AND ic.column_id= sc.colid AND ic.is_included_column = 0
           WHERE tbl.type = 'u'    
           UNION ALL
           SELECT tbl.Name AS TableName, 
                tDescription = cast(isnull(tsep.value,'') as nvarchar(128)),
                [Name] = '', 
                cDescription = '',
                typeName = '', 
                id = TBL.ID, 
                Colid = '',  
                PK_ordinal= '',
                isnullable = '', 
                isidentity = '',  
                DefaultValue  = ''   
           FROM sys.sysobjects AS tbl 
                LEFT OUTER JOIN sys.extended_properties tsep on tsep.major_id = tbl.id and tsep.minor_id = 0
           WHERE tbl.type = 'u'
           ) a 
  order by a.TableName ,a.colid
end
ELSE
BEGIN
   SELECT [表名] = CASE WHEN A.[Name] = '' THEN A.TableName ELSE '' END
         ,[表说明] = CASE WHEN A.[Name] = '' THEN A.[TDescription] ELSE '' END
         ,[字段名] = CASE WHEN A.[Name] > '' THEN A.[Name] ELSE '' END
         ,[字段说明] = CASE WHEN A.[Name] > '' THEN A.[CDescription] ELSE '' END
         ,[数据类型] = CASE WHEN A.[Name] > '' THEN A.[TypeName] ELSE '' END
         --,[ID] = CASE WHEN A.[Name] > '' THEN case when  A.[ID] = 1 then '1' else '' end ELSE '' END
         ,[主键项] = CASE WHEN A.PK_ordinal > 0 THEN CAST(A.PK_ordinal AS NVARCHAR(20)) ELSE '' END
         ,[可空] = CASE WHEN A.[Name] > '' THEN CASE WHEN  A.[isnullable] = 1 THEN '1' ELSE '' END ELSE '' END
         ,[自增] = CASE WHEN A.[Name] > '' THEN CASE WHEN A.[IsIdentity] = 1 THEN '1' ELSE '' END ELSE '' END
         ,[默认值] = CASE WHEN A.[Name] > '' THEN A.[DefaultValue] ELSE '' END
   FROM (SELECT tbl.Name AS TableName, 
                tDescription = CAST(ISNULL(tsep.value,'') AS NVARCHAR(128)),
                [Name] = sc.name, 
                cDescription = CAST(ISNULL(sep.value,'') AS NVARCHAR(128)),
                t.name +  
                CASE t.name WHEN 'char' THEN '(' + CASE sc.length WHEN -1 THEN 'MAX' ELSE CAST( sc.length AS VARCHAR(20) ) END + ')' 
                            WHEN 'varchar' THEN '(' + CASE sc.length WHEN -1 THEN 'MAX' ELSE CAST( sc.length AS VARCHAR(20) ) END + ')' 
                            WHEN 'nchar' THEN '(' + CASE sc.length WHEN -1 THEN 'MAX' ELSE CAST( sc.length/2 AS VARCHAR(20) ) END + ')' 
                            WHEN 'nvarchar' THEN '(' + CASE sc.length WHEN -1 THEN 'MAX' ELSE CAST( sc.length/2 AS VARCHAR(20) ) END + ')' 
                            WHEN 'int' THEN '' 
                            WHEN 'smallint' THEN '' 
                            WHEN 'bit' THEN '' 
                            WHEN 'text' THEN '' 
                            WHEN 'image' THEN '' 
                            WHEN 'uniqueidentifier' THEN '' 
                            WHEN 'date' THEN '' 
                            WHEN 'time' THEN '' 
                            WHEN 'datetime2' THEN '' 
                            WHEN 'datetimeoffset' THEN '' 
                            WHEN 'tinyint' THEN '' 
                            WHEN 'smalldatetime' THEN '' 
                            WHEN 'real' THEN '' 
                            WHEN 'money' THEN '' 
                            WHEN 'datetime' THEN '' 
                            WHEN 'float' THEN '' 
                            WHEN 'ntext' THEN '' 
                            WHEN 'numeric' THEN '(' + CAST( sc.prec AS VARCHAR(20) ) + ',' + CAST( sc.scale AS VARCHAR(20) ) + ')' 
                            WHEN 'decimal' THEN '(' + CAST( sc.prec AS VARCHAR(20) ) + ',' + CAST( sc.scale AS VARCHAR(20) ) + ')' 
                            WHEN 'bigint' THEN '' 
                            WHEN 'timestamp' THEN '' 
                        ELSE '' END AS typeName, 
                        sc.id, 
                        Colid = sc.colid, 
                        PK_ordinal = ic.key_ordinal, 
                        sc.isnullable,
                        ISNULL( CASE CONVERT( BIT, ( sc.status & 0x80 ) ) WHEN 1 THEN 1 ELSE 0 END, '' ) AS isidentity, 
                        ISNULL( CONVERT(VARCHAR(256), sys.syscomments.text), '' ) AS DefaultValue 
                        
           FROM sys.sysobjects AS tbl 
                INNER JOIN sys.syscolumns sc ON sc.id = tbl.id 
                INNER JOIN sys.systypes AS t ON ( sc.usertype = t.usertype ) AND  
                                                ( sc.xusertype = t.xusertype ) 
                LEFT OUTER JOIN sys.syscomments ON sys.syscomments.id = sc.cdefault
                LEFT OUTER JOIN sys.extended_properties tsep ON tsep.major_id = tbl.id AND tsep.minor_id = 0
                LEFT OUTER JOIN sys.extended_properties sep ON sep.major_id = sc.id AND sep.minor_id = sc.colid
                LEFT OUTER JOIN sys.indexes i ON tbl.id = i.object_id AND i.is_primary_key = 1
                LEFT OUTER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id AND ic.column_id= sc.colid AND ic.is_included_column = 0
           UNION ALL
           SELECT tbl.Name AS TableName, 
                tDescription = CAST(ISNULL(tsep.value,'') AS NVARCHAR(128)),
                [Name] = '', 
                cDescription = '',
                typeName = '', 
                id = TBL.ID, 
                Colid = '',  
                PK_ordinal= '',
                isnullable = '', 
                isidentity = '',  
                DefaultValue  = ''   
           FROM sys.sysobjects AS tbl 
                LEFT OUTER JOIN sys.extended_properties tsep ON tsep.major_id = tbl.id AND tsep.minor_id = 0
           ) a 
  WHERE a.TableName LIKE @ObjName
  ORDER BY a.TableName ,a.colid
  
END


GO


