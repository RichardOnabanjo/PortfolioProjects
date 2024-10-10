select *
From [PORTFOLIO PROJECTS]..CovidDeaths$
where continent is not null
order by 3,4

--select *
--From [PORTFOLIO PROJECTS]..CovidVaccinations$   
--order by 3,4

-- select data that we are going to be using
select Location, date, total_cases, new_cases, total_deaths, population
From [PORTFOLIO PROJECTS]..CovidDeaths$
where continent is not null
order by 1,2


-- Looking at total cases vs total deaths
-- shows the likelihood of dying if you contract covid in your country
select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From [PORTFOLIO PROJECTS]..CovidDeaths$
where location = 'Nigeria'
and continent is not null
order by 1,2

-- Looking at total cases vs population
--shows what percentage of population got covid

select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From [PORTFOLIO PROJECTS]..CovidDeaths$
--where location = 'Nigeria'
where continent is not null
order by 1,2

-- looking at countries with highest infection rate compared to population

select Location, MAX(total_cases) AS HighestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
From [PORTFOLIO PROJECTS]..CovidDeaths$
--where location = 'Nigeria'
Where continent is NOT null
Group by location, population
order by PercentPopulationInfected desc


-- showing countries with the highest death count per population

select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From [PORTFOLIO PROJECTS]..CovidDeaths$
--where location = 'Nigeria'
where continent is NOT null
Group by location
order by TotalDeathCount desc

--Let`s break things down by continent

-- showing the continents with the highest death per population
select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From [PORTFOLIO PROJECTS]..CovidDeaths$
--where location = 'Nigeria'
where continent is null
Group by continent 
order by TotalDeathCount desc


-- GLOBAL NUMBERS

select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From [PORTFOLIO PROJECTS]..CovidDeaths$
--where location = 'Nigeria'
where continent is not null
--Group by date
order by 1,2

-- looking at total population vs vaccination
-- using cte

With popvsVac (continent, location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PORTFOLIO PROJECTS]..CovidDeaths$ dea
join [PORTFOLIO PROJECTS]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)


select *, (RollingPeopleVaccinated/population)*100
from popvsVac




-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)



INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PORTFOLIO PROJECTS]..CovidDeaths$ dea
join [PORTFOLIO PROJECTS]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



-- TEMP TABLE alteration

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)



INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PORTFOLIO PROJECTS]..CovidDeaths$ dea
join [PORTFOLIO PROJECTS]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



-- TEMP TABLE alteration

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)



INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PORTFOLIO PROJECTS]..CovidDeaths$ dea
join [PORTFOLIO PROJECTS]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



-- creating view to store data for later visualisations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [PORTFOLIO PROJECTS]..CovidDeaths$ dea
join [PORTFOLIO PROJECTS]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *
from PercentPopulationVaccinated