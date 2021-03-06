USE [001]
GO
/****** Object:  StoredProcedure [dbo].[wsCreatePalletMD]    Script Date: 04/05/2011 16:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[wsCreatePalletMD]
(
  @Item_no        char(30),
  @Loc            char(3),
  @ord_no         char(8),
  @line_no        int,
  @Qty            decimal(16,4),
  @Pallet_UCC128  char(50),
  @Weight         Decimal(12,4)
)
AS
--Last Updated on 04/06/2011

  Declare @load_dt        datetime
  Declare @BinSLID        uniqueidentifier 
  Declare @ship_dt        datetime 
  Declare @TrackingNo     char(20) 
  Declare @ParcelType     char(10) 
  Declare @Status         char(3) 
  Declare @seq_no         int 
  Declare @Height         int
  Declare @Length         int
  Declare @Width          int
  Declare @Shipped        char(1)
  Declare @item_desc      char(30)
  Declare @carton_ucc128  varchar(50)

  Set @Shipped = 'N'
  Set @Height = 0
  Set @Length = 0
  Set @Width = 0
  Set @load_dt = Getdate()
  Set @BinSLID = Newid()
  Set @ship_dt = Null
  Set @TrackingNo = Null
  Set @ParcelType = Null
  Set @Status = Null
  Set @seq_no = Null
  
  Select @item_desc = item_desc_1
  From imitmidx_sql
  Where item_no = @item_no 
   

	BEGIN TRANSACTION

  If Exists (Select Top 1 1 From wsPikPak Where Shipment = '' and ord_no = '' and item_no = '' and Pallet_UCC128 = @Pallet_UCC128)
    
    Begin

      Update wsPikPak Set Ord_no = @ord_no, Line_no = @line_no, Item_no = @Item_no, item_desc = @item_desc, Loc = @Loc, Qty = @Qty, BinSLID = @BinSLID, load_dt = @load_dt, Shipped = @Shipped, [Weight] = @weight, [Length] = @Length, Width = @Width, Height = @Height
      Where Shipment = '' and ord_no = '' and item_no = '' and Pallet_UCC128 = @Pallet_UCC128
     
    End
    
  Else  
    
    Begin
 /*This section updated by Bryan: Insert Pallet and PalletUCC values into Carton and CartonUCC fields in addition to the pallet fields.
------*/ 
      Insert Into wspikpak (shipment, ord_no, line_no, item_no,item_desc,loc,qty,pallet,pallet_ucc128, Carton, Carton_UCC128, binslid,load_dt,shipped,[weight],length,width,height)
      Select Distinct '', @ord_no, @line_no, @item_no, @item_desc, @loc, @qty, pallet, pallet_ucc128, Carton, Carton_UCC128, @binslid, @load_dt, @shipped, @weight, @length, @width, @height
 /*------*/ 
      From Wspikpak 
      Where Pallet_UCC128 = @Pallet_UCC128
   
    End
        
  If @@error <> 0 Begin
    Rollback Transaction
    Goto on_error
  End
    
	COMMIT TRANSACTION

ON_ERROR: