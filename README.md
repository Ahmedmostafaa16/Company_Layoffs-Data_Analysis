# Company Layoffs (Data Cleaning)
This project focuses on cleaning and standardizing a dataset related to company layoffs. The process involves removing duplicates, standardizing data formats, and filling missing values. Below are the detailed steps involved in the data cleaning process:

1. **Removing Duplicates**: 
   - A new table with an additional column `row_num` is created to track the occurrences of each record. 
   - Records with a `row_num` value greater than 1 are identified as duplicates and are deleted.

2. **Standardizing Data**:
   - **Company Names**: Leading and trailing spaces are removed using the `TRIM()` function.
   - **Locations**: Misspelled locations are corrected.
   - **Industry Names**: Standardize names, particularly for the crypto industry.
   - **Dates**: Convert date strings to date data type.
   - **Countries**: Remove trailing periods from country names.

3. **Handling Missing Values**:
   - Missing industry values are populated based on other records from the same company.
   - Rows with both `total_laid_off` and `percentage_laid_off` as `NULL` are deleted as they don't provide meaningful data.

4. **Final Cleanup**:
   - Drop the `row_num` column as it is no longer needed.

By following these steps, the dataset is cleaned and standardized, making it more reliable and ready for further analysis.


# Company Layoffs (Exploratory Data Analysis)

This project involves detailed data exploration of a company layoffs dataset to uncover key insights and trends. The main areas of exploration include:

- **Temporal Trends**:
  - **Time Frame**: Determined the overall time span of the layoffs.
  - **Trend Analysis**: Analyzed monthly, quarterly, and yearly layoff trends, and calculated rolling layoffs over time.

- **Geographical Trends**:
  - **Country Analysis**: Identified countries with the highest number of layoffs and examined how layoff trends vary by country over time.

- **Industry Analysis**:
  - **Impact Assessment**: Determined which industries were most affected by layoffs.
  - **Layoff Ranking**: Ranked industries based on the percentage of layoffs each year.
  - **Temporal Trends by Industry**: Analyzed how layoff trends differ across various industries over time.

- **Company Analysis**:
  - **Company Impact**: Identified companies with the highest number of layoffs and those that completely shut down.
  - **Stage Analysis**: Determined which company stages are more prone to layoffs.
  - **Top Companies**: Ranked the top five companies with the highest number of layoffs each year.

This exploration provided comprehensive insights into the temporal, geographical, and industry-specific patterns of layoffs, facilitating a deeper understanding of the underlying trends and impacts.
