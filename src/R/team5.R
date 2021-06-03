pacman::p_load(tidyverse)

#install.packages("devtools")
devtools::install_github("ngiangre/ROMOPOmics",force=T)

library(ROMOPOmics)

dm_file <- 
    system.file("extdata","OMOP_CDM_v6_0_custom.csv",package="ROMOPOmics",mustWork = TRUE)
dm <- 
    loadDataModel(master_table_file = dm_file)

omop_inputs <- 
    list(
        file=
            readInputFile(
                input_file = "data/team5/GSE75935_SRA_Run_Table_Clean_Human.csv",
                data_model = dm,
                mask_table = loadModelMasks("data/team5/GSE75935_SRA_Run_Table_Clean_Human_mask.csv"),
                transpose_input_table = T
                )
        )
db_inputs   <- combineInputTables(input_table_list = omop_inputs)
omop_db     <- buildSQLDBR(omop_tables = db_inputs,file.path(tempdir(),"mock.sqlite"))
DBI::dbListTables(omop_db)
DBI::dbDisconnect(omop_db)
