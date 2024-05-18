Select *
from Portfolio_Project.dbo.['owid-covid-data-death$']
order by 3,4


--Select *
--from Portfolio_Project.dbo.['owid-covid-dat-vaccine$']
--order by 3,4

--Select Date that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Project..['owid-covid-data-death$']
order  by 1,2


-- Looking at Total Cases vs Total Deaths ( You need to converts a value to a float datatype using the Cast() function)
-- Shows likelihood of dying if you contract Covid in your Country


Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From Portfolio_Project..['owid-covid-data-death$']
where location like '%UK%'
order by 1,2


-- Looking at Total cases vs Total Population
-- Shows what percentage of population got Covid

Select location, date, population, total_cases, total_deaths, (cast(total_cases as float)/cast(population as float))*100 as Percentage
From Portfolio_Project..['owid-covid-data-death$']
where location like '%UK%'
order by 1,2


-- Looking at Total cases vs Total Population
-- Shows what percentage of population got Covid

Select location, date, population, total_cases, total_deaths, (cast(total_cases as float)/cast(population as float))*100 as PercentPopulationInfected
From Portfolio_Project..['owid-covid-data-death$']
--Where location like '%UK%'
order by 1,2


--- Looking at Countries with Highest Infection Rate Comppared to Population


Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from Portfolio_Project..['owid-covid-data-death$']
Group by location,population
order by PercentPopulationInfected desc


--Showing Countries with Death Count per Population

Select location,population, MAX(total_deaths) as TotalDeathCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from Portfolio_Project..['owid-covid-data-death$']
Group by location,population
order by TotalDeathCount desc

---

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
Group by location
order by TotalDeathCount desc


--Where continent is Null

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is null
Group by location
order by TotalDeathCount desc


---LETS BREAK IT DOWN BY CONTINENT

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is null
Group by location
order by TotalDeathCount desc

----
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is not NULL
Group by location
order by TotalDeathCount desc

----

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is not NULL
Group by continent
order by TotalDeathCount desc

----

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is  NULL
Group by continent
order by TotalDeathCount desc

--- Showing the Continents with Highest Death count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project..['owid-covid-data-death$']
where continent is not NULL
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From Portfolio_Project..['owid-covid-data-death$']
--where location like '%UK%'
Where continent is not null
order by 1,2

Select date, SUM(new_cases)-- as HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentPopulationInfected
from Portfolio_Project..['owid-covid-data-death$']
where continent is  null
Group by date
order by 1,2

Select date, SUM(new_cases), SUM(cast(new_deaths as int))-- as HighestInfectionCount, MAX((total_cases/population_density))*100 as PercentPopulationInfected
from Portfolio_Project..['owid-covid-data-death$']
Where continent is  not null
Group by date
order by 1,2

--

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))*100 as DeathPercentage
from Portfolio_Project..['owid-covid-data-death$']
Where continent is  not null
Group by date
order by 1,2

--
select *
from Portfolio_Project..['owid-covid-data-death$'] dea
join Portfolio_Project..['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date

  --Looking at total Population vs Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 order by 1,2,3

 --
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location)
from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 order by 1,2,3

 ----

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
  from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 order by 1,2,3

 --USE CTE

 With PopvsVac (continet, location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
  from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 --order by 1,2,3
 )
 select *,(RollingPeopleVaccinated/population)*100
 from PopvsVac

 ---TEMP TABLE

 DROP Table if exists #PercentPopulationVaccinated

 Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 --order by 1,2,3
 select *,(RollingPeopleVaccinated/population)*100
 from #PercentPopulationVaccinated

 --Creating View to store data for later visualization

 Create view PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
from Portfolio_Project.dbo.['owid-covid-data-death$'] dea
join Portfolio_Project.dbo.['owid-covid-dat-vaccine$'] vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
 --order by 1,2,3

 Select *
 from PercentPopulationVaccinated
