SELECT *
FROM portfolioproject.dbo.coviddeath
Where continent is Not Null
ORDER by 3,4

--SELECT *
--FROM portfolioproject..covidvaccinations
--Order by 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..coviddeath
Order by 1,2


-- Looking at the Total Cases vs Total Deaths
-- Shows probability of dying if one contact covid in africa

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 As DeathPercentage
FROM portfolioproject..coviddeath
Where location like '%africa%'
Order by 1,2

--Looking at the Total Cases vs the Population
-- Shows what percentage of population that got covid

SELECT Location, date, total_cases, population, (total_cases/population) * 100 As PercentagePopulationInfected
FROM portfolioproject..coviddeath
-- Where location like '%africa%'
Order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, population, MAX(total_cases) As HighestInfectionCount, MAx ((total_cases/population)) * 100 As PercentagePopulationInfected
FROM portfolioproject..coviddeath
Group by Location, Population
Order by PercentagePopulationInfected desc

-- Showing Countries with Highest Death Count per Population


SELECT Location, MAX (cast(Total_deaths as int)) As TotalDeathCount
FROM portfolioproject..coviddeath
Where continent Is Not NUll
Group by Location
Order by TotalDeathCount desc

-- Let's Break things down by Continent


SELECT continent, MAX (cast(Total_deaths as int)) As TotalDeathCount
FROM portfolioproject..coviddeath
Where continent Is not NUll
Group by continent
Order by TotalDeathCount desc

-- Showing the contitnent with the highest death per population

SELECT continent, MAX (cast(Total_deaths as int)) As TotalDeathCount
FROM portfolioproject..coviddeath
Where continent Is not NUll
Group by continent
Order by TotalDeathCount desc

-- Global Numbers


SELECT SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/
SUM(new_cases) * 100 As DeathPercentage
FROM portfolioproject..coviddeath
Where continent is not null
--Group by date
Order by 1,2


-- Looking at Total Population vs new_cases

Select dea.continent, dea.location, dea.date, dea.population, dea.new_cases
, SUM(CONVERT(int,dea.new_cases)) OVER (Partition by dea.Location order by dea.location,
dea.date) as RolllingPeopleContacted
From portfolioproject..coviddeath dea
Join portfolioproject..covidvaccinations vac
	ON  dea.location = vac.location	
	And dea.date = vac.date
Where dea.continent is not null
order by 1, 2, 3


-- Use CTE

With PopvsNew (Continent, Location, Date, Population, New_cases, Rollingpeoplecontacted)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, dea.new_cases,
SUM(CONVERT(int,dea.new_cases)) OVER (Partition by dea.Location order by dea.location,
dea.date) as RolllingPeopleContacted
From portfolioproject..coviddeath dea
Join portfolioproject..covidvaccinations vac
	ON  dea.location = vac.location	
	And dea.date = vac.date
Where dea.continent is not null
)

Select *, (Rollingpeoplecontacted/population) * 100
From PopvsNew



