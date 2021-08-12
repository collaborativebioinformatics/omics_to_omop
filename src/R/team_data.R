#install.packages("devtools")
devtools::install_github("ngiangre/ROMOPOmics",force=T)

library(ROMOPOmics)
library(tidyverse)

dm_file <- 
    system.file("extdata","OMOP_CDM_v6_0_custom.csv",package="ROMOPOmics",mustWork = TRUE)
dm <- 
    loadDataModel(master_table_file = dm_file)

omop_inputs <- 
    list(
        mock_patient =
            readInputFile(
                input_file = "../../data/mock_patient.csv",
                data_model = dm,
                mask_table = loadModelMasks("../../data/mock_patient_mask.csv"),
                transpose_input_table = T
            ),
        team3 =
            readInputFile(
                input_file = "../../data/team3/NA19461.clinicalsv.csv",
                data_model = dm,
                mask_table = loadModelMasks("../../data/team3/NA19461.clinicalsv_mask.csv"),
                transpose_input_table = T
            ),
        team4 =
            readInputFile(
                input_file = "../../data/team4/AR1-T_S4_results_subset.csv",
                data_model = dm,
                mask_table = loadModelMasks("../../data/team4/AR1-T_S4_results_mask.csv"),
                transpose_input_table = T
            ),
        team5 =
            readInputFile(
                input_file = "../../data/team5/GSE75935_SRA_Run_Table_Clean_Human.csv",
                data_model = dm,
                mask_table = loadModelMasks("../../data/team5/GSE75935_SRA_Run_Table_Clean_Human_mask.csv"),
                transpose_input_table = T
            )
    )
db_inputs   <- combineInputTables(input_table_list = omop_inputs)
for(i in seq_along(db_inputs)){
    name_ <- names(db_inputs)[i]
    db_inputs[[i]] %>% 
        write_csv(paste0("../../data/omop_omics/",name_,".csv"))
}
omop_db     <- buildSQLDBR(omop_tables = db_inputs,file.path("../../data","omop_omics.sqlite"))
DBI::dbListTables(omop_db)
DBI::dbDisconnect(omop_db)
