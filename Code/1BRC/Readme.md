# 1 Billion Rows Challenge

Based on the idea of the original [1BRC](https://1brc.dev), this is an adaptation for R, but not restricted to the base R functions. Its idea is to compare several approaches:

-   base R
-   with parallelization
-   with tapply
-   with aggregate
-   with datatable
-   with dplyr
-   with DuckDB

Some of the examples also mix several approaches, eg. dplyr data handling with datatable file read.  
Additionally, for the dplyr and the DuckDB version, there is also a variant with parquet files implemented.

## Code

Main script is benchmark.R. It loads the various functions. The data is supposed to be a file with 1G records. In our case, we generate the file on the fly based on average temperatures of 413 measurement stations around the globe, using `rnorm()` to generate random values. The functions calculate min, median and max values for each of the measurement stations.

Unfortunately, our office infrastructure does not handle files with 1G records. Therefore, we have to run this with 100 million records. You may want to check it on your private infrastructure.

There should be two files in the `Data` folder after running `gen_values()`: a plain text file (with delimiter `;`) as well as a parquet file. They use up to 15GB of disk space (for 1 billion rows).

By default, the benchmark is run three times. More would be better; however, the runtime is already quite high and the used up memory is so high that the system runs into overflows. Some of the approaches aren't included in the benchmark because they use way too much time (around 1h for 1 iteration).

This setup shows a clear winner: using [DuckDB](https://duckdb.org) with parquet files. DuckDB is a fast in-process analytical database. In our case, we basically "pretend" to use the database; the calculations are done in a SQL query.  
There is also another very fast setup: using `arrow`. When using arrow objects, you can basically apply any (more or less) verbs of e.g. dplyr, which are internally translated, but which is for large dataset much faster.  
The repo shoud encourage to use such a setup in a productive case where large datasets are involved.

Feel free to enter your own results.

## Results

| *Machine*             | *\# records* | *approach*        | *runtime in s (median)* |
|------------------|------------------|------------------|-------------------|
| sszbad private laptop | 1G           | dplyr             | 74.4                    |
| sszbad private laptop | 1G           | data.table        | 74.4                    |
| sszbad private laptop | 1G           | DuckDB            | 6.45                    |
| sszbad private laptop | 1G           | dplyr w/ arrow    | 4.5                     |
| sszbad private laptop | 1G           | DuckDB w/ parquet | 2.14                    |
| sszbad private laptop | 100M         | dplyr             | 5.89                    |
| sszbad private laptop | 100M         | data.table        | 6.38                    |
| sszbad private laptop | 100M         | DuckDB            | 0.72                    |
| sszbad private laptop | 100M         | dplyr w/ arrow    | 0.59                    |
| sszbad private laptop | 100M         | DuckDB w/ parquet | 0.29                    |
| sszbad VDI            | 100M         | dplyr             | 10.99                   |
| sszbad VDI            | 100M         | data.table        | 8.68                    |
| sszbad VDI            | 100M         | DuckDB            | 3.92                    |
| sszbad VDI            | 100M         | dplyr w/ arrow    | tbd                     |
| sszbad VDI            | 100M         | DuckDB w/ parquet | 1.71                    |
|                       |              |                   |                         |
|                       |              |                   |                         |
|                       |              |                   |                         |
|                       |              |                   |                         |
|                       |              |                   |                         |
