/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [palletid]
      ,[purchaseorder]
      ,[item]
      ,[quantity]
      ,[date]
      ,[time]
      ,[id]
      ,[marco_item_no]
  FROM [001].[dbo].[wmpalidraw]
  WHERE palletid like '%838115D000024%'
  ORDER BY id