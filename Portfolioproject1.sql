--SELECT *
--FROM CovidDeaths
--ORDER BY 3, 4

--SELECT *
--from CovidVaccinations

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

-- TotalCases vs TotalDeaths INDIA
-- The rough Estimate for death in India was 1.1% By April 2021
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS 'Death in Percentage'
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'India' 

-- Looking at the Total cases vs Population

SELECT location, date, total_cases, population, (total_cases/population)*100 AS 'Infected Percentage'
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'India'
ORDER BY 1, 2

--Looking at countries with highest infection rate among population
-- you can use 2 methods given below

SELECT location, population, MAX(total_cases) AS 'Highest Cases', MAX((total_cases/population))*100 AS 'Percentage of Infected Population'
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

SELECT location, population, MAX(total_cases) AS 'Highest Cases', MAX((total_cases/population))*100 AS 'Percentage of Infected Population'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 'Percentage of Infected Population' DESC

--Looking at a specific country with Population infected

SELECT location, population, MAX(total_cases) AS 'Highest Cases', MAX((total_cases/population))*100 AS 'Percentage of Infected Population'
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'India'
GROUP BY location, population

--Showing countries Highest Death counts as population
--Use CAST if there is '(nvarchar(255),null)' in your selected column like in this case it is in 'total_deaths'
SELECT location, MAX(CAST(total_deaths AS int)) AS 'Highest Deaths', MAX((total_deaths/population))*100 AS 'Highest Percentage Death among population'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

--Showing the continents with highest death count per population by keeping continent is not null given below

SELECT location, MAX(cast(total_deaths AS int)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 'Total Death Count' DESC

-- If the continent is null
SELECT location, MAX(cast(total_deaths AS int)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location
ORDER BY 'Total Death Count' DESC

--BREAKING THINGS DOWN BY CONTINENT

SELECT location, MAX(cast(total_deaths AS int)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location
ORDER BY 'Total Death Count' DESC

--BREAKING THINGS DOWN BY CONTINENT IS NULL
SELECT continent, MAX (CAST(total_deaths as INT)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NULL
GROUP BY continent

--BREAKING THINGS DOWN BY CONTINENT IS NOT NULL
SELECT continent, MAX (CAST(total_deaths as INT)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent

--SHOWING THE CONTINENTS WITH HIGHEST DEATH COUNTS

SELECT continent, MAX (CAST(total_deaths as INT)) AS 'Total Death Count'
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Total Death Count' DESC0

-- BREAKING GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS 'NEW CASES', SUM(CAST(new_deaths AS INT)) 'NEW DEATHS' --(total_deaths/total_cases)*100 AS 'Death in Percentage'
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location LIKE '%states' AND 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2 

--Demo to check the upper code
SELECT date, location, new_cases, new_deaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE date = '2020-02-02'

-- BREAKING GLOBAL NUMBERS in death percentage

SELECT date, SUM(new_cases) AS 'NEW CASES', SUM(CAST(new_deaths AS INT)) 'NEW DEATHS', SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS 'Death Percentage'
FROM PortfolioProject.dbo.CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2
