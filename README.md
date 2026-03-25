# ✈️ AeroAudit : Global Aviation Data Analytics
Aviation Data Analytics using SQL &amp; Power BI

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![Azure Maps](https://img.shields.io/badge/Azure%20Maps-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

A deep-dive audit of **90,000+ global flight routes**, uncovering hidden data gaps and "ghost" aircraft codes using PostgreSQL and an interactive Power BI dashboard.

---

## 📖 Overview

Many global flight databases are messier than they look. When I cross-referenced flight routes against a master aircraft registry, I discovered a major gap: **14,513 routes** referenced codes the system didn't recognize — real flights happening every day, invisible to analytics.

I call these **"Ghost Flights."**

---

## 🔍 Key Findings

| Metric | Value |
|---|---|
| Total Routes Audited | 90,000+ |
| Ghost Code Routes | 14,513 |
| Data Integrity Gap | ~18% |
| Most Common Ghost Code | `73H` → Boeing 737-800 with Winglets |

> **The "73H" Discovery:** The most frequent ghost code turned out to belong to the Boeing 737-800 with Winglets — hidden simply because the lookup table wasn't updated. A textbook case of *data decay* in open-source registries.

---

## 🛠️ Tools & Stack

| Tool | Purpose |
|---|---|
| **PostgreSQL** | Data cleaning, joins, and extraction from messy CSV imports |
| **Power BI + DAX** | Interactive audit dashboard with custom classification logic |
| **Azure Maps** | Geographic visualization of ghost flight distribution |

---

## 📊 Dashboard Features

- **🗺️ Global Map** — Every route color-coded as `✅ Verified` or `🚨 Ghost Code`
- **📊 Aircraft Breakdown** — Bar chart of the most common plane models vs. unknowns
- **🔎 Smart Search** — Slicer by airline code (e.g., `6E` for IndiGo, `AI` for Air India)
- **👻 Ghost Counter** — Live-updating card showing missing codes in the current view

---

## ⚙️ Technical Implementation

### 1. SQL Extraction Layer (PostgreSQL)

The raw dataset arrived as an unstructured CSV with missing and non-standard aircraft equipment codes. Key engineering decisions:

- **`COALESCE` for Data Triage** — Caught missing aircraft descriptions at import and labeled them `"Unknown (Code)"` to prevent NULL values from breaking downstream visuals.
- **`LEFT JOIN` for Relational Mapping** — Joined the global routes table against the `aircraft_lookup` reference table to surface the 18% data gap.
- **Unnesting Multi-Equipment Routes** — Handled routes with multiple aircraft types to ensure every route was counted exactly once in the final output.

### 2. Power BI Auditing Logic (DAX)

Custom logic was built to go beyond standard visuals:

- **Dynamic Status Classification** — A calculated column that segments all 90,000+ rows in real time:

```dax
Data Status =
IF(
    CONTAINSSTRING('public simplified_routes'[Aircraft Model], "Unknown"),
    "🚨 Ghost Code",
    "✅ Verified"
)
```

- **Search-Enabled Airline Slicer** — Allows rapid auditing of any carrier to measure their specific data health.

### 3. The "73H" Ghost — Root Cause Analysis

| | Detail |
|---|---|
| **The Bug** | Open-source database flagged `73H` as `"Unknown"` |
| **The Cause** | Lookup table not updated with newer IATA codes |
| **The Fix** | Identified `73H` as the IATA code for Boeing 737-800 with Winglets |
| **The Lesson** | *Data Decay* is a systemic issue in open-source aviation registries |

---

## 🗂️ Repository Structure

```
├── source/        # Source Data
├── data/          # Cleaned CSV files
├── sql/           # PostgreSQL scripts for data cleaning & joins
└── *.pbix         # Power BI dashboard file
```

---

## 🚀 Getting Started

1. Clone the repo and navigate to `data/` for the cleaned CSV files.
2. Review `sql/` to see the data cleaning and join scripts.
3. Open the `.pbix` file in Power BI Desktop to explore the dashboard interactively.

---

## 🗺️ Roadmap (v2.0)

- [ ] **Auto-Fix** — Apply a custom patch table to automatically resolve all 14,513 ghost codes
- [ ] **Fuel Analysis** — Estimate fuel savings attributable to misclassified efficient aircraft (e.g., 73H)
- [ ] **Live Data** — Connect the dashboard to a real-time flight-tracking API

---

## 📜 License

This project is open source. Feel free to fork, explore, and build on it.
