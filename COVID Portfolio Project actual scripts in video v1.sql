Select *
From [Portfolio Project]..CovidDeaths$
Where continent is not null
order by 3,4

--Select *
--From [Portfolio Project]..CovidVaccinations$
--order by 3,4

Select location, date, total_cases_per_million, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
Where continent is not null
order by 1,2

------Looking at Total Cases vs Total Deaths
------Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases_per_million, total_deaths, (total_deaths/total_cases_per_million)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
where location like '%state%'
Where continent is not null
order by 1,2

--Looking at Total cases vs Population
--shows what percentage of population got covid 

Select location, date, population, total_cases_per_million, (total_deaths/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
where location like '%Nigeria%'
and continent is not null
order by 1,2

--Looking at country with highest infection rate compare to Population

Select location, population, MAX(total_cases_per_million) as HighestInfectionCount,  MAX((total_deaths/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
--where location like '%Nigeria%'
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%state%'
Where continent is not null
Group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT



-- Showing continent with Highest Death Count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths$
--where location like '%state%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
--where location like '%state%'
Where continent is not null
--Group By date
order by 1,2  

--Looking at Total Polulation vs Vaccination

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidDeaths$ vac
  On dea.location = vac.location
where dea.continent is not null
  and dea.date = vac.date
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinated numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidDeaths$ vac
  On dea.location = vac.location
where dea.continent is not null
  and dea.date = vac.date
--order by 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating view to store data for later visualization


Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidDeaths$ vac
  On dea.location = vac.location
where dea.continent is not null
  and dea.date = vac.date
--order by 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated