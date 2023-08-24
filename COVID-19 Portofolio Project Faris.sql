Select *
From PortofolioProjects..CovidDeaths

---SEE DEATH PERCENTAGE TO TOTAL CASES IN INDONESIA

Select Location, date, total_cases, total_deaths, 
Case
	When total_cases <> 0 Then (total_deaths *100.0/total_cases)
	Else Null
End As DeathPercentage
from PortofolioProjects..CovidDeaths
where location like 'indonesia'
order by 1,2

---SEE DEATHS NUMBER EACH DAY IN INDONESIA AND COMPARE THAT TO INDONESIA'S POPULATION

Select Location, date, total_deaths, population, (total_deaths/population)*100 as DeathperPopulation
from PortofolioProjects..CovidDeaths
where location like 'indonesia'
order by 1,2

---SEE CASES NUMBER EACH DAY IN INDONESIA AND COMPARE THAT TO INDONESIA'S POPULATION

Select Location, date, total_cases, population, (total_cases/population)*100 as CasesperPopulation
from PortofolioProjects..CovidDeaths
where location like 'indonesia'
order by 1,2

----SEE WHICH COUNTRY HAS THE HIGHEST PERCENTAGE CASES PER POPULATION

Select Location, population, max(total_cases) HighestInfectionCount, max(total_cases/population)*100 CasesPercentageCount
from PortofolioProjects..CovidDeaths
where continent is not null
group by location, population
order by 4 desc

----Counting HIGHEST INFECTION PER CONTINENT GLOBALLY

Select location, max(total_cases) HighestInfectionCount, max(total_cases/population)*100 CasesPercentageCount
from PortofolioProjects..CovidDeaths
where continent is null and location not like '%income%'
group by location
order by 3 desc

alter table CovidDeaths
alter column new_cases int

---SEE DEATH PERCANTAGE EACH DAY IN EACH COUNTRY GLOBALLY

SELECT
date,
location,
SUM(new_deaths) as TD,
SUM(new_cases) as TC,
case when new_cases = 0 then null else sum(new_deaths)/sum(cast(new_cases as float))*100 end as DP
	from PortofolioProjects..CovidDeaths
	where continent is not null
 group by date, location, new_cases
 order by 2,3

 ---SEEHOW MANY PEOPLE HAS BEEN VACCINATED EACH DAY BY COUNTING UP AND ADDING THE NUMBER DAY BY DAY

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(FLOAT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolliingPeopleVaccinated
from PortofolioProjects..CovidDeaths dea
Join PortofolioProjects..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

---USING CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(FLOAT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolliingPeopleVaccinated
from PortofolioProjects..CovidDeaths dea
Join PortofolioProjects..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

---USING TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population float,
New_vaccinations numeric,
RolliingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolliingPeopleVaccinated
from PortofolioProjects..CovidDeaths dea
Join PortofolioProjects..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
----where dea.continent is not null
--order by 2,3

select *, (RolliingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

---CREATE A VIEW FOR LATER VISUALIZATION

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RolliingPeopleVaccinated
from PortofolioProjects..CovidDeaths dea
Join PortofolioProjects..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated
