
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath
order by 1,2

-- Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath
order by 1,2

-- Total Cases vs Total Deaths for United Kingdom
-- Chances of dying from covid if you're in UK

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath
where location = 'United Kingdom'
order by DeathPercentage


-- Total Cases vs Population  
-- What percentage of people got COVID

select location, date, total_cases, population,total_deaths, (total_cases/population)*100 as Percentage
from PortfolioProject..CovidDeath
where location = 'United Kingdom'
order by Percentage DESC

-- Countries with Highest Infection Rate compared to Population

select location, max(total_cases) as HighestCases, max(population) as HighestPopulation,  max(total_cases)/max(population)*100 as PercentageInfected
from PortfolioProject..CovidDeath
group by location
order by PercentageInfected DESC

-- Countries with Highest death count

select location, max(cast(total_deaths as int)) as TotalDeath, max(population) as HighestPopulation, max(total_deaths)/max(population)*100 as PercentageofDeath
from PortfolioProject..CovidDeath
group by location
order by TotalDeath DESC


-- Continent with Highest death count

select continent, max(cast(total_deaths as int)) as TotalDeath, max(population) as HighestPopulation, max(total_deaths)/max(population)*100 as PercentageofDeath
from PortfolioProject..CovidDeath
where continent is not null
group by continent
order by TotalDeath DESC


-- Global Numbers Death Percentage

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeath
where continent is not null 

-- Global Numbers Death Percentage by Date

select date ,sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeath
where continent is not null 
group by date
order by date

----------------------------------------------------------------------
--- Total Population Vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.Date)
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVaccine vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Location of How many people got vaccinated on a particular date 

select location, date,sum(cast(new_vaccinations as BIGINT)) 
from PortfolioProject..CovidVaccine
group by location,date
order by 3


-- How many percentage of population got vaccinated
-- Create temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Location nvarchar(255),
Date datetime,
RollingPeopleVaccinated BIGINT
)

Insert into #PercentPopulationVaccinated
select dea.location,dea.date, sum(cast(vac.new_vaccinations as BIGINT))/max(dea.population)*100
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVaccine vac
	on dea.location = vac.location
group by dea.location,dea.date
order by 3


select * from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

DROP View if exists Global
Create View Global as
select date ,sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeath
where continent is not null 
group by date

select * from Global
