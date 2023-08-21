
select  k.[Customer ID],
        k.Customer,
		k.City,
		k.Age,
		k.[Age range],
		k.Income,
		k.[Income range]
from
(select a.ID [Customer ID],
       a.F_NAME+' '+a.L_NAME [Customer],
	   b.NAME [City],
	   floor(datediff(month,a.brth_date,getdate()))/12 [Age],
	   case when floor(datediff(month,a.brth_date,getdate()))/12<=30 then 'Young'
	        when floor(datediff(month,a.brth_date,getdate()))/12 between 30 and 50 then 'Middle aged'
			else 'Old' end 'Age range',
	   a.INCOM [Income],
	   case when a.INCOM<=700 then 'Low'
	        when a.incom between 700 and 1500 then 'Average'
			else 'High' end 'Income range'
 from PPL$ a
 left join CITY$ b on b.CT_KEY=a.CIT_KEY) k


select  k.[Applicant ID],
        k.[Application date],
        k.Ammout,
		k.[Product type],
		k.[Product status],
		k.[Object type],
		k.[Rest months]
from
(select  e.ID [Applicant ID],
        convert(date,a.APP_DATE,101) [Application date],
		convert(date,Lead(a.APP_DATE)over(partition by e.ID order by a.app_date),101) [Next date],
        a.APP_AMT [Ammout],
		c.[Product type],
		d.[Product status],
		f.[Object type],
		isnull(datediff(month,a.app_date,Lead(a.APP_DATE)over(partition by e.ID order by a.app_date)),0) [Rest months]
from APP$ a		
left join (select NAME [Product type],
                  PROD_KEY 
		   from APP_TP$) c on c.PROD_KEY=a.APP_TP_KEY
left join (select STAT_KEY,
                  NAME [Product status] 
		   from APP_STAT$) d on d.STAT_KEY=a.APP_STAT_KEY
left join (select a.obj_key,
                  a.obj_tp_key,
				  b.OBJ_TP_NAME [Object type] 
		   from OBJECT$ a
		   left join OBJ_TP$ b on b.OBJ_TP_KEY=a.OBJ_TP_KEY) f on f.OBJ_KEY=a.OBJ_KEY
left join PPL$ e on e.UNI_KEY=a.UNI_KEY) k






