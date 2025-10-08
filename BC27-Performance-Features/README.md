# BC27 Performance Features Demo

![Business Central](https://img.shields.io/badge/Business%20Central-27.0-blue) ![AL Language](https://img.shields.io/badge/AL-Runtime%2016.0-green) ![License](https://img.shields.io/badge/License-MIT-orange)

A comprehensive demonstration extension showcasing the new performance features introduced in Microsoft Dynamics 365 Business Central 2025 Wave 2 (Version 27).

## Overview

This AL extension demonstrates six major performance improvements introduced in BC 27:

| Category | Features | Count |
|----------|----------|-------|
| Application | Posting Order, SQL Calls in Profiler | 2 |
| Developer | LockTimeout, Sequential GUID, Rec.Truncate | 3 |
| SQL Optimization | Optimized FlowField Calculations | 1 |

## Project Structure

```
src/
 01-PostingOrder/                    # Improved posting sequence
 02-SQLCallsInPerformanceProfiler/   # SQL visibility in profiler
 03-LockTimeout/                     # Database lock timeout handling
 04-GuidCreateSequentialGuid/        # Sequential GUID generation
 05-RecTruncate/                     # Fast table truncation
 06-OptimizedFlowFieldCalculations/  # Enhanced FlowField performance
 DTBC27PerformanceFeatures.Page.al   # Main demo launcher
```

## Features

### 1. Posting Order Optimization

**Location**: `src/01-PostingOrder/`

BC 27 optimizes the posting sequence in Codeunits 80 (Sales-Post) and 90 (Purch.-Post):
- Uses `SetCurrentKey(Type, \"Line No.\")` to sort lines by Type first
- Reduces the probability of locks through consistent posting sequence
- Improves SQL execution plans

**Demo**: Creates a sales order with 10 mixed-type lines (Item, G/L Account, Resource) in random order. Event subscribers display the optimized posting sequence.

**Benefits**: Faster posting times, reduced lock probability, better SQL performance

---

### 2. SQL Calls in Performance Profiler

**Location**: `src/02-SQLCallsInPerformanceProfiler/`

The Performance Profiler now captures detailed SQL call information:
- View SQL statements executed
- Analyze execution times and row counts
- Download `.alcpuprofile` files for VS Code analysis

**Demo**: Executes various database operations while profiling SQL interactions.

**Resources**:
- [Microsoft Learn Documentation](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/view-sql-call-information-performance-profiles)
- [LinkedIn Article](https://www.linkedin.com/pulse/unlocking-sql-call-insights-performance-profiler-business-saallvi-blkpc/)

---

### 3. LockTimeout Management

**Location**: `src/03-LockTimeout/`

Improved database lock timeout handling with `Database.LockTimeoutDuration`:
- Automatic retry mechanisms
- Configurable timeout durations
- Better concurrency handling

**Demo**: Demonstrates lock timeout scenarios and proper handling patterns.

**Resource**: [Yzhums Blog - LockTimeout](https://yzhums.com/67858/)

---

### 4. Sequential GUID Generation

**Location**: `src/04-GuidCreateSequentialGuid/`

New `Guid.CreateSequentialGuid()` method for database-friendly GUID generation:
- Sequential values improve database indexing
- Better clustered index performance
- Reduced page splits and fragmentation

**Demo**: Performance comparison between standard GUIDs and sequential GUIDs with measurable metrics.

**Benefits**: Better index performance, reduced fragmentation, faster queries

---

### 5. Rec.Truncate() Method

**Location**: `src/05-RecTruncate/`

Fast table cleanup using the new `Rec.Truncate()` method:
- Significantly faster than `DeleteAll()` for large datasets
- Uses SQL TRUNCATE TABLE under the hood
- Includes important usage restrictions

**Demo**: Side-by-side performance comparison between `DeleteAll()` and `Truncate()` with timing metrics.

**Important**: CodeCop rule AA0475 enforces proper usage:
- Cannot use on system tables or tables with media fields
- Cannot use inside try functions
- Does not trigger OnDelete events

**Resources**:
- [Yzhums Blog](https://yzhums.com/67343/)
- [Stefano Demiliani Blog](https://demiliani.com/2025/08/04/dynamics-365-business-central-finally-well-have-truncate-table-in-saas/)
- [MS Dynamics Blog](https://msdynamicsblogs.com/uncategorized/faster-data-cleanup-in-business-central-2025-wave-2-bc27-with-the-new-rec-truncate-method/)

---

### 6. Optimized FlowField Calculations

**Location**: `src/06-OptimizedFlowFieldCalculations/`

BC 27's `SetAutoCalcFields()` improves FlowField performance:
- Batches multiple FlowField calculations together
- Reduces SQL roundtrips from N to 1
- Optimized GROUP BY queries

**Demo**:
1. Creates 1,000 customers with 20-120 sales entries each
2. Uses `SetAutoCalcFields()` for automatic calculation
3. Displays SQL query analysis with execution metrics
4. Shows performance improvements vs. individual `CalcFields()` calls

**Code Example**:
```al
Customer.SetAutoCalcFields(\"No. of Sales Entries\", \"Last Sales Date\");
if Customer.FindSet() then
    repeat
        // All FlowFields calculated automatically - no CalcFields() needed!
    until Customer.Next() = 0;
```

**Benefits**: Faster reports, reduced SQL load, lower resource consumption

---

## Getting Started

### Prerequisites

- **Business Central**: Version 27.0 or later (2025 Wave 2)
- **Development Environment**: VS Code with AL Language extension
- **Runtime**: Version 16.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/duiliotacconi/DT.AL.git
   cd DT.AL/BC27-Performance-Features
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```

3. **Download Symbols**
   - Configure your `launch.json` with BC environment details
   - Run `AL: Download Symbols`

4. **Build and Publish**
   ```
   Press F5 or run AL: Publish
   ```

### Running the Demos

1. Open Business Central web client
2. Search for **\"BC27 Performance Features\"**
3. Select individual demos from the main page
4. Follow on-screen instructions for each demonstration

---

## Localization

Full multi-language support with complete translations:

| Language | Code | Status | Translations |
|----------|------|--------|--------------|
| English | en-US | Source | 206 |
| Arabic | ar-SA | Complete | 206 |
| Italian | it-IT | Complete | 206 |
| German | de-DE | Complete | 206 |
| Spanish | es-ES | Complete | 206 |
| Danish | da-DK | Complete | 206 |

All user-facing text uses AL Labels for proper translation support.

## Technical Details

### App Configuration

```json
{
  \"id\": \"12345678-1234-1234-1234-123456789012\",
  \"name\": \"BC27 Performance Features Demo\",
  \"publisher\": \"Duilio Tacconi\",
  \"version\": \"1.0.0.0\",
  \"runtime\": \"16.0\",
  \"application\": \"27.0.0.0\",
  \"platform\": \"27.0.0.0\"
}
```

### Object Range

- **ID Range**: 55000 - 55100
- **Permission Set**: `DT BC27 Perf` (included)

### Dependencies

- Microsoft System Application 27.0.0.0
- Microsoft Base Application 27.0.0.0

## Performance Monitoring

### Built-in Features

- Performance Profiler integration
- SQL query capture and display
- Execution time metrics
- Query log export capabilities

### Recommended Tools

- **SQL Server Profiler**: For detailed database monitoring
- **VS Code AL Profiler Extension**: For `.alcpuprofile` analysis
- **Performance Profiler**: Built into Business Central

## Contributing

This is an educational demonstration project. Contributions are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

### Official Documentation
- [BC 2025 Wave 2 Release Plan](https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/)
- [Performance Profiler Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/database-wait-statistics)
- [AL Development Guide](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)

### Community Blogs
- [Yzhums Blog - BC Performance](https://yzhums.com/)
- [Stefano Demiliani Blog](https://demiliani.com/)
- [MS Dynamics Community](https://msdynamicsblogs.com/)

## Author

**Duilio Tacconi**
- GitHub: [@duiliotacconi](https://github.com/duiliotacconi)

---

**Note**: This extension requires Business Central 27.0 (2025 Wave 2) or later to function properly.
