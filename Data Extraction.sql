SELECT location,date,total_cases,new_cases,total_deaths,population FROM[portfolio project].[dbo].[CovidDeaths$]
order by 1,2

--Total_cases and total_deaths
SELECT location,date,total_cases,new_cases,total_deaths ,(total_deaths/total_cases)*100 as Deathpercentage
FROM[portfolio project].[dbo].[CovidDeaths$]
where Location like '%India%' 
order by 1,2

--looking at total cases vs the population
SELECT location,date,population,total_cases,new_cases,(total_cases/population)*100 as covid_affected
FROM[portfolio project].[dbo].[CovidDeaths$]
where Location like '%India%' 
order by 1,2

--highest infection rates compared to the population
SELECT location,population,MAX(total_cases) as highest_infection,MAX((total_cases/population))*100 as covid_affected
FROM[portfolio project].[dbo].[CovidDeaths$]
group by location,population
order by covid_affected desc

--showing the country with highest deathcount according to the population
SELECT location,MAX(cast(total_deaths as int))as total_death_count 
FROM[portfolio project].[dbo].[CovidDeaths$]
where continent is not null
group by location
order by total_death_count desc

--breaking down thigs by continent
SELECT location,MAX(cast(total_deaths as int))as total_death_count 
FROM[portfolio project].[dbo].[CovidDeaths$]
where continent is null
group by location
order by total_death_count desc

--global numbers

select date,SUM(new_cases)as total_cases,SUM(cast(new_deaths as int))as total_deaths,
SUM(cast(new_deaths as int))/sum(new_cases) as death_percentage
FROM[portfolio project].[dbo].[CovidDeaths$]
where continent is not null
group by date
order by 1,2

--joining 2 tables
select * 
FROM[portfolio project].[dbo].[CovidDeaths$] as dea
join [portfolio project].[dbo].[Covidvaccinations$] as vac
on dea.location=vac.location and
dea.date = vac.date

--finding total people vaccinated in the world
with popvsvac(continent, location, date ,population,new_vaccinations, rolling_people_vaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
FROM[portfolio project].[dbo].[CovidDeaths$] as dea
join [portfolio project].[dbo].[Covidvaccinations$] as vac
on dea.location=vac.location and
dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(rolling_people_vaccinated/population)*100
from popvsvac

--temp table

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
 continent nvarchar(225),location nvarchar(255) ,date datetime,population numeric,new_vaccinations numeric,rolling_people_vaccinated numeric)

insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
FROM[portfolio project].[dbo].[CovidDeaths$] as dea
join [portfolio project].[dbo].[Covidvaccinations$] as vac
on dea.location=vac.location and
dea.date = vac.date
where dea.continent is not null
order by 2,3

select * ,(rolling_people_vaccinated/population)*100 as perecnt_vacc_per_population
from #percentpopulationvaccinated


--creating view for storing data for later visulalisations
Create view percentpopulationvaccinate as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
FROM[portfolio project].[dbo].[CovidDeaths$] as dea
join [portfolio project].[dbo].[Covidvaccinations$] as vac
on dea.location=vac.location and
dea.date = vac.date
where dea.continent is not null

select * from 
percentpopulationvaccinate







