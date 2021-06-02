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
        bgdc2021=
            readInputFile(
                input_file = "data/mock/bgdc2021.csv",
                data_model = dm,
                mask_table = loadModelMasks("data/mock/bgdc2021_mask.csv")
                )
        )
db_inputs   <- combineInputTables(input_table_list = omop_inputs)
omop_db     <- buildSQLDBR(omop_tables = db_inputs,file.path(tempdir(),"mock.sqlite"))
DBI::dbListTables(omop_db)
DBI::dbDisconnect()
