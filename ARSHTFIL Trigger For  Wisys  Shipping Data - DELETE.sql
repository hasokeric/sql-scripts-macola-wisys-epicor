USE [001]
GO
/****** Object:  Trigger [dbo].[Insert_to_ARSHTTBL]    Script Date: 03/29/2011 13:59:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [dbo].[Delete_From_ARSHTTBL]
            on [001].[dbo].[ARSHTFIL_SQL]

			after delete
			AS

BEGIN


		UPDATE ARSHTTBL 
		SET void_fg = 'V'

from		deleted ar

inner join	[001].dbo.ARSHTTBL sh

			on ar.ord_no = sh.ord_no  AND ar.tracking_no = sh.tracking_no                                                                                                                                                                                                                 

END

