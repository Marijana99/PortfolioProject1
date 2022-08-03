--1.upit. Izdvoji sve redove iz tabele CovidDeaths 

Select * 
From PortfolioProject..CovidDeaths$


--2.upit
Select * 
From PortfolioProject..CovidDeaths$
order by 3,4

Select * 
From PortfolioProject..CovidVaccinations$
order by 3,4   

--3.upit
Select Location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths$
order by 3,4

--4.upit
--Total cases vs total death  -- procenat broja zarazenih
Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)
From PortfolioProject..CovidDeaths$
order by 1,2


Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
order by 1,2  


Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location = 'Serbia'
order by 1,2 

Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like 'Croatia'
order by 1,2  -- sortira se po drugoj koloni tj po datumu 


Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like 'Montenegro'
order by 1,2


--5.upit ukupan broj slucajeva vs ukupan broj stanovnika
--koji procenat ljudi je dobio kovid u BIH

Select Location,date,total_cases,population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like 'Bosnia and Herzegovina'
order by 1,2

Select Location,date,population,total_cases,(total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--where location like 'Bosnia and Herzegovina'
order by 1,2

--6.upit :zemlje sa najvisim stepenom zaraze u odnosu na broj stanovnika
Select Location,population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by location,population
order by PercentPopulationInfected desc   --sortira se u opadajucem poretku,  slovenija 11 u svijetu


--7.upit 
--Zemlje sa najvecim brojem smrtnih ishoda po broju stanovnika
--total_death je potrebno konvertovati u integer,pojavljuju se i kontineti u vrstama

Select Location, MAX(cast(total_deaths as int )) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Group by Location
order by  TotalDeathCount desc     

Select Location, MAX(cast(total_deaths as int )) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not null
Group by Location
order by  TotalDeathCount desc
-- sada se ne pojavljuju kontineti u vrstama


--8.upit isti kao 7. samo po kontinentima
Select Continent, MAX(cast(total_deaths as int )) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is not null  
Group by Continent
order by  TotalDeathCount desc

--9.upit
Select Location, MAX(cast(total_deaths as int )) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is  null
Group by Location
order by  TotalDeathCount desc  


--10. global numbers
Select Location,date,total_cases,population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2


Select date,SUM(new_cases)  -- sumira nove slucajeve po vrstama
From PortfolioProject..CovidDeaths$
where continent  is not null
group by date
order by 1,2    


--11.upit  procenat umrlih od ukupnog broja novozarazenih 
Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths$
where continent  is not null
group by date
order by 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths$
where continent  is not null

order by 1,2     --isto kao 11 ali bez datuma, jedan broj


--+**********************************************************************
--koristimo podatke iz tabele covidvacctination

--1.upit
--spajanje tabela , join naredba, spajanje po datumu i lokaciji

Select * 
from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date


--2.upit ukupan broj ljudi vs  ukupan broj zarazenih------
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 order by 2,3


 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location)

from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location,dea.date)
from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 order by 2,3


--ukupan broj vakcinisanih u svim drzavama

--CTE using  poput pogleda
with popVsVac(Continet,Location,Date,Population,New_Vacctions,RollingPeopleVaccinated)
as (
 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select *  
 from popVsVac

--******Temp table*********

create table #PercentagePeopleVaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePeopleVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 
 select *,(RollingPeopleVaccinated/Population)*100
 from #PercentagePeopleVaccinated





drop table if exists #PercentagePeopleVaccinated
create table #PercentagePeopleVaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)
Select Location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths$
order by 1,2

drop table if exists #PercentagePeopleVaccinated
create table #PercentagePeopleVaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePeopleVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 --where dea.continent is not null
 --order by 2,3
 
 select *,(RollingPeopleVaccinated/Population)*100
 from #PercentagePeopleVaccinated



 -- kreiranje pogleda
 Create View PercentPeopleVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
 --(RollingPeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations$ vac
 on dea.location= vac.location and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select *  
 from PercentPeopleVaccinated



