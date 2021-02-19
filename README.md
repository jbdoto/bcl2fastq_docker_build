## bcl2fastq Docker Build

This repo contains a Dockerfile to build Illumina's bcl2fastq v2.20.0 on an Ubuntu 18.04 base image.

Details on the software available here:

https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html

You will need to first download the file `bcl2fastq2-v2-20-0-tar.zip`, and place it in the root of this
directory, then build the Dockerfile.

To build Docker file:

    docker build . -t bcl2fastq

To run Docker file, and mount your current directory to container:

     docker run -it -v `pwd`:/scratch bcl2fastq

bcl2fastq expects RunInfo.xml, and sample data to be available in the directory (more on this below).  

# Conda Version

Conda actually has an install for bcl2fastq, so you might not even need this!  

https://anaconda.org/dranew/bcl2fastq

# Sample Data

These repos have some sample data available publicly via GitHub:

https://github.com/broadinstitute/picard/tree/master/testdata/picard/illumina

https://github.com/broadinstitute/picard/tree/49f478a92a46ee41e2618bf084dc59c73093a104/testdata/picard/illumina/IlluminaLaneMetricsCollectorTest/tileRuns

Alternatively, Illumina has sample data available for free on their site, but you must have a BaseSpace account.

# Downloading Sample Data From Illumina

To download sample data, you must have an account on Illumina's BaseSpace system.  They have demo datasets that can 
be imported into your account, and then downloaded at the command line, detailed in the following steps:

1. Setup an account on base space (Free for one month).

2. See this page for a bunch of sample datasets that can be imported into your BaseSpace account: 

    https://www.illumina.com/informatics/sequencing-data-analysis/data-examples.html

    Choose an example, and click the Import button.
3.  install `bs-cli` and download data

```
    brew tap basespace/basespace && brew install bs-cli 

    bs auth # follow onscreen prompts to setup shell

    bs list runs # grab id

    bs download run -i 196529346 -o <some_path>

```

More background on bs-cli here:

https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview

https://support.illumina.com/bulletins/2017/02/options-for-downloading-run-folders-from-basespace-sequence-hub.html

# Running an example conversion

bcl2fastq will look for run data with the following hierarchy.

Of importance are `RunInfo.xml`, and the `Data/` folder.

Run an analysis like this:

    docker run -it -v `pwd`:/scratch bcl2fastq

The data directory layout looks like so:

        ├── COVIDSeq Test Demo - NextSeq 550_196529346.json
        ├── Config
        │   ├── Effective.cfg
        │   ├── FirmwareVersions.txt
        │   ├── NextSeqCalibration.cfg
        │   └── RTAStart.bat
        ├── Data
        │   └── Intensities
        │       ├── BaseCalls
        │       │   ├── 14092-Zymo-IndexSet1-NSQ-AllLanes_S35_L001_R1_001.fastq.gz
        │       │   ├── 14092-Zymo-IndexSet1-NSQ-AllLanes_S35_L002_R1_001.fastq.gz
        │       │   ├── L001
        │       │   │   ├── 0001.bcl.bgzf
        │       │   │   ├── 0001.bcl.bgzf.bci
        │       │   │   ├── 0002.bcl.bgzf
        │       │   ├── L002
        │       │   │   ├── 0001.bcl.bgzf
        │       │   │   ├── 0001.bcl.bgzf.bci
        │       │   │   ├── 0002.bcl.bgzf
        │       │   │   ├── 0002.bcl.bgzf.bci
        │       │   ├── L003
        │       │   │   ├── 0001.bcl.bgzf
        │       │   │   ├── 0001.bcl.bgzf.bci
        │       │   │   ├── 0002.bcl.bgzf
        │       │   ├── L004
        │       │   │   ├── 0001.bcl.bgzf
        │       │   │   ├── 0001.bcl.bgzf.bci
        │       │   │   ├── 0002.bcl.bgzf
        │       │   │   ├── 0002.bcl.bgzf.bci
        │       ├── L001
        │       │   └── s_1.locs
        │       ├── L002
        │       │   └── s_2.locs
        │       ├── L003
        │       │   └── s_3.locs
        │       └── L004
        │           └── s_4.locs
        ├── InstrumentAnalyticsLogs
        │   ├── running__NDXP202RUO__2020-06-25-00.25.00__0375__RunSetup.imf1
        │   ├── running__NDXP202RUO__2020-06-25-00.25.00__0376__Run.imf1
        ├── InterOp
        │   ├── BasecallingMetricsOut.bin
        │   ├── CorrectedIntMetricsOut.bin
        │   ├── EmpiricalPhasingMetricsOut.bin
        │   ├── EventMetricsOut.bin
        │   ├── ExtendedTileMetricsOut.bin
        │   ├── ExtractionMetricsOut.bin
        │   ├── FWHMGridMetricsOut.bin
        │   ├── ImageMetricsOut.bin
        │   ├── PFGridMetricsOut.bin
        │   ├── QGridMetricsOut.bin
        │   ├── QMetrics2030Out.bin
        │   ├── QMetricsByLaneOut.bin
        │   ├── QMetricsOut.bin
        │   ├── RegistrationMetricsOut.bin
        │   ├── TileMetricsOut.bin
        │   └── cache
        │       └── defaultcharts.json
        ├── Logs
        │   └── Logs.zip
        ├── RTAComplete.txt
        ├── RTAConfiguration.xml
        ├── RTALogs
        │   ├── 20200624-1724_GlobalLog_00.tsv
        │   ├── 20200624-1724_GlobalLog_01.tsv
        │   ├── 20200624-1724_GlobalLog_02.tsv
        │   └── 20200624-1724_WarningLog_00.tsv
        ├── RTARead1Complete.txt
        ├── RTARead2Complete.txt
        ├── RTARead3Complete.txt
        ├── Recipe
        │   └── NS4033031-REAGT.xml
        ├── RunCompletionStatus.xml
        ├── RunInfo.xml
        ├── RunParameters.xml
        └── SampleSheet.csv
