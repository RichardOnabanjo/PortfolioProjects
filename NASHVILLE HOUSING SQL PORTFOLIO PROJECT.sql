-- CLEANING DATA IN SQL QUERIES

Select *
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


-- standardize date format
Select SaleDateConverted, CONVERT (DATE, SaleDate)
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]

Update [Nashville Housing PROJECT]
SET SaleDate = convert(Date,SaleDate)

ALTER TABLE  [Nashville Housing PROJECT]
Add SaleDateConverted Date;

Update  [Nashville Housing PROJECT]
SET SaleDateConverted = convert(Date,SaleDate)


-- Populate Property Address data

Select *
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT] a
JOIN [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
	where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT] a
JOIN [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]

-- Breaking out Address into individual columns( Address, City, State)

Select PropertyAddress
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
--where PropertyAddress is null
--order by PropertyAddress

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))  as Address

From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


ALTER TABLE  [Nashville Housing PROJECT]
Add PropertySplitAddress nvarchar(255);

Update  [Nashville Housing PROJECT]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE  [Nashville Housing PROJECT]
Add PropertySplitCity nvarchar(255);

Update  [Nashville Housing PROJECT]
SET PropertySplitCity  = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]

-- seperating owner`s address

Select OwnerAddress
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


Select 
PARSENAME (REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),1)
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


ALTER TABLE  [Nashville Housing PROJECT]
Add OwnerSplitAddress nvarchar(255);

Update  [Nashville Housing PROJECT]
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE  [Nashville Housing PROJECT]
Add OwnerSplitCity nvarchar(255);

Update  [Nashville Housing PROJECT]
SET OwnerSplitCity  = PARSENAME (REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE  [Nashville Housing PROJECT]
Add OwnerSplitState nvarchar(255);

Update  [Nashville Housing PROJECT]
SET OwnerSplitState  = PARSENAME (REPLACE(OwnerAddress, ',','.'),1)

Select *
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


-- change Y and N in SoldAsVacant to YES and NO

select Distinct(SoldAsVacant), count(SoldAsVacant)
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
Group by SoldAsVacant
ORDER by 2


select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]


Update [Nashville Housing PROJECT]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



-- Removing duplicates

WITH ROWNUMCTE as(
select *,
	ROW_NUMBER() OVER(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
)

Select *
From ROWNUMCTE
where row_num > 1
order by PropertyAddress



-- DELETE UNSED COLUMNS

Select *
From [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]

ALTER TABLE [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE [PORTFOLIO PROJECTS]..[Nashville Housing PROJECT]
DROP COLUMN SaleDate

