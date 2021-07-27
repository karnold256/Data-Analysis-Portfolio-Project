use coviddata;

show tables;

select * from covid_deaths;

select * from coviddata;

select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths
where continent is not null;



#looking at total cases vs looking at total deaths
select location, sum(total_deaths) as total_of_deaths, sum(total_cases) as total_of_cases
from covid_deaths where location = "Africa";

select location, sum(total_deaths) as total_of_deaths, sum(total_cases) as total_of_cases
from covid_deaths where location = "Europe";

select location, sum(total_deaths) as total_of_deaths, sum(total_cases) as total_of_cases
from covid_deaths where location = "Afghanistan";


select location, date, (total_deaths / total_cases) * 100 as death_percent
from covid_deaths
where continent is not null;

select location, date, (total_deaths / total_cases) * 100 as death_percent
from covid_deaths where location like '%states%';

#looking at total cases vs population
select location, date, total_cases, population, (total_cases/covid_deaths.population) * 100 as death_percent
from covid_deaths
where location like 'Africa';

#countries with the highest infection rates grouped by location and population
select location, population, MAX(total_cases) as HighestInfectionRate, MAX((total_cases / covid_deaths.population)) * 100 as
infection_rate_percentage
from covid_deaths
where continent is not null
group by location, population
order by HighestInfectionRate DESC;

#highest death count per population
select location, MAX(total_deaths) as TotalDeathCount
from covid_deaths
where continent is not null
group by location
order by TotalDeathCount DESC
;

#breaking down the total of deaths by continent
select continent, MAX(total_deaths) as TotalDeathCount
from covid_deaths
where continent is not null
group by continent
order by TotalDeathCount DESC
;

#total number of cases divided by the deaths inn order to get the percentage
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
SUM(new_deaths) / SUM(new_cases) * 100 as DeathPercentage
from covid_deaths
where continent is not null
order by 1,2
;

#looking at the total vaccination  verses the total number of population using the inner join
select *
from covid_deaths death
inner join coviddata vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
order by 1,2,3;

#inner join to get the number of people vaccinated in each location
select *
from covid_deaths death
inner join coviddata vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null and vaccine.people_vaccinated is not null
order by 1,2,3;


#selecting with specific columns in order to get the required data
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, vaccine.people_vaccinated
from covid_deaths death
inner join coviddata vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null and vaccine.new_vaccinations is not null
order by vaccine.date;

#new vaccinations per country using the sum of new vaccinations
select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations
, SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location)
from covid_deaths death
inner join coviddata vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
order by 2, 3;