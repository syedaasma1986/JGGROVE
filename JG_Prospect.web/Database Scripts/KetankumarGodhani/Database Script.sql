-----------------------------------------------------------------------------------------
					---29 APR 2017
-----------------------------------------------------------------------------------------

-- 1
ALTER PROCEDURE [dbo].[USP_GetEmails] 
(
	@Id int = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [dbo].[new_customer]
	WHERE id = @id
END
GO

-- 2
ALTER PROCEDURE [dbo].[UDP_AddCustom]    
(      
 @Id int,  
 @CustomerId int,   
 @UserId int, 
 @Customer VARCHAR(200),    
 @WorkArea VARCHAR(200),    
 @ProposalTerms VARCHAR(500),    
 @ProposalCost DECIMAL(18,2),    
 @Attachment VARCHAR(50),    
 @SpecialInstruction VARCHAR(200),    
 @LocationImg NVARCHAR(4000),  
 --@ProductType int,  
 @MainImage varchar(150),  
   
 @ProductTypeId int, --Added By chandra for yankee gutter gaurd Product 
 @CustomerSuppliedMaterial nvarchar(MAX),
 @IsCustSupMatApplicable bit,
 @MaterialStorage nvarchar(MAX),
 @IsMatStorageApplicable bit,
 @DumpStorage varchar(512),
 @IsDumpStorageApplicable bit,
 @IsPermitRequired bit,
 @IsHabitat bit,
 @Others varchar(500)
)    
AS    
BEGIN    
--@LocationImg NVARCHAR(4000)    
  DECLARE @hDoc int  , @NewQuoteNo varchar(100)   
  DECLARE @customId INT ,@status  varchar(50),@meetingDate datetime
  declare @currStatus varchar(20)
      
  EXEC sp_xml_preparedocument @hDoc OUTPUT, @LocationImg      
      
  BEGIN TRY    
      
     
    IF EXISTS(SELECT * FROM tblCustom WHERE Id = @Id)  
    BEGIN  
         
       --BEGIN TRAN   
			select @currStatus=[Status] from tblCustom  WHERE Id = @Id  
			if(@currStatus like '%est%')
			begin
			UPDATE tblCustom 
			SET  WorkArea = @WorkArea
				,ProposalTerms =@ProposalTerms  
				,ProposalCost =@ProposalCost
				,Attachment =@Attachment  
				,SpecialInstruction =@SpecialInstruction
				,Modifieddate=GETDATE()
				,[Status] = case when (@ProposalCost > 1000) then 'est>$1000' else 'est<$1000' end
				,[CustSuppliedMaterial]=@CustomerSuppliedMaterial
				,[IsCustSupMatApplicable]=@IsCustSupMatApplicable
				,[MaterialStorage]=@MaterialStorage
				,[IsMatStorageApplicable]=@IsMatStorageApplicable
				,[DumpStorage] = @DumpStorage
				,[IsDumpStorageApplicable] = @IsDumpStorageApplicable
				,[IsPermitRequired]=@IsPermitRequired
				,[IsHabitat]=@IsHabitat
				,[MainImage]=@MainImage
			WHERE Id = @Id  
            end
            else
            begin
				UPDATE tblCustom 
			SET  WorkArea = @WorkArea
				,ProposalTerms =@ProposalTerms  
				,ProposalCost =@ProposalCost
				,Attachment =@Attachment  
				,SpecialInstruction =@SpecialInstruction
				,Modifieddate=GETDATE()
				,[CustSuppliedMaterial]=@CustomerSuppliedMaterial
				,[IsCustSupMatApplicable]=@IsCustSupMatApplicable
				,[MaterialStorage]=@MaterialStorage
				,[IsMatStorageApplicable]=@IsMatStorageApplicable
				,[DumpStorage] = @DumpStorage
				,[IsDumpStorageApplicable] = @IsDumpStorageApplicable
				,[IsPermitRequired]=@IsPermitRequired
				,[IsHabitat]=@IsHabitat
				,[MainImage]=@MainImage
			WHERE Id = @Id  
            end
            
			 DELETE FROM tblCustomerLocationPics WHERE CustomerId = @CustomerId and ProductId = @Id  
				and ProductTypeId = @ProductTypeId  
              
			INSERT INTO tblCustomerLocationPics SELECT @CustomerId,pic,GETDATE(),@Id, @ProductTypeId   
				FROM OPENXML(@hDoc,'/root/pics',2)    
				WITH    
					(    
						pic NVARCHAR(MAX)    
					 )  
			
			select @status= Status,@meetingDate=GETDATE()  from tblcustom where id=@Id
			exec UDP_EntryInCustomer_followup @CustomerId,@meetingDate,@status,@UserId,@ProductTypeId,@Id,0,0
      --COMMIT      
        
    END  
    ELSE  
    BEGIN  
      
	--BEGIN TRAN   
      
		INSERT INTO tblCustom(CustomerId,UserId,WorkArea,ProposalTerms,ProposalCost,Attachment
			,SpecialInstruction,MainImage,ProductTypeIdFrom,[Status],Createddate,Modifieddate
			,[CustSuppliedMaterial],[IsCustSupMatApplicable],[MaterialStorage],[IsMatStorageApplicable],[DumpStorage], [IsDumpStorageApplicable]
			,[IsPermitRequired],[IsHabitat],[Others])    
		values(@CustomerId,@UserId ,@WorkArea,@ProposalTerms,@ProposalCost,@Attachment
			,@SpecialInstruction,@MainImage,@ProductTypeId,
			case when (@ProposalCost > 1000) then 'est>$1000' else 'est<$1000' end
			,GETDATE(),GETDATE(),@CustomerSuppliedMaterial, @IsCustSupMatApplicable, @MaterialStorage,
			@IsMatStorageApplicable, @DumpStorage, @IsDumpStorageApplicable, @IsPermitRequired, @IsHabitat,@Others)    
       
     set @customId = SCOPE_IDENTITY()  
       
     INSERT INTO tblCustomerLocationPics SELECT @CustomerId,pic,GETDATE(),@customId, @ProductTypeId   
     FROM OPENXML(@hDoc,'/root/pics',2)    
     WITH    
     (    
    pic NVARCHAR(MAX)    
     )   
        select @status= Status,@meetingDate=GETDATE()  from tblcustom where id=@customId
			exec UDP_EntryInCustomer_followup @CustomerId,@meetingDate,@status,@UserId,@ProductTypeId,@customId,0,0
			
	exec UDP_CalculateNewQuoteNumber @customerId, @ProductTypeId, @customId,@NewQuoteNo out
	
	INSERT INTO tblQuoteSequence([CustomerId],[ProductId],[EstimateId],[QuoteNumber])
				VALUES(@customerId ,@ProductTypeId ,@customId ,@NewQuoteNo)
     --COMMIT     
       
   END    
   
    
UPDATE new_customer   
set [Status] = case when (@ProposalCost > 1000) then 'est>$1000' else 'est<$1000' end  
where id = @CustomerId 
   
    END TRY    
 BEGIN CATCH    
       
  --ROLLBACK    
       
 END CATCH     
   
  EXEC sp_xml_removedocument @hDoc   
         
END
--exec [dbo].[UDP_AddCustom] 154,154,2,'abhika','12x','jkhj',4236,'calender data.doc','ss','<root><pics><pic>d48eb54f-27fa-4226-802c-2f8b9de056b6-Chrysanthemum.jpg</pic></pics><pics><pic>60019f57-2210-460d-801a-e3fc9940773c-Penguins.jpg</pic></pics></root>','d48eb54f-27fa-4226-802c-2f8b9de056b6-Chrysanthemum.jpg',4,csm,true,mds,true,true,true,''
GO