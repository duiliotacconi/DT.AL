# BC27 Performance Features Demo# BC27 Performance Features Demo# BC27 Performance Features Demo



![Business Central](https://img.shields.io/badge/Business%20Central-27.0-blue) ![AL Language](https://img.shields.io/badge/AL-Runtime%2016.0-green) ![License](https://img.shields.io/badge/License-MIT-orange)



A comprehensive demonstration extension showcasing the new performance features introduced in **Microsoft Dynamics 365 Business Central 2025 Wave 2 (Version 27)**.![Business Central](https://img.shields.io/badge/Business%20Central-27.0-blue)This AL extension demonstrates the new performance features introduced in Microsoft Dynamics 365 Business Central 27 (2025 Wave 2).



## 🎯 Overview![AL Language](https://img.shields.io/badge/AL-Runtime%2016.0-green)



This AL extension provides hands-on demonstrations of six major performance improvements:![License](h| Language | Code | Status | Translations |

|----------|------|--------|--------------|

| Category | Features | Count || 🇬🇧 English | en-US | Source | 206 |

|----------|----------|-------|| 🇸🇦 Arabic | ar-SA | ✅ Complete | 206 |

| 🔄 **Application** | Posting Order, SQL Calls in Profiler | 2 || 🇮🇹 Italian | it-IT | ✅ Complete | 206 |

| 👨‍💻 **Developer** | LockTimeout, Sequential GUID, Rec.Truncate | 3 || 🇩🇪 German | de-DE | ✅ Complete | 206 |

| ⚡ **SQL Optimization** | Optimized FlowField Calculations | 1 || 🇪🇸 Spanish | es-ES | ✅ Complete | 206 |

| 🇩🇰 Danish | da-DK | ✅ Complete | 206 |

## 📁 Project Structure

All user-facing text uses AL Labels for proper translation support..shields.io/badge/License-Educational-orange)## Overview

```

src/

├── 01-PostingOrder/                    # Improved posting sequence optimization

├── 02-SQLCallsInPerformanceProfiler/   # SQL visibility in Performance ProfilerA comprehensive demonstration extension showcasing the new performance features introduced in **Microsoft Dynamics 365 Business Central 2025 Wave 2 (Version 27)**.This project showcases six major performance improvements across different areas:

├── 03-LockTimeout/                     # Database lock timeout handling

├── 04-GuidCreateSequentialGuid/        # Sequential GUID generation for better indexing- **Application Features** (2): Posting Order, SQL Calls in Performance Profiler

├── 05-RecTruncate/                     # Fast table truncation method

├── 06-OptimizedFlowFieldCalculations/  # Enhanced FlowField performance with SetAutoCalcFields## 🎯 Overview- **Developer Features** (3): LockTimeout, Guid.CreateSequentialGuid, Rec.Truncate

└── DTBC27PerformanceFeatures.Page.al   # Main demo launcher page

```- **Server Team Features** (1): Optimized FlowField Calculations



## ✨ FeaturesThis AL extension provides hands-on demonstrations of six major performance improvements:



### 1. 🔄 Posting Order Optimization## Project Structure



**Location**: `src/01-PostingOrder/`| Category | Features | Count |



BC 27 introduces significant posting order improvements in Codeunits 80 and 90:|----------|----------|-------|```

- Uses `SetCurrentKey(Type, "Line No.")` to sort lines by Type first

- Reduces the probability of locks through consistent posting sequence| 🔄 **Application** | Posting Order, SQL Calls in Profiler | 2 |src/

- Improves SQL execution plans

| 👨‍💻 **Developer** | LockTimeout, Sequential GUID, Rec.Truncate | 3 |├── 01-PostingOrder/          # Improved posting sequence

**Demo**: Creates a sales order with 10 mixed-type lines (Item, G/L Account, Resource) in random order. Event subscribers display the optimized posting sequence showing BC 27's improvements.

| ⚡ **SQL Optimization** | Optimized FlowField Calculations | 1 |├── 02-SQLCallsInPerformanceProfiler/  # SQL call visibility in profiler

**Benefits**: ⚡ Faster posting times, 🔒 Reduced lock probability, 📊 Better SQL performance

├── 03-LockTimeout/                    # Database lock timeout handling

---

## 📁 Project Structure├── 04-GuidCreateSequentialGuid/       # Sequential GUID generation

### 2. 🔍 SQL Calls in Performance Profiler

├── 05-RecTruncate/                    # Fast table truncation

**Location**: `src/02-SQLCallsInPerformanceProfiler/`

```├── 06-OptimizedFlowFieldCalculations/ # Enhanced FlowField performance

The enhanced Performance Profiler now captures detailed SQL call information:

- View SQL statements executedsrc/└── BC27PerformanceFeatures.Page.al    # Main demo page

- Analyze execution times and row counts

- Download `.alcpuprofile` files for VS Code analysis├── 01-PostingOrder/                    # Improved posting sequence optimization```



**Demo**: Executes various database operations while profiling SQL interactions.├── 02-SQLCallsInPerformanceProfiler/   # SQL visibility in Performance Profiler



**Resources**:├── 03-LockTimeout/                     # Database lock timeout handling## Features Demonstrated

- 📖 [Microsoft Learn Documentation](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/view-sql-call-information-performance-profiles)

- 📝 [LinkedIn Article](https://www.linkedin.com/pulse/unlocking-sql-call-insights-performance-profiler-business-saallvi-blkpc/)├── 04-GuidCreateSequentialGuid/        # Sequential GUID generation for better indexing



---├── 05-RecTruncate/                     # Fast table truncation method### 1. Posting Order (Application)



### 3. ⏱️ LockTimeout Management├── 06-OptimizedFlowFieldCalculations/  # Enhanced FlowField performance with SetAutoCalcFields- **Files**: 



**Location**: `src/03-LockTimeout/`└── DTBC27PerformanceFeatures.Page.al   # Main demo launcher page  - `src/01-PostingOrder/DT.PostingDemo.Codeunit.al`



Improved database lock timeout handling with `Database.LockTimeoutDuration`:```  - `src/01-PostingOrder/DT.PostingOrderSubscriber.Codeunit.al`

- Automatic retry mechanisms

- Configurable timeout durations- **Description**: BC 27 optimizes the order in which document lines are posted in Codeunit 80 "Sales-Post" and Codeunit 90 "Purch.-Post". The posting routines now use `SetCurrentKey(Type, "Line No.")` to sort lines by Type first, then by Line No., improving posting performance by reducing the probability of deadlocks through consistent posting sequence and optimizing SQL execution plans.

- Better concurrency handling

## ✨ Features- **Demo**: Creates a sales order with 10 lines of mixed types (Item, G/L Account, Resource) in random order. When posted, an event subscriber shows how BC 27 sorts and posts the lines by Type first, demonstrating the optimization.

**Demo**: Demonstrates lock timeout scenarios and proper handling patterns.

- **Demo**: Creates and posts multiple item journal lines to show improved posting sequence

**Resource**: 📖 [Yzhums Blog - LockTimeout](https://yzhums.com/67858/)

### 1. 🔄 Posting Order Optimization- **Benefits**: Reduced deadlock probability, faster posting times

---



### 4. 🆔 Sequential GUID Generation

**Location**: `src/01-PostingOrder/`### 2. SQL Calls in Performance Profiler (Application)

**Location**: `src/04-GuidCreateSequentialGuid/`

- **File**: `src/02-SQLCallsInPerformanceProfiler/SQLCallsProfilerDemo.Codeunit.al`

New `Guid.CreateSequentialGuid()` method for database-friendly GUID generation:

- Sequential values improve database indexingBC 27 introduces significant posting order improvements in Codeunits 80 and 90:- **Description**: Enhanced Performance Profiler now shows detailed SQL call information

- Better clustered index performance

- Reduced page splits and fragmentation- Uses `SetCurrentKey(Type, "Line No.")` to sort lines by Type first- **References**: 



**Demo**: Performance comparison between standard GUIDs and sequential GUIDs with measurable metrics.- Reduces the probability of deadlocks through consistent posting sequence  - [Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/view-sql-call-information-performance-profiles)



**Benefits**: 📈 Better index performance, 💾 Reduced fragmentation, ⚡ Faster queries- Improves SQL execution plans  - [LinkedIn Article](https://www.linkedin.com/pulse/unlocking-sql-call-insights-performance-profiler-business-saallvi-blkpc/)



---- **Demo**: Executes various SQL operations that can be monitored in the Performance Profiler



### 5. 🗑️ Rec.Truncate() Method**Demo**: Creates a sales order with 10 mixed-type lines (Item, G/L Account, Resource) in random order. Event subscribers display the optimized posting sequence showing BC 27's improvements.- **Benefits**: Better debugging, performance optimization insights



**Location**: `src/05-RecTruncate/`



Fast table cleanup using the new `Rec.Truncate()` method:**Benefits**: ⚡ Faster posting times, 🔒 Reduced deadlock probability, 📊 Better SQL performance### 3. LockTimeout (Developer)

- Dramatically faster than `DeleteAll()` for large datasets

- SQL TRUNCATE TABLE under the hood- **File**: `src/03-LockTimeout/LockTimeoutDemo.Codeunit.al`

- Includes important usage restrictions

---- **Description**: Improved handling of database lock timeouts with automatic retry mechanisms

**Demo**: Side-by-side performance comparison between `DeleteAll()` and `Truncate()` with timing metrics.

- **References**: [Yzhums Blog](https://yzhums.com/67858/)

**Important**: CodeCop rule AA0475 enforces proper usage:

- ❌ Cannot use on system tables or tables with media fields### 2. 🔍 SQL Calls in Performance Profiler- **Demo**: Shows lock timeout scenarios and proper handling techniques

- ❌ Cannot use inside try functions

- ❌ Does not trigger OnDelete events- **Benefits**: More robust applications, better concurrency handling



**Resources**:**Location**: `src/02-SQLCallsInPerformanceProfiler/`

- 📖 [Yzhums Blog](https://yzhums.com/67343/)

- 📖 [Stefano Demiliani Blog](https://demiliani.com/2025/08/04/dynamics-365-business-central-finally-well-have-truncate-table-in-saas/)### 4. Guid.CreateSequentialGuid (Developer)

- 📖 [MS Dynamics Blog](https://msdynamicsblogs.com/uncategorized/faster-data-cleanup-in-business-central-2025-wave-2-bc27-with-the-new-rec-truncate-method/)

The enhanced Performance Profiler now captures detailed SQL call information:- **File**: `src/04-GuidCreateSequentialGuid/SequentialGuidDemo.Codeunit.al`

---

- View SQL statements executed- **Description**: New method that creates sequential GUIDs, more performant for database indexing

### 6. ⚡ Optimized FlowField Calculations

- Analyze execution times and row counts- **Demo**: Compares performance between standard GUIDs and sequential GUIDs

**Location**: `src/06-OptimizedFlowFieldCalculations/`

- Download `.alcpuprofile` files for VS Code analysis- **Benefits**: Better database performance when GUIDs are used in table keys

BC 27's `SetAutoCalcFields()` dramatically improves FlowField performance:

- Batches multiple FlowField calculations together

- Reduces SQL roundtrips from N to 1

- Optimized GROUP BY queries**Demo**: Executes various database operations while profiling SQL interactions.### 5. Rec.Truncate (Developer)



**Demo**:- **File**: `src/05-RecTruncate/RecTruncateDemo.Codeunit.al`

1. Creates 1,000 customers with 20-120 sales entries each

2. Uses `SetAutoCalcFields()` for automatic calculation**Resources**:- **Description**: New method for fast table data cleanup, more efficient than DeleteAll

3. Displays SQL query analysis with execution metrics

4. Shows performance improvements vs. individual `CalcFields()` calls- 📖 [Microsoft Learn Documentation](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/view-sql-call-information-performance-profiles)- **References**: 



**Code Example**:- 📝 [LinkedIn Article](https://www.linkedin.com/pulse/unlocking-sql-call-insights-performance-profiler-business-saallvi-blkpc/)  - [Yzhums Blog](https://yzhums.com/67343/)

```al

Customer.SetAutoCalcFields("No. of Sales Entries", "Last Sales Date");  - [Demiliani Blog](https://demiliani.com/2025/08/04/dynamics-365-business-central-finally-well-have-truncate-table-in-saas/)

if Customer.FindSet() then

    repeat---  - [MS Dynamics Blog](https://msdynamicsblogs.com/uncategorized/faster-data-cleanup-in-business-central-2025-wave-2-bc27-with-the-new-rec-truncate-method/)

        // All FlowFields calculated automatically - no CalcFields() needed!

    until Customer.Next() = 0;- **Demo**: Performance comparison between DeleteAll and Truncate methods

```

### 3. ⏱️ LockTimeout Management- **CodeCop Rule**: AA0475 - Ensures Truncate is only used on appropriate tables

**Benefits**: 🚀 Dramatically faster reports, 📉 Reduced SQL load, 💰 Lower resource consumption

- **Benefits**: Dramatically faster data cleanup for large tables

---

**Location**: `src/03-LockTimeout/`

## 🚀 Getting Started

### 6. Optimized FlowField Calculations (Server Team)

### Prerequisites

Improved database lock timeout handling with `Database.LockTimeoutDuration`:- **Files**: 

- **Business Central**: Version 27.0 or later (2025 Wave 2)

- **Development Environment**: VS Code with AL Language extension- Automatic retry mechanisms  - `src/06-OptimizedFlowFieldCalculations/DT.FlowFieldOptimizationDemo.Codeunit.al`

- **Runtime**: Version 16.0 or higher

- Configurable timeout durations  - `src/06-OptimizedFlowFieldCalculations/DT.CustomerWithFlowFields.Table.al`

### Installation

- Better concurrency handling  - `src/06-OptimizedFlowFieldCalculations/DT.SalesEntryForFlowFields.Table.al`

1. **Clone the repository**

   ```bash  - `src/06-OptimizedFlowFieldCalculations/DT.SQLQueryLog.Table.al`

   git clone https://github.com/duiliotacconi/DT.AL.git

   cd BC27-Performance-Features**Demo**: Demonstrates lock timeout scenarios and proper handling patterns.  - `src/06-OptimizedFlowFieldCalculations/DT.SQLQueryLog.Page.al`

   ```

- **Description**: BC 27 dramatically improves FlowField calculation performance using `SetAutoCalcFields()` for automatic calculations. This optimization reduces SQL roundtrips by batching multiple FlowField calculations together, resulting in significantly faster data processing.

2. **Open in VS Code**

   ```bash**Resource**: 📖 [Yzhums Blog - LockTimeout](https://yzhums.com/67858/)- **Demo**: 

   code .

   ```  1. Creates test data with 100 customers and multiple sales entries



3. **Download Symbols**---  2. Uses `SetAutoCalcFields()` to enable automatic calculation of all FlowFields (Sum, Count, Average, Max) when reading records

   - Configure your `launch.json` with BC environment details

   - Run `AL: Download Symbols`  3. Processes all customers in a single loop without individual `CalcFields()` calls



4. **Build and Publish**### 4. 🆔 Sequential GUID Generation  4. Captures and displays simulated SQL queries showing GROUP BY operations

   ```

   Press F5 or run AL: Publish  5. Shows performance metrics: total time, average time per record

   ```

**Location**: `src/04-GuidCreateSequentialGuid/`- **Key BC 27 Optimization**:

### Running the Demos

  ```al

1. Open Business Central web client

2. Search for **"BC27 Performance Features"**New `Guid.CreateSequentialGuid()` method for database-friendly GUID generation:  Customer.SetAutoCalcFields("Total Sales Amount", "No. of Sales Entries", 

3. Select individual demos from the main page

4. Follow on-screen instructions for each demonstration- Sequential values improve database indexing      "Average Sales Amount", "Last Sales Date");



---- Better clustered index performance  if Customer.FindSet() then



## 🌍 Localization- Reduced page splits and fragmentation      repeat



Full multi-language support with complete translations:          // All FlowFields are calculated automatically - no CalcFields() needed!



| Language | Code | Status | Translations |**Demo**: Performance comparison between standard GUIDs and sequential GUIDs with measurable metrics.          // BC 27 batches these calculations for optimal SQL performance

|----------|------|--------|--------------|

| 🇬🇧 English | en-US | Source | 206 |      until Customer.Next() = 0;

| 🇸🇦 Arabic | ar-SA | ✅ Complete | 206 |

| 🇮🇹 Italian | it-IT | ✅ Complete | 206 |**Benefits**: 📈 Better index performance, 💾 Reduced fragmentation, ⚡ Faster queries  ```

| 🇩🇪 German | de-DE | ✅ Complete | 206 |

| 🇪🇸 Spanish | es-ES | ✅ Complete | 206 |- **Features**:

| 🇩🇰 Danish | da-DK | ✅ Complete | 206 |

---  - **Automatic FlowField Calculation**: Uses `SetAutoCalcFields()` to calculate all FlowFields together

All user-facing text uses AL Labels for proper translation support.

  - **SQL Query Simulation**: Displays the optimized SQL queries (GROUP BY with SUM, COUNT, AVG, MAX)

## ⚙️ Technical Details

### 5. 🗑️ Rec.Truncate() Method  - **Performance Metrics**: Shows calculation time and average time per record

### App Configuration

  - **Query Analysis**: Displays query type, execution time, and row count for each operation

```json

{**Location**: `src/05-RecTruncate/`- **Benefits**: 

  "id": "12345678-1234-1234-1234-123456789012",

  "name": "BC27 Performance Features Demo",  - Dramatically faster report generation with optimized FlowField calculations

  "publisher": "Duilio Tacconi",

  "version": "1.0.0.0",Fast table cleanup using the new `Rec.Truncate()` method:  - Reduced SQL roundtrips (one GROUP BY query instead of N individual queries)

  "runtime": "16.0",

  "application": "27.0.0.0",- Dramatically faster than `DeleteAll()` for large datasets  - Better database performance through optimized SQL execution plans

  "platform": "27.0.0.0"

}- SQL TRUNCATE TABLE under the hood  - Lower resource consumption on SQL Server

```

- Includes important usage restrictions

### Object Range

## Getting Started

- **ID Range**: 55000 - 55100

- **Permission Set**: `DT BC27 Perf` (included)**Demo**: Side-by-side performance comparison between `DeleteAll()` and `Truncate()` with timing metrics.



### Dependencies### Prerequisites



- Microsoft System Application 27.0.0.0**Important**: CodeCop rule AA0475 enforces proper usage:- Business Central 27.0 or later

- Microsoft Base Application 27.0.0.0

- ❌ Cannot use on system tables or tables with media fields- AL Development Environment

## 📊 Performance Monitoring

- ❌ Cannot use inside try functions- Runtime version 16.0 or higher

### Built-in Features

- ❌ Does not trigger OnDelete events

- 📈 Performance Profiler integration

- 🔍 SQL query capture and display### Installation

- ⏱️ Execution time metrics

- 📋 Query log export capabilities**Resources**:1. Clone or download this project



### Recommended Tools- 📖 [Yzhums Blog](https://yzhums.com/67343/)2. Open in VS Code with AL Language extension



- **SQL Server Profiler**: For detailed database monitoring- 📖 [Stefano Demiliani Blog](https://demiliani.com/2025/08/04/dynamics-365-business-central-finally-well-have-truncate-table-in-saas/)3. Download symbols for your BC environment

- **VS Code AL Profiler Extension**: For `.alcpuprofile` analysis

- **Performance Profiler**: Built into Business Central- 📖 [MS Dynamics Blog](https://msdynamicsblogs.com/uncategorized/faster-data-cleanup-in-business-central-2025-wave-2-bc27-with-the-new-rec-truncate-method/)4. Compile and publish the extension



## 🤝 Contributing



This is an educational demonstration project. Contributions are welcome:---## Localization



1. Fork the repository

2. Create a feature branch (`git checkout -b feature/AmazingFeature`)

3. Commit your changes (`git commit -m 'Add AmazingFeature'`)### 6. ⚡ Optimized FlowField CalculationsThis extension includes full Italian (it-IT) translations for all user-facing text:

4. Push to the branch (`git push origin feature/AmazingFeature`)

5. Open a Pull Request- **Total Translations**: 129 complete translations



## 📝 License**Location**: `src/06-OptimizedFlowFieldCalculations/`- **Coverage**: All captions, tooltips, messages, and labels



This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.- **Translation Files**: `Translations/BC27 Performance Features Demo.it-IT.xlf`



## 📚 ResourcesBC 27's `SetAutoCalcFields()` dramatically improves FlowField performance:- **Best Practice**: All user-facing text uses AL Label variables (no hardcoded strings)



### Official Documentation- Batches multiple FlowField calculations together

- 📘 [BC 2025 Wave 2 Release Plan](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/)

- 📘 [Performance Profiler Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/database-wait-statistics)- Reduces SQL roundtrips from N to 1### Supported Languages

- 📘 [AL Development Guide](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)

- Optimized GROUP BY queries- English (en-US) - Source language

### Community Blogs

- 🌐 [Yzhums Blog - BC Performance](https://yzhums.com/)- Italian (it-IT) - Complete translation

- 🌐 [Stefano Demiliani Blog](https://demiliani.com/)

- 🌐 [MS Dynamics Community](https://msdynamicsblogs.com/)**Demo**:



## 👨‍💻 Author1. Creates 1,000 customers with 20-120 sales entries each### Running the Demos



**Duilio Tacconi**2. Uses `SetAutoCalcFields()` for automatic calculation1. Open Business Central

- GitHub: [@duiliotacconi](https://github.com/duiliotacconi)

3. Displays SQL query analysis with execution metrics2. Search for "BC27 Performance Features"

## ⭐ Show Your Support

4. Shows performance improvements vs. individual `CalcFields()` calls3. Run individual demos from the main page

If this project helped you understand BC 27 performance features, give it a ⭐!

4. Monitor performance using the built-in Performance Profiler

---

**Code Example**:

**Note**: This extension requires Business Central 27.0 (2025 Wave 2) or later to function properly. Some features may not work on earlier versions.

```al## Important Notes

Customer.SetAutoCalcFields("No. of Sales Entries", "Last Sales Date");

if Customer.FindSet() then### Rec.Truncate Limitations

    repeat- Can only be used on normal tables (not system tables)

        // All FlowFields calculated automatically - no CalcFields() needed!- Cannot be used on tables with media fields

    until Customer.Next() = 0;- Cannot be used inside try functions (CodeCop rule AA0475)

```- Only works outside of transactions in some cases



**Benefits**: 🚀 Dramatically faster reports, 📉 Reduced SQL load, 💰 Lower resource consumption### Performance Monitoring

- Enable Performance Profiler before running demos

---- Use SQL Server Profiler to see detailed database interactions

- Monitor lock timeouts and retry patterns

## 🚀 Getting Started- **SQL Query Visibility**: The FlowField demo automatically captures and displays SQL queries generated during calculation

  - View query types (SELECT-SUM, SELECT-COUNT, etc.)

### Prerequisites  - See execution times and row counts

  - Download .alcpuprofile files for VS Code analysis

- **Business Central**: Version 27.0 or later (2025 Wave 2)  - Export query logs to Excel for further analysis

- **Development Environment**: VS Code with AL Language extension

- **Runtime**: Version 16.0 or higher## Technical Requirements



### Installation### App.json Configuration

```json

1. **Clone the repository**{

   ```bash    "runtime": "16.0",

   git clone https://github.com/yourusername/BC27-Performance-Features-Demo.git    "application": "27.0.0.0",

   ```    "platform": "27.0.0.0"

}

2. **Open in VS Code**```

   ```bash

   code BC27-Performance-Features-Demo### Dependencies

   ```- Microsoft System Application 27.0.0.0

- Microsoft Base Application 27.0.0.0

3. **Download Symbols**

   - Configure your `launch.json` with BC environment details## Contributing

   - Run `AL: Download Symbols`

This is a demonstration project. Feel free to extend it with additional performance scenarios or improvements.

4. **Build and Publish**

   ```## License

   Press F5 or run AL: Publish

   ```This project is for educational and demonstration purposes.



### Running the Demos## References and Resources



1. Open Business Central web client- [BC 2025 Wave 2 Release Plan](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/)

2. Search for **"BC27 Performance Features"**- [Performance Profiler Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/database-wait-statistics)

3. Select individual demos from the main page- [AL Development Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)

4. Follow on-screen instructions for each demonstration

---

## 🌍 Localization

**Note**: This extension demonstrates BC 27 features and requires Business Central 27.0 or later to function properly.
Full multi-language support with complete translations:

| Language | Code | Status | Translations |
|----------|------|--------|--------------|
| 🇬🇧 English | en-US | Source | 183 |
| �🇦 Arabic | ar-SA | ✅ Complete | 183 |
| �🇮🇹 Italian | it-IT | ✅ Complete | 183 |
| 🇩🇪 German | de-DE | ✅ Complete | 152 |
| 🇪🇸 Spanish | es-ES | ✅ Complete | 148 |
| 🇩🇰 Danish | da-DK | ✅ Complete | 147 |

All user-facing text uses AL Labels for proper translation support.

## ⚙️ Technical Details

### App Configuration

```json
{
  "id": "12345678-1234-1234-1234-123456789012",
  "name": "BC27 Performance Features Demo",
  "publisher": "Duilio Tacconi",
  "version": "1.0.0.0",
  "runtime": "16.0",
  "application": "26.0.0.0",
  "platform": "26.0.0.0"
}
```

### Object Range

- **ID Range**: 55000 - 55100
- **Permission Set**: `DT BC27 Perf` (included)

### Dependencies

No external dependencies required beyond base Business Central 26+.

## 📊 Performance Monitoring

### Built-in Features

- 📈 Performance Profiler integration
- 🔍 SQL query capture and display
- ⏱️ Execution time metrics
- 📋 Query log export capabilities

### Recommended Tools

- **SQL Server Profiler**: For detailed database monitoring
- **VS Code AL Profiler Extension**: For `.alcpuprofile` analysis
- **Performance Profiler**: Built into Business Central

## 🤝 Contributing

This is an educational demonstration project. Contributions are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is provided for **educational and demonstration purposes**. Feel free to use and modify for learning and training.

## 📚 Resources

### Official Documentation
- 📘 [BC 2025 Wave 2 Release Plan](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/)
- 📘 [Performance Profiler Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/database-wait-statistics)
- 📘 [AL Development Guide](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)

### Community Blogs
- 🌐 [Yzhums Blog - BC Performance](https://yzhums.com/)
- 🌐 [Stefano Demiliani Blog](https://demiliani.com/)
- 🌐 [MS Dynamics Community](https://msdynamicsblogs.com/)

## 👨‍💻 Author

**Duilio Tacconi**

## ⭐ Show Your Support

If this project helped you understand BC 27 performance features, give it a ⭐!

---

**Note**: This extension requires Business Central 27.0 (2025 Wave 2) or later to function properly. Some features may not work on earlier versions.
