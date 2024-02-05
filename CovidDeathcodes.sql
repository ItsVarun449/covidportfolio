SELECT *
FROM CovidDeaths

SELECT date, new_cases, new_deaths
FROM CovidDeaths


--Total Cases vs Total Population of India
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS 'Infected Percentage'
FROM CovidDeaths
WHERE location = 'India'
ORDER BY 1,2;

--Total Cases vs Total Population of Global
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS 'Infected Percentage'
FROM CovidDeaths
ORDER BY 1,2;

--Countries with Highest infection rate in Percentage
SELECT location, population, MAX(total_cases) AS 'Total Infected', MAX((total_cases/population)) * 100 AS 'Infected Percentage'
FROM CovidDeaths
GROUP BY location, population
ORDER BY 'Infected Percentage' DESC

--Showing Countries with highest Death rate in Percentage
SELECT location, population, MAX(CONVERT(INT, total_deaths)) AS 'Total Death Count', MAX((total_deaths/population)) * 100 AS 'Death Percentage'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 'Death Percentage' DESC;

--Showing Continent's with highest Death rate in Percentage
SELECT location AS 'Continent' , MAX(CONVERT(INT, total_deaths)) AS 'Total Death Count', MAX((total_deaths/population)) * 100 AS 'Death Percentage'
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY 'Death Percentage' DESC;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(CONVERT(INT, new_deaths)) AS 'Total Deaths', SUM(CONVERT(INT, new_deaths))/ SUM(new_cases)*100 AS 'Death Percentage'
FROM CovidDeaths
WHERE continent IS NOT NULL;

--GLOBAL NUMBERS as per date

SELECT date, SUM(CONVERT(INT, total_deaths)) AS 'Total Death Globally'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

--GLOBAL NUMBERS as per date with new cases and new deaths

SELECT date, SUM(new_cases) AS 'New Cases', SUM(CONVERT(INT, new_deaths)) AS 'New Deaths', SUM(CONVERT(INT, new_deaths))/SUM(new_cases) * 100 AS 
'Death in Percentage'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

--Death Percentage Accross the world
SELECT SUM(new_cases) AS 'New Cases', SUM(CONVERT(INT, new_deaths)) AS 'New Deaths', SUM(CONVERT(INT, new_deaths))/SUM(new_cases) * 100 AS 
'Death in Percentage'
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

SELECT *
FROM CovidDeaths

SELECT *
FROM CovidVaccinations

-- joining covidDeaths table with Covid vaccination table

SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 1 DESC;

-- Looking for Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Rolling People Vaccinated'
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2, 3;

--use CTE to find the percentage of particular country being vaccinated
WITH PopsvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Rolling People Vaccinated'
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS 'Percentage of Vaccinated people'
FROM PopsvsVac
WHERE Location = 'India'

-- CREATE A TEMP TABLE
DROP Table IF exists #PerccentPopulationVaccinated
CREATE TABLE #PerccentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated NUMERIC,
)

INSERT INTO #PerccentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Rolling People Vaccinated'
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/Population)*100 AS 'Percentage of Vaccinated people'
FROM #PerccentPopulationVaccinated

--CREATE VIEW

CREATE VIEW PercentaPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Rolling People Vaccinated'
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL