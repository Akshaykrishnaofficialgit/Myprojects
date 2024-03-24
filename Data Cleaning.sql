SELECT *
 FROM [portfolio project].[dbo].[Sheet1$]

 SELECT SaleDateConverted , CAST(SaleDate as Date) as date
 FROM [portfolio project].[dbo].[Sheet1$]

 ALTER TABLE [portfolio project].[dbo].[Sheet1$] Add SaleDateConverted Date;

 Update [portfolio project].[dbo].[Sheet1$] SET SaleDate=CONVERT(Date,SaleDate) 

 --property adress
 Select *
 FROM [portfolio project].[dbo].[Sheet1$]
 where PropertyAddress is null
 order by ParcelID

 --Breaking out the adress into individual Coloumns(Adress,City,State) using the substring 

  Select 
 PropertyAddress
 FROM [portfolio project].[dbo].[Sheet1$]

 Select 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
 FROM [portfolio project].[dbo].[Sheet1$]
 ALTER TABLE [portfolio project].[dbo].[Sheet1$] Add PropertysplitAddress Nvarchar(255);
 Update [portfolio project].[dbo].[Sheet1$] SET PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) 
  ALTER TABLE [portfolio project].[dbo].[Sheet1$] Add Propertysplitcity Nvarchar(255);
 Update [portfolio project].[dbo].[Sheet1$] SET Propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) 
 
 --splitting out the owner adress using parsename

 select OwnerAddress
  FROM [portfolio project].[dbo].[Sheet1$]

  select
  PARSENAME(REPLACE(OwnerAddress,',','.'),3),
  PARSENAME(REPLACE(OwnerAddress,',','.'),2),
  PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  FROM [portfolio project].[dbo].[Sheet1$]
			--creating seperate room for the new values in the table
 ALTER TABLE [portfolio project].[dbo].[Sheet1$] 
 Add OwnerSplitAdress Nvarchar(255);
 Update [portfolio project].[dbo].[Sheet1$] 
 SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

 ALTER TABLE [portfolio project].[dbo].[Sheet1$]
 Add Ownersplitcity Nvarchar(255);
 Update [portfolio project].[dbo].[Sheet1$]
 SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

 ALTER TABLE [portfolio project].[dbo].[Sheet1$]
 Add OwnersplitState Nvarchar(255);
 Update [portfolio project].[dbo].[Sheet1$]
 SET OwnersplitState =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)

 --change y and N to yes and no in "sold as vaccantt"field
 select SoldAsVacant,count(soldAsVacant)
   FROM [portfolio project].[dbo].[Sheet1$]
   Group by soldAsVacant
   order by 2

  select SoldAsVacant,
  CASE when SoldAsVacant='Y' THEN 'Yes'
	   when SoldAsVacant='N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [portfolio project].[dbo].[Sheet1$]

Update  [portfolio project].[dbo].[Sheet1$]
SET SoldAsVacant =   CASE when SoldAsVacant='Y' THEN 'Yes'
	   when SoldAsVacant='N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates
 
 with RowNUMCTE AS(
 select*,ROW_NUMBER() OVER(
 PARTITION BY ParcelID,PropertyAddress,Saleprice,SaleDate,LegalReference ORDER BY ParcelID)row_num
 FROM [portfolio project].[dbo].[Sheet1$] 
 )
 DELETE from RowNUMCTE
 where row_num>1
 select * from RowNUMCTE
 where row_num>1

 --Remove unwanted columns
 Select 
 *
 FROM [portfolio project].[dbo].[Sheet1$]

 ALTER TABLE [portfolio project].[dbo].[Sheet1$]
 DROP COLUMN PropertyAddress,OWnerAddress












