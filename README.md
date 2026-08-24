# 📍 PIC Allocation Dashboard — Spatial Clustering for Partner Allocation

> **A spatial clustering-based decision-support dashboard for optimizing Person-in-Charge (PIC) allocation based on partner geographic distribution.**

![R](https://img.shields.io/badge/R-276DC3?style=flat\&logo=r\&logoColor=white)
![Shiny](https://img.shields.io/badge/R%20Shiny-1F9E89?style=flat\&logo=rstudio\&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-3F4F75?style=flat\&logo=plotly\&logoColor=white)
![Spatial Analysis](https://img.shields.io/badge/Spatial%20Analysis-Geospatial-orange)
![Status](https://img.shields.io/badge/Status-Portfolio%20Project-success)

---

## 📌 Overview

Managing a large number of partners across multiple regions can make PIC allocation difficult, particularly when partners are geographically dispersed.

This project was developed to help identify **geographically grouped partner clusters** that can be used as a basis for determining PIC allocation.

Instead of assigning PICs only based on administrative regions, the application analyzes the **geographic distribution of partners** and groups nearby partners into clusters based on a predefined distance threshold.

The result is presented through an interactive **R Shiny dashboard** that allows users to explore partner distribution, clusters, regional summaries, and filtered data.

---

## 🎯 Business Problem

When partner locations are spread across multiple regions, PIC allocation can become inefficient if geographic proximity is not considered.

The key questions addressed by this project are:

* How are partners geographically distributed?
* Which partners are located within a reasonable operational distance?
* How can nearby partners be grouped into manageable clusters?
* How many clusters are generated within each branch?
* How can these clusters be visualized and explored interactively?

This project approaches the problem as a **spatial clustering and decision-support problem**.

---

## 💡 Solution

The application processes partner location data and performs the following workflow:

```text
Raw Partner Data
       │
       ▼
Data Cleaning & Standardization
       │
       ▼
Coordinate Extraction
       │
       ▼
Data Validation
       │
       ▼
Geographic Distance Calculation
       │
       ▼
Hierarchical Clustering
(Complete Linkage)
       │
       ▼
Cluster Assignment
       │
       ▼
Interactive Shiny Dashboard
       │
       ├── Geographic Map
       ├── KPI Summary
       ├── Cluster Filtering
       ├── Partner Search
       ├── Data Table
       └── Excel Export
```

---

## 🧠 Methodology

### 1. Data Preparation

The preprocessing pipeline performs several transformations:

* Standardizes column names
* Cleans regional names
* Cleans coordinate strings
* Converts capacity variables to numeric values
* Creates capacity categories
* Extracts latitude and longitude
* Removes records with invalid or missing coordinates

The preprocessing workflow is implemented in [`R/process.R`](R/process.R) and supported by helper functions in [`R/helper.R`](R/helper.R).

---

### 2. Geographic Distance

Partner locations are represented using:

* Latitude
* Longitude

Geographic distances are calculated using the **Haversine distance** through the `geosphere` package.

This allows the clustering process to use actual geographic distance rather than simple Euclidean distance on raw latitude/longitude values.

---

### 3. Hierarchical Clustering

The project uses:

**Hierarchical Agglomerative Clustering with Complete Linkage**

The clustering process is performed separately for each:

```text
Kanwil
  └── Kancab
       └── Partner
```

The cluster distance threshold is configurable through:

```r
RADIUS_CLUSTER <- 18
```

Therefore, the current configuration uses an **18 km clustering threshold**.

The implementation uses:

```r
hclust(
  as.dist(matriks_jarak),
  method = "complete"
)
```

and clusters are generated using the specified geographic radius.

---

## 📊 Dashboard Features

### 🗺️ Interactive Partner Map

The dashboard displays partner locations using an interactive Plotly/OpenStreetMap map.

The visualization dynamically changes its grouping level:

```text
All regions
    ↓
Kanwil
    ↓
Kancab
    ↓
Cluster
```

This makes it easier to identify geographic concentration and dispersion of partners.

---

### 📈 KPI Summary

The dashboard provides four main indicators:

* **Total Partners**
* **Total Branches (Kancab)**
* **Total Regional Offices (Kanwil)**
* **Total Clusters**

These KPIs dynamically respond to the selected filters.

---

### 🔎 Interactive Filtering

Users can filter the data by:

* Kanwil
* Kancab
* Cluster
* Partner name

This enables users to investigate the geographic distribution at different organizational levels.

---

### 📋 Data Table

The dashboard provides an interactive data table containing the filtered partner records.

Users can inspect the underlying data directly from the dashboard.

---

### 📥 Excel Export

Filtered results can be exported into an Excel file for further analysis or operational use.

---

## ⚙️ Configuration

Key parameters are centralized in:

```text
R/config.R
```

Current configuration:

| Parameter                |      Value | Description                             |
| ------------------------ | ---------: | --------------------------------------- |
| `KAPASITAS_PENGERINGAN`  | 50 ton/day | Threshold for drying capacity category  |
| `KAPASITAS_PENGGILINGAN` | 50 ton/day | Threshold for milling capacity category |
| `RADIUS_CLUSTER`         |      18 km | Geographic clustering threshold         |
| `MAX_MITRA`              |     `NULL` | Maximum partners per cluster            |
| `MAP_ZOOM`               |        3.5 | Initial map zoom                        |
| `TABLE_PAGE_LENGTH`      |         15 | Rows displayed per table page           |

The parameters can be modified without changing the core clustering logic.

---

## 🛠️ Tech Stack

### Programming Language

* **R**

### Framework

* **Shiny**

### Data Manipulation

* `dplyr`
* `tidyr`
* `purrr`
* `stringr`

### Spatial & Geographic Analysis

* `geosphere`
* Haversine distance
* Geographic coordinate analysis

### Visualization

* `plotly`
* OpenStreetMap

### Data Input & Output

* `readxl`
* `openxlsx`

### Interactive Table

* `DT`

### Additional Tools

* `ggplot2`
* `gt`
* `tidygeocoder`

---

## 📁 Project Structure

```text
dashboard_pic/
│
├── app.R
├── global.R
├── ui.R
├── server.R
│
├── R/
│   ├── config.R
│   ├── helper.R
│   └── process.R
│
├── data/
│   └── Data Dummy Mitra Indonesia.xlsx
│
├── output/
│   ├── Data Valid.xlsx
│   ├── Hasil Cluster.xlsx
│   ├── Jumlah PIC.xlsx
│   └── Report.xlsx
│
├── rsconnect/
│   └── Deployment configuration
│
└── set data dummy.ipynb
```

### Main Components

| File                   | Purpose                                                        |
| ---------------------- | -------------------------------------------------------------- |
| `app.R`                | Application entry point                                        |
| `global.R`             | Loads packages, configuration, processing functions, and data  |
| `ui.R`                 | Defines the dashboard interface                                |
| `server.R`             | Defines filtering, KPI, map, table, and export logic           |
| `R/config.R`           | Centralized project parameters                                 |
| `R/helper.R`           | Data cleaning, coordinate processing, and clustering functions |
| `R/process.R`          | Main data preprocessing and clustering pipeline                |
| `data/`                | Input dataset                                                  |
| `output/`              | Generated analysis outputs                                     |
| `set data dummy.ipynb` | Notebook for generating dummy data                             |

---

## 🚀 How to Run

### 1. Clone the repository

```bash
git clone https://github.com/Julfasmi/dashboard_pic.git
cd dashboard_pic
```

### 2. Install required packages

Run the following in R:

```r
packages <- c(
  "shiny",
  "dplyr",
  "plotly",
  "DT",
  "openxlsx",
  "readxl",
  "ggplot2",
  "geosphere",
  "stringr",
  "tidyr",
  "purrr",
  "gt",
  "tidygeocoder"
)

install.packages(packages)
```

### 3. Run the application

Open `app.R` in RStudio or Positron and run:

```r
shiny::runApp()
```

---

## 📌 Example Use Case

Suppose an organization has hundreds or thousands of partners distributed across multiple branches.

Instead of manually determining which partners should be handled by the same PIC, the application can:

1. Validate partner location data.
2. Calculate geographic distances.
3. Group geographically close partners.
4. Generate cluster identifiers.
5. Summarize the number of clusters by branch.
6. Visualize the resulting groups on an interactive map.
7. Export filtered results for operational follow-up.

This transforms raw geographic partner data into a more structured **decision-support output**.

---

## ⚠️ Data & Privacy

The repository uses **dummy/synthetic partner data** for demonstration and portfolio purposes.

No confidential operational partner data should be committed to this repository.

If the application is adapted for real operational use, sensitive partner information should be stored separately and access should be properly controlled.

---

## 🔍 Current Limitations

The current implementation is intended primarily as a **decision-support prototype**.

Some limitations include:

* Clustering depends on the accuracy of latitude/longitude data.
* The clustering threshold is manually configured.
* The current clustering process is based primarily on geographic proximity.
* `MAX_MITRA` is currently configurable but disabled (`NULL`).
* Capacity categories are generated during preprocessing but are not currently used as an active filtering condition.
* The number of PICs is represented through the resulting number of clusters and does not yet incorporate additional operational constraints such as workload, travel time, employee availability, or service capacity.

These limitations provide opportunities for further development.

---

## 🚧 Future Improvements

Potential improvements include:

* [ ] Integrate road-network distance instead of straight-line geographic distance.
* [ ] Incorporate estimated travel time.
* [ ] Add maximum partner capacity per PIC.
* [ ] Incorporate workload balancing between PICs.
* [ ] Add optimization-based PIC allocation.
* [ ] Add historical partner activity or transaction volume.
* [ ] Add automated geocoding for missing coordinates.
* [ ] Add cluster quality evaluation.
* [ ] Add scenario analysis for different clustering radii.
* [ ] Improve dashboard UI/UX and reporting.
* [ ] Add automated data refresh pipelines.

---

## 📈 Project Value

This project demonstrates practical application of:

**Data Cleaning → Geospatial Analysis → Clustering → Interactive Visualization → Decision Support**

It combines analytical methodology with an operational dashboard, making the output more accessible to non-technical users.

---

## 👤 Author

**Julfasmi Hi. M. Nasir**

Data Scientist | Data Analyst | Analytics & Automation Enthusiast

* 📍 Indonesia
* 🐙 GitHub: [@Julfasmi](https://github.com/Julfasmi)
* 🌐 Portfolio: [Analytics Portfolio](https://analytics-portfolio-display.vercel.app/)

---

## ⭐ If you find this project useful

Feel free to explore the repository, review the methodology, or adapt the approach for other geographic allocation and clustering problems.
