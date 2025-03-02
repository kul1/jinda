# README: Syntax Token Extraction for Rails Applications

## Overview
This document provides an explanation of how the dataset `rails_syntax_tokens_categorized.csv` was collected. The dataset consists of syntax tokens extracted from a Ruby on Rails application repository and categorized by file type. It enables statistical analysis of syntax frequency distributions across different programming languages used in Rails applications.

## Data Collection Process

### Data Source
The dataset was collected from an open-source **Ruby on Rails application repository** hosted on GitHub.

### File Types Included
The dataset includes syntax tokens extracted from commonly used Rails file types:
- **Backend:** Ruby files (`.rb`)
- **Frontend:** JavaScript (`.js, .jsx`), HTML-embedded Ruby (`.erb`), and CSS (`.css, .scss`)
- **Configuration:** YAML files (`.yml`)

### Data Extraction Methodology
The dataset was collected through an **automated token extraction process** leveraging Python-based tools. The extraction methodology followed these structured steps:

1. **Scanning Project Files**
   - Identified and retrieved relevant source code files from the repository.

2. **Token Extraction**
   - **Abstract Syntax Tree (AST) Parsing**: Used for extracting structured syntax tokens from Ruby (`.rb`) files.
   - **Ripper Library**: Applied for detailed Ruby-specific syntax tokenization.
   - **Regular Expressions (Regex)**: Used for token extraction from JavaScript, HTML, CSS, and YAML files.

3. **Categorization**
   - Each extracted token was assigned to its respective file type.
   - Categorization ensured differentiation between **backend, frontend, and configuration files**.

4. **Frequency Calculation**
   - Counted the occurrence of each syntax token within its respective file type.

5. **Data Storage**
   - The structured dataset was stored in CSV format as `rails_syntax_tokens_categorized.csv`.
   - Each row in the CSV file represents a **syntax token, its frequency, and its corresponding file type**.

## Dataset Summary
- **Total Syntax Tokens Extracted:** 8,482 unique tokens
- **Total Lines of Code Analyzed:** 27,860
- **Output Format:** CSV file containing columns:
  - `Token`: The extracted syntax token (e.g., keywords, function names, class definitions)
  - `Count`: The frequency of the token’s occurrence in the dataset
  - `Category`: The file type classification (Ruby, JavaScript, HTML, CSS, YAML)

## Citation and Usage
This dataset is used as a reference in statistical analysis reports to study **syntax frequency distributions** in Ruby on Rails applications. For proper citation, please refer to:

> **"Syntax Token Extraction for Rails Applications, Open-Source Repository Dataset, 2025."**

For questions or further contributions, visit the GitHub repository or contact the dataset maintainers.
