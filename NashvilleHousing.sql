--Cleaning data

select *
from [Nashville Data Cleaning]..NashvilleHousing

--Stabdardise date format

select SaleDateConverted, CONVERT(date, saledate) 
from [Nashville Data Cleaning]..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date, saledate)

alter table nashvillehousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date, saledate)

--Property Data

select *
from [Nashville Data Cleaning]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Data Cleaning]..NashvilleHousing a
join [Nashville Data Cleaning]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Data Cleaning]..NashvilleHousing a
join [Nashville Data Cleaning]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

--	update a
--set PropertyAddress = isnull(a.PropertyAddress,'no adress')
--from [Nashville Data Cleaning]..NashvilleHousing a
--join [Nashville Data Cleaning]..NashvilleHousing b
--	on a.ParcelID = b.ParcelID
--	and a.[UniqueID ] <> b.[UniqueID ]
--	where a.PropertyAddress is null

--Individual column

select PropertyAddress
from [Nashville Data Cleaning]..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(propertyaddress)) as Address

from [Nashville Data Cleaning]..NashvilleHousing

-- + or - is for remove the (,) in adress

alter table nashvillehousing
add PropertySplitAdress Nvarchar(255);

update NashvilleHousing
set PropertySplitAdress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table nashvillehousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(propertyaddress))

select *
from [Nashville Data Cleaning]..NashvilleHousing

--Split owner adress

select OwnerAddress
from [Nashville Data Cleaning]..NashvilleHousing

select
PARSENAME(replace(owneraddress, ',','.'), 3)
,PARSENAME(replace(owneraddress, ',','.'), 2)
,PARSENAME(replace(owneraddress, ',','.'), 1)

from [Nashville Data Cleaning]..NashvilleHousing




alter table nashvillehousing
add OwnerSplitAdress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAdress = PARSENAME(replace(owneraddress, ',','.'), 3)

alter table nashvillehousing
add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(owneraddress, ',','.'), 2)

alter table nashvillehousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(owneraddress, ',','.'), 1)

select *
from [Nashville Data Cleaning]..NashvilleHousing

--Sold as vacant

select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Data Cleaning]..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from [Nashville Data Cleaning]..NashvilleHousing 

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

--Remove duplicates


--temp table

--with RowNumCTE as(
--select *,
--	ROW_NUMBER() over (
--	partition by ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 order by
--					UniqueID
--					) row_num
--from [Nashville Data Cleaning]..NashvilleHousing
----order by ParcelID
--)
--select *
--from RowNumCTE
--where row_num > 1
--order by PropertyAddress



--with RowNumCTE as(
--select *,
--	ROW_NUMBER() over (
--	partition by ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 order by
--					UniqueID
--					) row_num
--from [Nashville Data Cleaning]..NashvilleHousing
----order by ParcelID
--)
--delete
--from RowNumCTE
--where row_num > 1
----order by PropertyAddress

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num
from [Nashville Data Cleaning]..NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress

select *
from [Nashville Data Cleaning]..NashvilleHousing


--Delete unused columns

select *
from [Nashville Data Cleaning]..NashvilleHousing

alter table [Nashville Data Cleaning]..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table [Nashville Data Cleaning]..NashvilleHousing
drop column SaleDate




