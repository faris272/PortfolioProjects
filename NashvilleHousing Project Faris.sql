select *
from PortofolioProjects..NashvilleHousing

---STANDARDIZE DATE FORMAT 

select SaleDate, convert(date, Saledate)
from PortofolioProjects..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, Saledate)

alter table nashvillehousing
add SaledateConverted date

update NashvilleHousing
set SaledateConverted = convert(date, Saledate)


---POPULATE THE NULL PROPERTY ADDRESS DATA (WITH NO REFERENCE POINT)

select *
from PortofolioProjects..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortofolioProjects..NashvilleHousing a
join PortofolioProjects..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortofolioProjects..NashvilleHousing a
join PortofolioProjects..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

---BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN (ADDRESS, CITY, STREET)

select *
from PortofolioProjects..NashvilleHousing
where PropertyAddress is null
order by ParcelID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 ) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , len(PropertyAddress)) as City
from PortofolioProjects..NashvilleHousing

alter table nashvillehousing
add Property_address nvarchar(255)

update NashvilleHousing
set Property_address = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 )

alter table nashvillehousing
add Property_city nvarchar(255)

update NashvilleHousing
set Property_city = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , len(PropertyAddress))

select 
PARSENAME(replace(owneraddress,',','.') , 3),
PARSENAME(replace(owneraddress,',','.') , 2),
PARSENAME(replace(owneraddress,',','.') , 1)
from PortofolioProjects..NashvilleHousing

alter table nashvillehousing
add Owner_address nvarchar (255)

update NashvilleHousing
set owner_address = PARSENAME(replace(owneraddress,',','.') , 3)

alter table nashvillehousing
add Owner_city nvarchar (255)

update NashvilleHousing
set owner_city = PARSENAME(replace(owneraddress,',','.') , 2)

alter table nashvillehousing
add Owner_state nvarchar (255)

update NashvilleHousing
set owner_state = PARSENAME(replace(owneraddress,',','.') , 1)


select *
from PortofolioProjects..NashvilleHousing

---CHANGE Y AND N TO YES AND NO IN SOLDASVACANT COLUMN

select SoldAsVacant,
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 
from PortofolioProjects..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = 
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end

select distinct(soldasvacant), count(soldasvacant)
from PortofolioProjects..NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant


---REMOVE DUPLICATES

SELECT *
from PortofolioProjects..NashvilleHousing

with RowNumCTE as(
select *,
	row_number() over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					UniqueID
				) row_num

from PortofolioProjects..NashvilleHousing
)
select *
from rownumcte
where row_num > 1
--order by propertyaddress

---DELETE UNUSED COLUMN

select *
from PortofolioProjects..NashvilleHousing

alter table PortofolioProjects..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress


